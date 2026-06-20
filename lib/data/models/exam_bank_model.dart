import 'package:equatable/equatable.dart';
import 'question_model.dart';

class ExamBankModel extends Equatable {
  final String id;
  final String subjectId;
  final String chapterId;
  final String? topicId;
  final QuestionModel question;
  final DateTime savedAt;
  final bool isReviewed;

  const ExamBankModel({
    required this.id,
    required this.subjectId,
    required this.chapterId,
    this.topicId,
    required this.question,
    required this.savedAt,
    this.isReviewed = false,
  });

  factory ExamBankModel.fromMap(Map<String, dynamic> map) {
    return ExamBankModel(
      id: map['id'] ?? '',
      subjectId: map['subjectId'] ?? '',
      chapterId: map['chapterId'] ?? '',
      topicId: map['topicId'],
      question: QuestionModel.fromMap(map['question']),
      savedAt: DateTime.parse(map['savedAt']),
      isReviewed: map['isReviewed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subjectId': subjectId,
      'chapterId': chapterId,
      'topicId': topicId,
      'question': question.toMap(),
      'savedAt': savedAt.toIso8601String(),
      'isReviewed': isReviewed,
    };
  }

  ExamBankModel copyWith({bool? isReviewed}) {
    return ExamBankModel(
      id: id,
      subjectId: subjectId,
      chapterId: chapterId,
      topicId: topicId,
      question: question,
      savedAt: savedAt,
      isReviewed: isReviewed ?? this.isReviewed,
    );
  }

  @override
  List<Object?> get props => [id, subjectId, question, savedAt];
}
