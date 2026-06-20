import 'package:equatable/equatable.dart';

enum QuestionType { mcq, short, medium, long }

class QuestionModel extends Equatable {
  final String id;
  final String topicId;
  final QuestionType type;
  final String question;
  final String? bengaliQuestion;
  final String answer;
  final String? bengaliAnswer;
  final List<String>? options;
  final String? explanation;
  final int marks;
  final bool isSaved;
  final bool isCorrect;
  final String? userAnswer;

  const QuestionModel({
    required this.id,
    required this.topicId,
    required this.type,
    required this.question,
    this.bengaliQuestion,
    required this.answer,
    this.bengaliAnswer,
    this.options,
    this.explanation,
    this.marks = 1,
    this.isSaved = false,
    this.isCorrect = false,
    this.userAnswer,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] ?? '',
      topicId: map['topicId'] ?? '',
      type: QuestionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => QuestionType.mcq,
      ),
      question: map['question'] ?? '',
      bengaliQuestion: map['bengaliQuestion'],
      answer: map['answer'] ?? '',
      bengaliAnswer: map['bengaliAnswer'],
      options: map['options'] != null ? List<String>.from(map['options']) : null,
      explanation: map['explanation'],
      marks: map['marks'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topicId': topicId,
      'type': type.name,
      'question': question,
      'bengaliQuestion': bengaliQuestion,
      'answer': answer,
      'bengaliAnswer': bengaliAnswer,
      'options': options,
      'explanation': explanation,
      'marks': marks,
    };
  }

  QuestionModel copyWith({
    bool? isSaved,
    bool? isCorrect,
    String? userAnswer,
  }) {
    return QuestionModel(
      id: id,
      topicId: topicId,
      type: type,
      question: question,
      bengaliQuestion: bengaliQuestion,
      answer: answer,
      bengaliAnswer: bengaliAnswer,
      options: options,
      explanation: explanation,
      marks: marks,
      isSaved: isSaved ?? this.isSaved,
      isCorrect: isCorrect ?? this.isCorrect,
      userAnswer: userAnswer ?? this.userAnswer,
    );
  }

  @override
  List<Object?> get props => [id, question, type, isSaved, isCorrect];
}
