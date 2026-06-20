import 'package:equatable/equatable.dart';

class TopicModel extends Equatable {
  final String id;
  final String chapterId;
  final String subjectId;
  final String name;
  final int order;
  final bool isCompleted;
  final bool isBookmarked;
  final DateTime? lastStudied;
  final double progress;

  const TopicModel({
    required this.id,
    required this.chapterId,
    required this.subjectId,
    required this.name,
    required this.order,
    this.isCompleted = false,
    this.isBookmarked = false,
    this.lastStudied,
    this.progress = 0.0,
  });

  factory TopicModel.fromMap(Map<String, dynamic> map) {
    return TopicModel(
      id: map['id'] ?? '',
      chapterId: map['chapterId'] ?? '',
      subjectId: map['subjectId'] ?? '',
      name: map['name'] ?? '',
      order: map['order'] ?? 0,
      isCompleted: map['isCompleted'] ?? false,
      isBookmarked: map['isBookmarked'] ?? false,
      lastStudied: map['lastStudied'] != null ? DateTime.parse(map['lastStudied']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chapterId': chapterId,
      'subjectId': subjectId,
      'name': name,
      'order': order,
      'isCompleted': isCompleted,
      'isBookmarked': isBookmarked,
      'lastStudied': lastStudied?.toIso8601String(),
    };
  }

  TopicModel copyWith({
    bool? isCompleted,
    bool? isBookmarked,
    DateTime? lastStudied,
    double? progress,
  }) {
    return TopicModel(
      id: id,
      chapterId: chapterId,
      subjectId: subjectId,
      name: name,
      order: order,
      isCompleted: isCompleted ?? this.isCompleted,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      lastStudied: lastStudied ?? this.lastStudied,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [id, name, order, isCompleted, isBookmarked];
}
