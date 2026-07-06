import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
    final model = '@cf/moonshotai/kimi-k2.6';
    final url = 'https://api.cloudflare.com/client/v4/accounts/$_cloudflareAccountId/ai/run/$model';

    final messages = <Map<String, String>>[
      {'role': 'system', 'content': 'You are a friendly Python tutor for beginners. Explain concepts like teaching a child — use simple words, relatable examples, and break things down step by step. Always include easy-to-understand code examples. Be patient and encouraging.'},
      {'role': 'user', 'content': context != null ? '$context\n\n$prompt' : prompt},
    ];

    try {
      final response = await _dio.post(
        url,
        data: {
          'messages': messages,
          'chat_template_kwargs': {'thinking': false},
        },
        options: Options(
          headers: {'Authorization': 'Bearer $_cloudflareApiToken'},
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 30),
        ),
      );
      final result = response.data;
      debugPrint('Cloudflare AI raw response: $result');
      String text = '';
      if (result is Map) {
        // Cloudflare wraps the real response in {result: {...}, success: true}
        // The inner result uses OpenAI-compatible format:
        // {choices: [{message: {content: "..."}}]}
        Map data = result;
        if (result['result'] is Map) data = result['result'] as Map;

        // OpenAI-compatible format: data = {choices: [{message: {content: "..."}}]}
        if (data['choices'] is List) {
          final choices = data['choices'] as List;
          if (choices.isNotEmpty && choices[0] is Map) {
            final msg = (choices[0] as Map)['message'];
            if (msg is Map) text = msg['content'] as String? ?? '';
          }
        }
        // Legacy format: data = {response: "..."}
        if (text.isEmpty) {
          text = data['response'] as String? ?? data['content'] as String? ?? '';
        }
      }
      if (text.trim().isEmpty) {
        debugPrint('Cloudflare AI: empty response — full result: $result');
        return 'I reviewed your code but could not generate specific feedback right now. Check the solution example for guidance.';
      }
      return text;
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
Teach like explaining to a child. Use very simple words, relatable everyday examples, and step-by-step reasoning. Include a short code example.

Topic Content: $topicContent
User Question: $message
''';
    return generate(prompt);
  }

  Future<String> checkAnswer(String question, String userAnswer, String correctAnswer) async {
    final prompt = '''
Act like a kind teacher helping a beginner student. Check their Python answer and explain like you're talking to a child.
Your response MUST start with exactly "✓ CORRECT" if the answer is correct, or "✗ INCORRECT" if wrong.
Then explain why in simple words with an example.

Question: $question
Student's Code: $userAnswer
Expected Solution: $correctAnswer
''';
    return generate(prompt);
  }

  Future<String> reviewCode(String code, String question) async {
    final prompt = '''
Review this Python code like a friendly tutor helping a beginner. Point out what's good first, then suggest improvements in simple words with before/after code examples.

Goal: $question
Code:
$code
''';
    return generate(prompt);
  }
}
