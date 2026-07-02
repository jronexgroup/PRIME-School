import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object> get props => [];
}

class QuizStarted extends QuizEvent {
  final List<Map<String, dynamic>> questions;
  final int totalMarks;
  const QuizStarted(this.questions, this.totalMarks);

  @override
  List<Object> get props => [questions, totalMarks];
}

class QuizAnswerSelected extends QuizEvent {
  final int questionIndex;
  final String answer;
  final bool isCorrect;
  const QuizAnswerSelected(this.questionIndex, this.answer, this.isCorrect);

  @override
  List<Object> get props => [questionIndex, answer, isCorrect];
}

class QuizSubmitted extends QuizEvent {}

class QuizNextQuestion extends QuizEvent {}

class QuizPreviousQuestion extends QuizEvent {}

class QuizReset extends QuizEvent {}
