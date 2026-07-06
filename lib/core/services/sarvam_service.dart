import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SarvamService {
  final Dio _dio = Dio();
  String? _customKey;

  static const String _defaultKey = 'sk_f9xingij_yhFq7DU468sOK0f5y61TSTUJ';
  static const String _apiUrl = 'https://api.sarvam.ai/v1/chat/completions';

  void setApiKey(String key) {
    _customKey = key;
  }

  String get _key => _customKey ?? _defaultKey;
  bool get hasApiKey => _key.isNotEmpty;

  Future<String> chat(String message, String context) async {
    try {
      final response = await _dio.post(
        _apiUrl,
        data: {
          'model': 'sarvam-105b',
          'messages': [
            {'role': 'system', 'content': 'You are a Bengali education expert. Answer in simple Bengali suitable for Class 9 students. Be patient and encouraging.'},
            {'role': 'user', 'content': 'Context: $context\n\nQuestion: $message'},
          ],
          'temperature': 0.3,
          'max_tokens': 4096,
        },
        options: Options(
          headers: {'api-subscription-key': _key},
          receiveTimeout: const Duration(seconds: 120),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      final result = response.data;
      if (result is Map && result['choices'] is List) {
        final choices = result['choices'] as List;
        if (choices.isNotEmpty && choices[0] is Map) {
          final msg = (choices[0] as Map)['message'];
          if (msg is Map) return msg['content'] as String? ?? 'উত্তর পাওয়া যায়নি।';
        }
      }
      return 'উত্তর পাওয়া যায়নি।';
    } catch (e) {
      return 'ত্রুটি: Sarvam AI এর সাথে যোগাযোগ করা যায়নি। ($e)';
    }
  }

  Future<String?> textToSpeech(String text, {String language = 'bn'}) async {
    try {
      final response = await _dio.post(
        'https://api.sarvam.ai/v1/text-to-speech',
        data: {
          'text': text,
          'target_language_code': language,
          'model': 'bulbul:v2',
          'speaker': 'anushka',
        },
        options: Options(
          headers: {'api-subscription-key': _key},
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.data is List<int>) {
        final tempDir = '/tmp';
        final filePath = '$tempDir/sarvam_audio_${DateTime.now().millisecondsSinceEpoch}.wav';
        await File(filePath).writeAsBytes(response.data as List<int>);
        return filePath;
      }
      return null;
    } catch (e) {
      debugPrint('Sarvam TTS error: $e');
      return null;
    }
  }

  Future<String> generateQuestions(String topicContent, String type, int count) async {
    try {
      final response = await _dio.post(
        _apiUrl,
        data: {
          'model': 'sarvam-105b',
          'messages': [
            {'role': 'system', 'content': 'You are a Bengali education expert creating exam questions for Class 9 students.'},
            {'role': 'user', 'content': 'Generate $count $type questions in Bengali based on this topic content.\nReturn ONLY a valid JSON array with no markdown formatting.\n\nEach question should have these fields:\n- For MCQ: question (String), options (List of 4 Strings), correctIndex (int), explanation (String), marks (int)\n- For other types: question (String), answer (String), marks (int)\n\nTopic Content:\n$topicContent\n\nGenerate questions that are specific to this content, not generic.\nReturn ONLY the JSON array, nothing else.'},
          ],
          'temperature': 0.3,
          'max_tokens': 4096,
        },
        options: Options(
          headers: {'api-subscription-key': _key},
          receiveTimeout: const Duration(seconds: 120),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      final result = response.data;
      if (result is Map && result['choices'] is List) {
        final choices = result['choices'] as List;
        if (choices.isNotEmpty && choices[0] is Map) {
          final msg = (choices[0] as Map)['message'];
          if (msg is Map) {
            final text = msg['content'] as String? ?? '';
            if (text.isNotEmpty) return text;
          }
        }
      }
      return '[]';
    } catch (e) {
      debugPrint('Sarvam generateQuestions error: $e');
      return '[]';
    }
  }
}
