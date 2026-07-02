import 'package:flutter_bloc/flutter_bloc.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(const QuizState()) {
    on<QuizStarted>(_onQuizStarted);
    on<QuizAnswerSelected>(_onAnswerSelected);
    on<QuizSubmitted>(_onSubmitted);
    on<QuizNextQuestion>(_onNextQuestion);
    on<QuizPreviousQuestion>(_onPreviousQuestion);
    on<QuizReset>(_onReset);
  }

  void _onQuizStarted(QuizStarted event, Emitter<QuizState> emit) {
    emit(state.copyWith(
      questions: event.questions,
      totalMarks: event.totalMarks,
      currentQuestionIndex: 0,
      answers: {},
      isSubmitted: false,
      score: null,
    ));
  }

  void _onAnswerSelected(QuizAnswerSelected event, Emitter<QuizState> emit) {
    final updatedAnswers = Map<int, String>.from(state.answers);
    final updatedCorrectness = Map<int, bool>.from(state.correctness);
    updatedAnswers[event.questionIndex] = event.answer;
    updatedCorrectness[event.questionIndex] = event.isCorrect;
    emit(state.copyWith(
      answers: updatedAnswers,
      correctness: updatedCorrectness,
    ));
  }

  void _onSubmitted(QuizSubmitted event, Emitter<QuizState> emit) {
    int score = 0;
    for (var i = 0; i < state.questions.length; i++) {
      if (state.correctness[i] == true) {
        final marks = state.questions[i]['marks'] ?? 1;
        score += (marks is int ? marks : int.tryParse(marks.toString()) ?? 1);
      }
    }
    emit(state.copyWith(
      isSubmitted: true,
      score: score,
    ));
  }

  void _onNextQuestion(QuizNextQuestion event, Emitter<QuizState> emit) {
    if (!state.isLastQuestion) {
      emit(state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1));
    }
  }

  void _onPreviousQuestion(QuizPreviousQuestion event, Emitter<QuizState> emit) {
    if (!state.isFirstQuestion) {
      emit(state.copyWith(currentQuestionIndex: state.currentQuestionIndex - 1));
    }
  }

  void _onReset(QuizReset event, Emitter<QuizState> emit) {
    emit(const QuizState());
  }
}
