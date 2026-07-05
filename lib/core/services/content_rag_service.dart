import 'firestore_service.dart';
import 'ai_service.dart';

class ContentRagService {
  final FirestoreService _firestore;
  final AiService _ai;

  final Map<String, Map<String, dynamic>> _allTopicsCache = {};
  List<Map<String, dynamic>> _roadmapCache = [];
  bool _isLoaded = false;

  ContentRagService({
    required FirestoreService firestore,
    required AiService ai,
  })  : _firestore = firestore,
        _ai = ai;

  Future<void> loadAllPythonContent() async {
    if (_isLoaded) return;
    try {
      _roadmapCache = await _firestore.getTechRoadmap('python');
      final chapters = await _firestore.getChapters('python');
      for (final ch in chapters) {
        final topics = await _firestore.getTopics('python', ch.id);
        for (final t in topics) {
          final content = await _firestore.getTechTopicContent('python', ch.id, t.id);
          _allTopicsCache['${ch.id}/${t.id}'] = {
            ...content,
            'chapterName': ch.name,
            'topicName': t.name,
          };
        }
      }
      _isLoaded = true;
    } catch (_) {}
  }

  String getAllContentAsContext() {
    if (_allTopicsCache.isEmpty) return 'No Python content loaded.';
    final buffer = StringBuffer();
    buffer.writeln('=== COMPLETE PYTHON COURSE CONTENT ===\n');
    for (final entry in _allTopicsCache.entries) {
      final data = entry.value;
      buffer.writeln('--- ${data['chapterName']} > ${data['topicName']} ---');
      if (data['keyPoints'] != null) {
        buffer.writeln('Key Points: ${(data['keyPoints'] as List).join(' | ')}');
      }
      if (data['importantSyntax'] != null) {
        buffer.writeln('Syntax: ${(data['importantSyntax'] as List).map((s) => s['syntax']).join(', ')}');
      }
      if (data['commonMistakes'] != null) {
        buffer.writeln('Common Mistakes: ${(data['commonMistakes'] as List).join(' | ')}');
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  String getTopicsInRange(int startOrder, int endOrder) {
    final topics = _roadmapCache.where((r) {
      final order = r['order'] as int;
      return order >= startOrder && order <= endOrder;
    }).toList();
    final buffer = StringBuffer();
    for (final t in topics) {
      final path = '${t['chapterId']}/${t['topicId']}';
      final data = _allTopicsCache[path];
      if (data != null) {
        buffer.writeln('--- ${data['topicName']} ---');
        if (data['keyPoints'] != null) {
          buffer.writeln('Key Points: ${(data['keyPoints'] as List).join(' | ')}');
        }
        buffer.writeln();
      }
    }
    return buffer.toString();
  }

  String getChapterContent(String chapterId) {
    final buffer = StringBuffer();
    final topics = _roadmapCache.where((r) => r['chapterId'] == chapterId).toList();
    for (final t in topics) {
      final path = '${t['chapterId']}/${t['topicId']}';
      final data = _allTopicsCache[path];
      if (data != null) {
        buffer.writeln('--- ${data['topicName']} ---');
        if (data['keyPoints'] != null) {
          buffer.writeln('Key Points: ${(data['keyPoints'] as List).join(' | ')}');
        }
        buffer.writeln();
      }
    }
    return buffer.toString();
  }

  Future<String> ask(String question) async {
    await loadAllPythonContent();
    final context = getAllContentAsContext();
    final prompt = '''
You are a Python tutor assistant. You have access to the COMPLETE Python course content below.
Answer the user's question based on this content. Be helpful, use Hinglish (Hindi+English mix) like CodeWithHarry.
If the question is not related to Python or the content, politely say you can only answer Python-related questions.

$context

User Question: $question
''';
    return _ai.generate(prompt);
  }

  Future<String> askWithChapter(String question, String chapterId) async {
    await loadAllPythonContent();
    final context = getChapterContent(chapterId);
    final prompt = '''
You are a Python tutor. Answer based on this chapter content:

$context

User Question: $question
''';
    return _ai.generate(prompt);
  }

  bool get isLoaded => _isLoaded;
  int get topicCount => _allTopicsCache.length;
}
