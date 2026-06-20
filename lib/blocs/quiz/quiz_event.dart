import 'package:equatable/equatable.dart';
import '../../../data/models/question_model.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object> get props => [];
}

class QuizStarted extends QuizEvent {
  final String topicId;
  final QuestionType type;
  const QuizStarted(this.topicId, this.type);

  @override
  List<Object> get props => [topicId, type];
}

class QuizAnswerSelected extends QuizEvent {
  final int questionIndex;
  final String answer;
  const QuizAnswerSelected(this.questionIndex, this.answer);

  @override
  List<Object> get props => [questionIndex, answer];
}

class QuizSubmitted extends QuizEvent {}

class QuizNextQuestion extends QuizEvent {}

class QuizPreviousQuestion extends QuizEvent {}
