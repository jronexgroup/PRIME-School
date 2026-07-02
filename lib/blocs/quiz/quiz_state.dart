import 'package:equatable/equatable.dart';

class QuizState extends Equatable {
  final List<Map<String, dynamic>> questions;
  final int currentQuestionIndex;
  final Map<int, String> answers;
  final Map<int, bool> correctness;
  final bool isSubmitted;
  final int? score;
  final int totalMarks;
  final bool isLoading;

  const QuizState({
    this.questions = const [],
    this.currentQuestionIndex = 0,
    this.answers = const {},
    this.correctness = const {},
    this.isSubmitted = false,
    this.score,
    this.totalMarks = 0,
    this.isLoading = false,
  });

  QuizState copyWith({
    List<Map<String, dynamic>>? questions,
    int? currentQuestionIndex,
    Map<int, String>? answers,
    Map<int, bool>? correctness,
    bool? isSubmitted,
    int? score,
    int? totalMarks,
    bool? isLoading,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? this.answers,
      correctness: correctness ?? this.correctness,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      score: score,
      totalMarks: totalMarks ?? this.totalMarks,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Map<String, dynamic>? get currentQuestion =>
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
        correctness,
        isSubmitted,
        score,
        totalMarks,
        isLoading,
      ];
}
