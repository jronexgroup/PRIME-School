import 'dart:io';
import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class SarvamService {
  final Dio _dio = Dio();
  String? _apiKey;

  void setApiKey(String key) {
    _apiKey = key;
  }

  bool get hasApiKey => _apiKey != null && _apiKey!.isNotEmpty;

  Future<String> chat(String message, String context) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      return 'ত্রুটি: Sarvam API কী সেট করা হয়নি। দয়া করে সেটিংস থেকে API কী কনফিগার করুন।';
    }

    try {
      final response = await _dio.post(
        '${ApiConstants.cloudflareWorkerUrl}${ApiConstants.sarvamEndpoint}',
        data: {
          'key': _apiKey,
          'prompt': message,
          'context': context,
        },
        options: Options(
          receiveTimeout: ApiConstants.requestTimeout,
          sendTimeout: ApiConstants.requestTimeout,
        ),
      );
      return response.data['response'] ?? 'উত্তর পাওয়া যায়নি।';
    } catch (e) {
      return 'ত্রুটি: Sarvam AI এর সাথে যোগাযোগ করা যায়নি। ($e)';
    }
  }

  Future<String?> textToSpeech(String text, {String language = 'bn'}) async {
    if (_apiKey == null || _apiKey!.isEmpty) return null;

    try {
      final response = await _dio.post(
        '${ApiConstants.cloudflareWorkerUrl}${ApiConstants.sarvamEndpoint}/tts',
        data: {
          'key': _apiKey,
          'text': text,
          'language': language,
        },
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: ApiConstants.requestTimeout,
        ),
      );

      if (response.data is List<int>) {
        final audioBytes = response.data as List<int>;
        final tempDir = '/tmp';
        final filePath = '$tempDir/sarvam_audio_${DateTime.now().millisecondsSinceEpoch}.wav';
        await File(filePath).writeAsBytes(audioBytes);
        return filePath;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String> generateQuestions(String topicContent, String type, int count) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      return 'API key not configured';
    }

    try {
      final response = await _dio.post(
        '${ApiConstants.cloudflareWorkerUrl}${ApiConstants.sarvamEndpoint}',
        data: {
          'key': _apiKey,
          'prompt': '''
Generate $count $type questions in Bengali based on this topic content.
Return ONLY a valid JSON array with no markdown formatting.

Each question should have these fields:
- For MCQ: question (String), options (List of 4 Strings), correctIndex (int), explanation (String), marks (int)
- For other types: question (String), answer (String), marks (int)

Topic Content:
$topicContent

Generate questions that are specific to this content, not generic.
Return ONLY the JSON array, nothing else.
''',
          'context': 'You are a Bengali education expert creating exam questions for Class 9 History students.',
        },
        options: Options(
          receiveTimeout: ApiConstants.requestTimeout,
          sendTimeout: ApiConstants.requestTimeout,
        ),
      );
      return response.data['response'] ?? '[]';
    } catch (e) {
      return '[]';
    }
  }
}
