import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class AiService {
  final Dio _dio = Dio();
  final List<String> _geminiKeys = [];
  final List<String> _groqKeys = [];
  int _currentGeminiKey = 0;
  int _currentGroqKey = 0;
  String _cloudflareWorkerUrl = ApiConstants.cloudflareWorkerUrl;
  String _cloudflareAccountId = '';
  String _cloudflareApiToken = '';

  void setGeminiKeys(List<String> keys) {
    _geminiKeys.clear();
    _geminiKeys.addAll(keys.where((k) => k.isNotEmpty));
    _currentGeminiKey = 0;
  }

  void setGroqKeys(List<String> keys) {
    _groqKeys.clear();
    _groqKeys.addAll(keys.where((k) => k.isNotEmpty));
    _currentGroqKey = 0;
  }

  void setCloudflareWorkerUrl(String url) {
    if (url.isNotEmpty) {
      _cloudflareWorkerUrl = url;
    }
  }

  void setCloudflareCredentials(String accountId, String apiToken) {
    _cloudflareAccountId = accountId;
    _cloudflareApiToken = apiToken;
  }

  bool get hasCloudflareCredentials => _cloudflareAccountId.isNotEmpty && _cloudflareApiToken.isNotEmpty;
  bool get hasAnyKeys => hasCloudflareCredentials || _geminiKeys.isNotEmpty || _groqKeys.isNotEmpty;

  Future<String> generateWithCloudflareDirect(String prompt, {String? context}) async {
    final model = '@cf/meta/llama-3.1-8b-instruct';
    final url = 'https://api.cloudflare.com/client/v4/accounts/$_cloudflareAccountId/ai/run/$model';

    final messages = <Map<String, String>>[
      {'role': 'system', 'content': 'You are a helpful Python tutor. Answer in Hinglish (Hindi+English mix) like CodeWithHarry. Be concise and clear.'},
      {'role': 'user', 'content': context != null ? '$context\n\n$prompt' : prompt},
    ];

    try {
      final response = await _dio.post(
        url,
        data: {'messages': messages},
        options: Options(
          headers: {'Authorization': 'Bearer $_cloudflareApiToken'},
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 30),
        ),
      );
      return response.data['result']['response'] as String? ?? '';
    } on DioException catch (e) {
      throw Exception('Cloudflare AI error: ${e.response?.statusCode ?? e.message}');
    }
  }

  Future<String> generateWithGemini(String prompt, {String? context}) async {
    for (var i = 0; i < _geminiKeys.length; i++) {
      try {
        final response = await _dio.post(
          '$_cloudflareWorkerUrl${ApiConstants.geminiEndpoint}',
          data: {
            'key': _geminiKeys[_currentGeminiKey],
            'prompt': prompt,
            'context': context,
          },
          options: Options(
            receiveTimeout: ApiConstants.requestTimeout,
            sendTimeout: ApiConstants.requestTimeout,
          ),
        );
        return response.data['response'];
      } catch (e) {
        _currentGeminiKey = (_currentGeminiKey + 1) % _geminiKeys.length;
      }
    }
    throw Exception('All Gemini keys exhausted');
  }

  Future<String> generateWithGroq(String prompt, {String? context}) async {
    for (var i = 0; i < _groqKeys.length; i++) {
      try {
        final response = await _dio.post(
          '$_cloudflareWorkerUrl${ApiConstants.groqEndpoint}',
          data: {
            'key': _groqKeys[_currentGroqKey],
            'prompt': prompt,
            'context': context,
          },
          options: Options(
            receiveTimeout: ApiConstants.requestTimeout,
            sendTimeout: ApiConstants.requestTimeout,
          ),
        );
        return response.data['response'];
      } catch (e) {
        _currentGroqKey = (_currentGroqKey + 1) % _groqKeys.length;
      }
    }
    throw Exception('All Groq keys exhausted');
  }

  Future<String> generate(String prompt, {String? context}) async {
    if (hasCloudflareCredentials) {
      try {
        return await generateWithCloudflareDirect(prompt, context: context);
      } catch (_) {}
    }
    try {
      return await generateWithGemini(prompt, context: context);
    } catch (_) {
      try {
        return await generateWithGroq(prompt, context: context);
      } catch (e) {
        if (hasCloudflareCredentials) {
          throw Exception('Cloudflare AI failed. Check your Account ID and API Token in Settings.');
        }
        throw Exception('All AI providers exhausted. Add API keys in Settings.');
      }
    }
  }

  Future<String> chatWithTopic(String message, String topicContent) async {
    final prompt = '''
You are a helpful Python tutor. Answer based on this content.
Question: $message
Topic Content: $topicContent
''';
    return generate(prompt);
  }

  Future<String> checkAnswer(String question, String userAnswer, String correctAnswer) async {
    final prompt = '''
Check this Python answer and provide feedback:
Question: $question
User's Answer: $userAnswer
Correct Answer: $correctAnswer

Provide: 1) Is it correct (yes/no) 2) What's wrong 3) Brief explanation in Hinglish
''';
    return generate(prompt);
  }

  Future<String> reviewCode(String code, String question) async {
    final prompt = '''
Review this Python code and provide feedback:
Question: $question
Code:
$code

Provide: 1) Is it correct 2) Code quality 3) Better approach 4) How Harry would write it
Be constructive and specific.
''';
    return generate(prompt);
  }
}
