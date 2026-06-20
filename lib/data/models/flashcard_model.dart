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

  const FlashcardModel({
    required this.id,
    required this.topicId,
    required this.front,
    required this.back,
    this.bengaliFront,
    this.bengaliBack,
    this.difficulty = 1,
    this.isKnown = false,
    this.isImportant = false,
    this.needsReview = false,
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
    );
  }

  @override
  List<Object?> get props => [id, front, back, isKnown, isImportant, needsReview];
}
