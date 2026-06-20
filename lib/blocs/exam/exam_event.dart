import 'package:equatable/equatable.dart';
import '../../../data/models/question_model.dart';
import '../../../data/models/exam_bank_model.dart';

abstract class ExamEvent extends Equatable {
  const ExamEvent();

  @override
  List<Object?> get props => [];
}

class ExamModeToggled extends ExamEvent {
  final bool isExamMode;
  const ExamModeToggled(this.isExamMode);

  @override
  List<Object> get props => [isExamMode];
}

class ExamDateSet extends ExamEvent {
  final DateTime examDate;
  const ExamDateSet(this.examDate);

  @override
  List<Object> get props => [examDate];
}

class ExamBankLoaded extends ExamEvent {
  final String userId;
  final String? subjectId;
  const ExamBankLoaded(this.userId, {this.subjectId});

  @override
  List<Object?> get props => [userId, subjectId];
}

class ExamBankItemSaved extends ExamEvent {
  final ExamBankModel item;
  const ExamBankItemSaved(this.item);

  @override
  List<Object> get props => [item];
}

class ExamBankItemRemoved extends ExamEvent {
  final String itemId;
  const ExamBankItemRemoved(this.itemId);

  @override
  List<Object> get props => [itemId];
}

class ExamQuizStarted extends ExamEvent {
  final String subjectId;
  final String? chapterId;
  final QuestionType? type;
  const ExamQuizStarted(this.subjectId, {this.chapterId, this.type});

  @override
  List<Object> get props => [subjectId];
}

class ExamQuizAnswered extends ExamEvent {
  final int questionIndex;
  final String answer;
  const ExamQuizAnswered(this.questionIndex, this.answer);

  @override
  List<Object> get props => [questionIndex, answer];
}

class ExamQuizSubmitted extends ExamEvent {}
