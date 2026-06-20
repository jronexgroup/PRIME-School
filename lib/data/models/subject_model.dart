import 'package:equatable/equatable.dart';
import 'chapter_model.dart';

class SubjectModel extends Equatable {
  final String id;
  final String name;
  final String icon;
  final String side;
  final int totalChapters;
  final List<ChapterModel> chapters;
  final double progress;

  const SubjectModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.side,
    this.totalChapters = 0,
    this.chapters = const [],
    this.progress = 0.0,
  });

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      icon: map['icon'] ?? '',
      side: map['side'] ?? 'school',
      totalChapters: map['totalChapters'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'side': side,
      'totalChapters': totalChapters,
    };
  }

  SubjectModel copyWith({
    List<ChapterModel>? chapters,
    double? progress,
  }) {
    return SubjectModel(
      id: id,
      name: name,
      icon: icon,
      side: side,
      totalChapters: totalChapters,
      chapters: chapters ?? this.chapters,
      progress: progress ?? this.progress,
    );
  }

  static List<SubjectModel> schoolSubjects = const [
    SubjectModel(id: 'history', name: 'History', icon: '📜', side: 'school', totalChapters: 12),
    SubjectModel(id: 'life_science', name: 'Life Science', icon: '🔬', side: 'school', totalChapters: 15),
    SubjectModel(id: 'physical_science', name: 'Physical Science', icon: '⚗️', side: 'school', totalChapters: 14),
    SubjectModel(id: 'mathematics', name: 'Mathematics', icon: '📐', side: 'school', totalChapters: 16),
    SubjectModel(id: 'geography', name: 'Geography', icon: '🌍', side: 'school', totalChapters: 10),
    SubjectModel(id: 'bengali', name: 'Bengali', icon: '📚', side: 'school', totalChapters: 8),
    SubjectModel(id: 'english', name: 'English', icon: '📗', side: 'school', totalChapters: 10),
  ];

  static List<SubjectModel> techSubjects = const [
    SubjectModel(id: 'python', name: 'Python', icon: '🐍', side: 'tech', totalChapters: 20),
    SubjectModel(id: 'cybersecurity', name: 'Cybersecurity', icon: '🔐', side: 'tech', totalChapters: 15),
  ];

  @override
  List<Object?> get props => [id, name, icon, side, totalChapters, progress];
}
