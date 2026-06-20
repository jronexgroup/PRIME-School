import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/ai_service.dart';
import '../../../data/models/question_model.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final AiService _aiService;

  QuizBloc({required AiService aiService})
      : _aiService = aiService,
        super(const QuizState()) {
    on<QuizStarted>(_onQuizStarted);
    on<QuizAnswerSelected>(_onAnswerSelected);
    on<QuizSubmitted>(_onSubmitted);
    on<QuizNextQuestion>(_onNextQuestion);
    on<QuizPreviousQuestion>(_onPreviousQuestion);
  }

  Future<void> _onQuizStarted(QuizStarted event, Emitter<QuizState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await _aiService.generateQuiz(
        event.topicId,
        event.type.name,
      );

      final questions = (response as List)
          .map((q) => QuestionModel.fromMap(q))
          .toList();

      int totalMarks = 0;
      for (final q in questions) {
        totalMarks += q.marks;
      }

      emit(state.copyWith(
        questions: questions,
        totalMarks: totalMarks,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void _onAnswerSelected(QuizAnswerSelected event, Emitter<QuizState> emit) {
    final updatedAnswers = Map<int, String>.from(state.answers);
    updatedAnswers[event.questionIndex] = event.answer;
    emit(state.copyWith(answers: updatedAnswers));
  }

  Future<void> _onSubmitted(QuizSubmitted event, Emitter<QuizState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      int score = 0;
      final updatedQuestions = List<QuestionModel>.from(state.questions);

      for (var i = 0; i < updatedQuestions.length; i++) {
        final userAnswer = state.answers[i];
        if (userAnswer != null) {
          final isCorrect = userAnswer.toLowerCase().trim() ==
              updatedQuestions[i].answer.toLowerCase().trim();
          if (isCorrect) {
            score += updatedQuestions[i].marks;
          }
          updatedQuestions[i] = updatedQuestions[i].copyWith(
            isCorrect: isCorrect,
            userAnswer: userAnswer,
          );
        }
      }

      emit(state.copyWith(
        questions: updatedQuestions,
        isSubmitted: true,
        score: score,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void _onNextQuestion(QuizNextQuestion event, Emitter<QuizState> emit) {
    if (!state.isLastQuestion) {
      emit(state.copyWith(
          currentQuestionIndex: state.currentQuestionIndex + 1));
    }
  }

  void _onPreviousQuestion(QuizPreviousQuestion event, Emitter<QuizState> emit) {
    if (!state.isFirstQuestion) {
      emit(state.copyWith(
          currentQuestionIndex: state.currentQuestionIndex - 1));
    }
  }
}
