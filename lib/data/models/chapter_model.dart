import 'package:equatable/equatable.dart';
import 'topic_model.dart';

class ChapterModel extends Equatable {
  final String id;
  final String subjectId;
  final String name;
  final int order;
  final int totalTopics;
  final List<TopicModel> topics;
  final double progress;

  const ChapterModel({
    required this.id,
    required this.subjectId,
    required this.name,
    required this.order,
    this.totalTopics = 0,
    this.topics = const [],
    this.progress = 0.0,
  });

  factory ChapterModel.fromMap(Map<String, dynamic> map) {
    return ChapterModel(
      id: map['id'] ?? '',
      subjectId: map['subjectId'] ?? '',
      name: map['name'] ?? '',
      order: map['order'] ?? 0,
      totalTopics: map['totalTopics'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subjectId': subjectId,
      'name': name,
      'order': order,
      'totalTopics': totalTopics,
    };
  }

  ChapterModel copyWith({
    List<TopicModel>? topics,
    double? progress,
  }) {
    return ChapterModel(
      id: id,
      subjectId: subjectId,
      name: name,
      order: order,
      totalTopics: totalTopics,
      topics: topics ?? this.topics,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [id, subjectId, name, order, totalTopics, progress];
}
