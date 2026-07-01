import 'package:equatable/equatable.dart';

class FlashcardModel extends Equatable {
  final String id;
  final String topicId;
  final String front;
  final String back;
  final String? bengaliFront;
  final String? bengaliBack;
  final int difficulty;
  final bool isKnown;
  final bool isImportant;
  final bool needsReview;
  final String type;
  final String importance;

  const FlashcardModel({
    this.id = '',
    this.topicId = '',
    required this.front,
    required this.back,
    this.bengaliFront,
    this.bengaliBack,
    this.difficulty = 1,
    this.isKnown = false,
    this.isImportant = false,
    this.needsReview = false,
    this.type = 'concept',
    this.importance = 'medium',
  });

  factory FlashcardModel.fromMap(Map<String, dynamic> map) {
    return FlashcardModel(
      id: map['id'] ?? '',
      topicId: map['topicId'] ?? '',
      front: map['front'] ?? '',
      back: map['back'] ?? '',
      bengaliFront: map['bengaliFront'],
      bengaliBack: map['bengaliBack'],
      difficulty: map['difficulty'] ?? 1,
      isKnown: map['isKnown'] ?? false,
      isImportant: map['isImportant'] ?? false,
      needsReview: map['needsReview'] ?? false,
      type: map['type'] ?? 'concept',
      importance: map['importance'] ?? 'medium',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topicId': topicId,
      'front': front,
      'back': back,
      'bengaliFront': bengaliFront,
      'bengaliBack': bengaliBack,
      'difficulty': difficulty,
      'isKnown': isKnown,
      'isImportant': isImportant,
      'needsReview': needsReview,
      'type': type,
      'importance': importance,
    };
  }

  FlashcardModel copyWith({
    bool? isKnown,
    bool? isImportant,
    bool? needsReview,
  }) {
    return FlashcardModel(
      id: id,
      topicId: topicId,
      front: front,
      back: back,
      bengaliFront: bengaliFront,
      bengaliBack: bengaliBack,
      difficulty: difficulty,
      isKnown: isKnown ?? this.isKnown,
      isImportant: isImportant ?? this.isImportant,
      needsReview: needsReview ?? this.needsReview,
      type: type,
      importance: importance,
    );
  }

  @override
  List<Object?> get props => [id, front, back, isKnown, isImportant, needsReview];
}
