import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AiService {
  final Dio _dio = Dio();

  // Sarvam AI (primary provider — always available with default key)
  static const String _sarvamApiKey = 'sk_f9xingij_yhFq7DU468sOK0f5y61TSTUJ';
  static const String _sarvamUrl = 'https://api.sarvam.ai/v1/chat/completions';
  String? _customSarvamKey;

  // Legacy providers (mostly broken)
  static const String _cloudflareWorkerUrl = 'https://prime-school-api.jronex.workers.dev';
  final List<String> _geminiKeys = [];
  final List<String> _groqKeys = [];
  int _currentGeminiKey = 0;
  int _currentGroqKey = 0;
  String _cloudflareAccountId = '';
  String _cloudflareApiToken = '';

  void setSarvamApiKey(String key) {
    _customSarvamKey = key;
  }

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
    // Kept for backward compatibility — no longer used
  }

  void setCloudflareCredentials(String accountId, String apiToken) {
    _cloudflareAccountId = accountId;
    _cloudflareApiToken = apiToken;
  }

  bool get hasCloudflareCredentials => _cloudflareAccountId.isNotEmpty && _cloudflareApiToken.isNotEmpty;
  bool get hasAnyKeys => true; // Sarvam always available via default key

  Future<String> generateWithSarvam(String prompt, {String? context}) async {
    final key = _customSarvamKey ?? _sarvamApiKey;
    final messages = <Map<String, String>>[
      {'role': 'system', 'content': 'You are a friendly tutor for Indian students. Explain concepts like teaching a child — use simple words, relatable examples, and break things down step by step. Be patient and encouraging.'},
      {'role': 'user', 'content': context != null ? '$context\n\n$prompt' : prompt},
    ];

    try {
      final response = await _dio.post(
        _sarvamUrl,
        data: {
          'model': 'sarvam-105b',
          'messages': messages,
          'temperature': 0.3,
          'max_tokens': 4096,
        },
        options: Options(
          headers: {'api-subscription-key': key},
          receiveTimeout: const Duration(seconds: 120),
          sendTimeout: const Duration(seconds: 30),
        ),
      );
      final result = response.data;
      debugPrint('Sarvam AI raw response: $result');

      if (result is Map && result['choices'] is List) {
        final choices = result['choices'] as List;
        if (choices.isNotEmpty && choices[0] is Map) {
          final msg = (choices[0] as Map)['message'];
          if (msg is Map) {
            final text = msg['content'] as String? ?? '';
            if (text.trim().isNotEmpty) return text;
          }
        }
      }
      // Fallback: try response field
      if (result is Map) {
        final text = result['response'] as String? ?? '';
        if (text.trim().isNotEmpty) return text;
      }
      debugPrint('Sarvam AI: empty response — full result: $result');
      return 'I could not generate a response right now. Please try again.';
    } on DioException catch (e) {
      debugPrint('Sarvam AI error: ${e.response?.statusCode} ${e.response?.data}');
      throw Exception('Sarvam AI error: ${e.response?.statusCode ?? e.message}');
    }
  }

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
          '$_cloudflareWorkerUrl/gemini',
          data: {
            'key': _geminiKeys[_currentGeminiKey],
            'prompt': prompt,
            'context': context,
          },
          options: Options(
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
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
          '$_cloudflareWorkerUrl/groq',
          data: {
            'key': _groqKeys[_currentGroqKey],
            'prompt': prompt,
            'context': context,
          },
          options: Options(
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
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
    // 1. Try Sarvam AI (primary — always available with default key)
    try {
      return await generateWithSarvam(prompt, context: context);
    } catch (e) {
      debugPrint('Sarvam AI failed, trying fallbacks: $e');
    }

    // 2. Try Cloudflare Direct
    if (hasCloudflareCredentials) {
      try {
        return await generateWithCloudflareDirect(prompt, context: context);
      } catch (_) {}
    }

    // 3. Try Gemini (via worker)
    try {
      return await generateWithGemini(prompt, context: context);
    } catch (_) {
      // 4. Try Groq (via worker)
      try {
        return await generateWithGroq(prompt, context: context);
      } catch (e) {
        if (hasCloudflareCredentials) {
          throw Exception('All AI providers failed. Check your API keys in Settings.');
        }
        throw Exception('Failed to generate response. Please try again.');
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
