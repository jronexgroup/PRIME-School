import 'package:equatable/equatable.dart';
import '../../../data/models/question_model.dart';

class QuizState extends Equatable {
  final List<QuestionModel> questions;
  final int currentQuestionIndex;
  final Map<int, String> answers;
  final bool isSubmitted;
  final int? score;
  final int totalMarks;
  final bool isLoading;
  final String? error;

  const QuizState({
    this.questions = const [],
    this.currentQuestionIndex = 0,
    this.answers = const {},
    this.isSubmitted = false,
    this.score,
    this.totalMarks = 0,
    this.isLoading = false,
    this.error,
  });

  QuizState copyWith({
    List<QuestionModel>? questions,
    int? currentQuestionIndex,
    Map<int, String>? answers,
    bool? isSubmitted,
    int? score,
    int? totalMarks,
    bool? isLoading,
    String? error,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? this.answers,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      score: score,
      totalMarks: totalMarks ?? this.totalMarks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  QuestionModel? get currentQuestion =>
      currentQuestionIndex < questions.length
          ? questions[currentQuestionIndex]
          : null;

  bool get isLastQuestion => currentQuestionIndex == questions.length - 1;
  bool get isFirstQuestion => currentQuestionIndex == 0;

  double get percentage =>
      totalMarks > 0 ? (score ?? 0) / totalMarks * 100 : 0;

  @override
  List<Object?> get props => [
        questions,
        currentQuestionIndex,
        answers,
        isSubmitted,
        score,
        totalMarks,
        isLoading,
        error,
      ];
}
