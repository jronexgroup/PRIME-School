import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class SmartNote {
  final String id;
  String title;
  String content;
  final DateTime createdAt;
  DateTime updatedAt;
  List<String> tags;
  String? sourceImagePath;
  String? subjectId;

  SmartNote({
    required this.id,
    this.title = '',
    this.content = '',
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    this.sourceImagePath,
    this.subjectId,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        tags = tags ?? [];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'tags': tags,
    'sourceImagePath': sourceImagePath,
    'subjectId': subjectId,
  };

  factory SmartNote.fromJson(Map<String, dynamic> json) => SmartNote(
    id: json['id'] as String,
    title: json['title'] as String? ?? '',
    content: json['content'] as String? ?? '',
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : null,
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'] as String)
        : null,
    tags: List<String>.from(json['tags'] ?? []),
    sourceImagePath: json['sourceImagePath'] as String?,
    subjectId: json['subjectId'] as String?,
  );
}

class SmartNotesService {
  static const _boxName = 'smart_notes';
  late Box _box;
  final _uuid = const Uuid();

  Future<void> initialize() async {
    _box = await Hive.openBox(_boxName);
  }

  List<SmartNote> getAllNotes() {
    final notes = <SmartNote>[];
    for (final key in _box.keys) {
      final data = _box.get(key) as Map<String, dynamic>?;
      if (data != null) notes.add(SmartNote.fromJson(data));
    }
    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return notes;
  }

  SmartNote? getNote(String id) {
    final data = _box.get(id) as Map<String, dynamic>?;
    return data != null ? SmartNote.fromJson(data) : null;
  }

  Future<SmartNote> createNote({
    String title = '',
    String content = '',
    List<String>? tags,
    String? sourceImagePath,
    String? subjectId,
  }) async {
    final note = SmartNote(
      id: _uuid.v4(),
      title: title,
      content: content,
      tags: tags,
      sourceImagePath: sourceImagePath,
      subjectId: subjectId,
    );
    await _box.put(note.id, note.toJson());
    return note;
  }

  Future<void> updateNote(SmartNote note) async {
    note.updatedAt = DateTime.now();
    await _box.put(note.id, note.toJson());
  }

  Future<void> deleteNote(String id) async {
    await _box.delete(id);
  }

  List<SmartNote> searchNotes(String query) {
    final q = query.toLowerCase();
    return getAllNotes().where((n) =>
      n.title.toLowerCase().contains(q) ||
      n.content.toLowerCase().contains(q) ||
      n.tags.any((t) => t.toLowerCase().contains(q))
    ).toList();
  }

  List<SmartNote> getNotesBySubject(String subjectId) =>
      getAllNotes().where((n) => n.subjectId == subjectId).toList();

  void dispose() {
    _box.close();
  }
}
