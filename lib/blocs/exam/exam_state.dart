import 'package:equatable/equatable.dart';
import '../../../data/models/exam_bank_model.dart';
import '../../../data/models/question_model.dart';

class ExamState extends Equatable {
  final bool isExamMode;
  final DateTime? examDate;
  final List<ExamBankModel> examBank;
  final List<QuestionModel> examQuizQuestions;
  final int currentQuestionIndex;
  final Map<int, String> answers;
  final bool isQuizSubmitted;
  final int? quizScore;
  final int totalQuizMarks;
  final Map<String, int> weakAreas;
  final bool isLoading;
  final String? error;

  const ExamState({
    this.isExamMode = false,
    this.examDate,
    this.examBank = const [],
    this.examQuizQuestions = const [],
    this.currentQuestionIndex = 0,
    this.answers = const {},
    this.isQuizSubmitted = false,
    this.quizScore,
    this.totalQuizMarks = 0,
    this.weakAreas = const {},
    this.isLoading = false,
    this.error,
  });

  ExamState copyWith({
    bool? isExamMode,
    DateTime? examDate,
    List<ExamBankModel>? examBank,
    List<QuestionModel>? examQuizQuestions,
    int? currentQuestionIndex,
    Map<int, String>? answers,
    bool? isQuizSubmitted,
    int? quizScore,
    int? totalQuizMarks,
    Map<String, int>? weakAreas,
    bool? isLoading,
    String? error,
  }) {
    return ExamState(
      isExamMode: isExamMode ?? this.isExamMode,
      examDate: examDate ?? this.examDate,
      examBank: examBank ?? this.examBank,
      examQuizQuestions: examQuizQuestions ?? this.examQuizQuestions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? this.answers,
      isQuizSubmitted: isQuizSubmitted ?? this.isQuizSubmitted,
      quizScore: quizScore,
      totalQuizMarks: totalQuizMarks ?? this.totalQuizMarks,
      weakAreas: weakAreas ?? this.weakAreas,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  int? get daysUntilExam {
    if (examDate == null) return null;
    final diff = examDate!.difference(DateTime.now()).inDays;
    return diff >= 0 ? diff : null;
  }

  List<ExamBankModel> getFilteredExamBank({
    String? subjectId,
    String? chapterId,
    QuestionType? type,
  }) {
    return examBank.where((item) {
      if (subjectId != null && item.subjectId != subjectId) return false;
      if (chapterId != null && item.chapterId != chapterId) return false;
      if (type != null && item.question.type != type) return false;
      return true;
    }).toList();
  }

  @override
  List<Object?> get props => [
        isExamMode,
        examDate,
        examBank,
        examQuizQuestions,
        currentQuestionIndex,
        answers,
        isQuizSubmitted,
        quizScore,
        totalQuizMarks,
        weakAreas,
        isLoading,
        error,
      ];
}
