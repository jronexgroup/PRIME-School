import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/firestore_service.dart';
import '../../../data/models/exam_bank_model.dart';
import '../../../data/models/question_model.dart';
import 'exam_event.dart';
import 'exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final FirestoreService _firestoreService;

  ExamBloc({required FirestoreService firestoreService})
      : _firestoreService = firestoreService,
        super(const ExamState()) {
    on<ExamModeToggled>(_onModeToggled);
    on<ExamDateSet>(_onDateSet);
    on<ExamBankLoaded>(_onBankLoaded);
    on<ExamBankItemSaved>(_onItemSaved);
    on<ExamBankItemRemoved>(_onItemRemoved);
    on<ExamQuizStarted>(_onQuizStarted);
    on<ExamQuizAnswered>(_onQuizAnswered);
    on<ExamQuizSubmitted>(_onQuizSubmitted);
  }

  void _onModeToggled(ExamModeToggled event, Emitter<ExamState> emit) {
    emit(state.copyWith(isExamMode: event.isExamMode));
  }

  void _onDateSet(ExamDateSet event, Emitter<ExamState> emit) {
    emit(state.copyWith(examDate: event.examDate));
  }

  Future<void> _onBankLoaded(
      ExamBankLoaded event, Emitter<ExamState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final items = await _firestoreService.getExamBank(
        event.userId,
        subjectId: event.subjectId,
      );
      emit(state.copyWith(examBank: items, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onItemSaved(
      ExamBankItemSaved event, Emitter<ExamState> emit) async {
    try {
      await _firestoreService.saveToExamBank(event.item);
      emit(state.copyWith(
        examBank: [...state.examBank, event.item],
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onItemRemoved(
      ExamBankItemRemoved event, Emitter<ExamState> emit) async {
    try {
      await _firestoreService.removeFromExamBank(
        event.itemId.split('_').first,
        event.itemId,
      );
      emit(state.copyWith(
        examBank: state.examBank
            .where((item) => item.id != event.itemId)
            .toList(),
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onQuizStarted(ExamQuizStarted event, Emitter<ExamState> emit) {
    final filtered = state.getFilteredExamBank(
      subjectId: event.subjectId,
      chapterId: event.chapterId,
      type: event.type,
    );

    final questions = filtered.map((item) => item.question).toList();
    questions.shuffle();

    int totalMarks = 0;
    for (final q in questions) {
      totalMarks += q.marks;
    }

    emit(state.copyWith(
      examQuizQuestions: questions.take(20).toList(),
      totalQuizMarks: totalMarks,
      currentQuestionIndex: 0,
      answers: {},
      isQuizSubmitted: false,
      quizScore: null,
    ));
  }

  void _onQuizAnswered(ExamQuizAnswered event, Emitter<ExamState> emit) {
    final updatedAnswers = Map<int, String>.from(state.answers);
    updatedAnswers[event.questionIndex] = event.answer;
    emit(state.copyWith(answers: updatedAnswers));
  }

  void _onQuizSubmitted(ExamQuizSubmitted event, Emitter<ExamState> emit) {
    int score = 0;
    final updatedQuestions = List<QuestionModel>.from(state.examQuizQuestions);

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
      examQuizQuestions: updatedQuestions,
      isQuizSubmitted: true,
      quizScore: score,
    ));
  }
}
