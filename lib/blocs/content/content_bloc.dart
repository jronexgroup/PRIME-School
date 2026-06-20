import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/firestore_service.dart';
import '../../../data/models/subject_model.dart';
import '../../../data/models/chapter_model.dart';
import '../../../data/models/topic_model.dart';
import 'content_event.dart';
import 'content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final FirestoreService _firestoreService;

  ContentBloc({required FirestoreService firestoreService})
      : _firestoreService = firestoreService,
        super(const ContentState()) {
    on<ContentSideChanged>(_onSideChanged);
    on<ContentSubjectsLoaded>(_onSubjectsLoaded);
    on<ContentChaptersLoaded>(_onChaptersLoaded);
    on<ContentTopicsLoaded>(_onTopicsLoaded);
    on<ContentTopicSelected>(_onTopicSelected);
  }

  void _onSideChanged(ContentSideChanged event, Emitter<ContentState> emit) {
    emit(state.copyWith(
      currentSide: event.side,
      chapters: [],
      topics: [],
      selectedSubjectId: null,
      selectedChapterId: null,
      selectedTopicId: null,
    ));
  }

  Future<void> _onSubjectsLoaded(
      ContentSubjectsLoaded event, Emitter<ContentState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final subjects = [
        ...SubjectModel.schoolSubjects,
        ...SubjectModel.techSubjects,
      ];
      emit(state.copyWith(subjects: subjects, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onChaptersLoaded(
      ContentChaptersLoaded event, Emitter<ContentState> emit) async {
    emit(state.copyWith(isLoading: true, selectedSubjectId: event.subjectId));
    try {
      final chapters = await _firestoreService.getChapters(event.subjectId);
      emit(state.copyWith(chapters: chapters, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onTopicsLoaded(
      ContentTopicsLoaded event, Emitter<ContentState> emit) async {
    emit(state.copyWith(
      isLoading: true,
      selectedSubjectId: event.subjectId,
      selectedChapterId: event.chapterId,
    ));
    try {
      final topics = await _firestoreService.getTopics(
          event.subjectId, event.chapterId);
      emit(state.copyWith(topics: topics, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onTopicSelected(
      ContentTopicSelected event, Emitter<ContentState> emit) async {
    emit(state.copyWith(
      isLoading: true,
      selectedSubjectId: event.subjectId,
      selectedChapterId: event.chapterId,
      selectedTopicId: event.topicId,
    ));
    try {
      final content = await _firestoreService.getTopicContent(
          event.subjectId, event.chapterId, event.topicId);
      emit(state.copyWith(topicContent: content, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
