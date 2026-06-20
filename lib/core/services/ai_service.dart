import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class AiService {
  final Dio _dio = Dio();
  final List<String> _geminiKeys = [];
  final List<String> _groqKeys = [];
  int _currentGeminiKey = 0;
  int _currentGroqKey = 0;

  void setGeminiKeys(List<String> keys) {
    _geminiKeys.clear();
    _geminiKeys.addAll(keys);
  }

  void setGroqKeys(List<String> keys) {
    _groqKeys.clear();
    _groqKeys.addAll(keys);
  }

  Future<String> generateWithGemini(String prompt, {String? context}) async {
    for (var i = 0; i < _geminiKeys.length; i++) {
      try {
        final response = await _dio.post(
          '${ApiConstants.cloudflareWorkerUrl}${ApiConstants.geminiEndpoint}',
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
          '${ApiConstants.cloudflareWorkerUrl}${ApiConstants.groqEndpoint}',
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
    try {
      return await generateWithGemini(prompt, context: context);
    } catch (e) {
      try {
        return await generateWithGroq(prompt, context: context);
      } catch (e) {
        throw Exception('All AI providers exhausted');
      }
    }
  }

  Future<String> generateQuiz(String topicContent, String type) async {
    final prompt = '''
Generate $type questions based on this content:
$topicContent

Return as JSON array with fields: question, answer, options (for MCQ), explanation, marks
''';
    return generate(prompt);
  }

  Future<String> generateFlashcards(String topicContent) async {
    final prompt = '''
Generate flashcards based on this content:
$topicContent

Return as JSON array with fields: front, back, bengaliFront, bengaliBack
''';
    return generate(prompt);
  }

  Future<String> chatWithTopic(String message, String topicContent) async {
    final prompt = '''
You are a helpful tutor. Answer this question based ONLY on the provided content.
If the answer is not in the content, respond in Bengali: "এই topic এ এই তথ্য নেই। তুমি কি অন্য কিছু জিজ্ঞেস করতে চাও?"

Question: $message

Topic Content:
$topicContent
''';
    return generate(prompt);
  }

  Future<String> checkAnswer(String question, String userAnswer, String correctAnswer) async {
    final prompt = '''
Check this answer and provide feedback:
Question: $question
User's Answer: $userAnswer
Correct Answer: $correctAnswer

Provide: 1) Is it correct (yes/no), 2) Brief explanation
''';
    return generateWithGroq(prompt);
  }
}
