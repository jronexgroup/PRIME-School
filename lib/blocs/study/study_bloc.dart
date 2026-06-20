import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/services/tts_service.dart';
import '../../../data/models/flashcard_model.dart';
import 'study_event.dart';
import 'study_state.dart';

class StudyBloc extends Bloc<StudyEvent, StudyState> {
  final FirestoreService _firestoreService;
  final AiService _aiService;
  final TtsService _ttsService;

  StudyBloc({
    required FirestoreService firestoreService,
    required AiService aiService,
    required TtsService ttsService,
  })  : _firestoreService = firestoreService,
        _aiService = aiService,
        _ttsService = ttsService,
        super(const StudyState()) {
    on<StudyTabChanged>(_onTabChanged);
    on<StudyContentLoaded>(_onContentLoaded);
    on<StudyAudioPlayed>(_onAudioPlayed);
    on<StudyAudioStopped>(_onAudioStopped);
    on<StudyFlashcardFlipped>(_onFlashcardFlipped);
    on<StudyFlashcardMarked>(_onFlashcardMarked);
    on<StudyChatMessageSent>(_onChatMessageSent);
  }

  void _onTabChanged(StudyTabChanged event, Emitter<StudyState> emit) {
    emit(state.copyWith(currentTab: event.tab));
  }

  Future<void> _onContentLoaded(
      StudyContentLoaded event, Emitter<StudyState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final content = await _firestoreService.getTopicContent(
          event.subjectId, event.chapterId, event.topicId);

      List<FlashcardModel> flashcards = [];
      if (content['flashcards'] != null) {
        flashcards = (content['flashcards'] as List)
            .map((fc) => FlashcardModel.fromMap(fc))
            .toList();
      }

      emit(state.copyWith(
        topicContent: content,
        flashcards: flashcards,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onAudioPlayed(
      StudyAudioPlayed event, Emitter<StudyState> emit) async {
    emit(state.copyWith(isAudioPlaying: true));
    if (state.audioUrl != null) {
      await _ttsService.speak(state.summary ?? '');
    }
  }

  Future<void> _onAudioStopped(
      StudyAudioStopped event, Emitter<StudyState> emit) async {
    await _ttsService.stop();
    emit(state.copyWith(isAudioPlaying: false));
  }

  void _onFlashcardFlipped(
      StudyFlashcardFlipped event, Emitter<StudyState> emit) {
    emit(state.copyWith(currentFlashcardIndex: event.index));
  }

  void _onFlashcardMarked(
      StudyFlashcardMarked event, Emitter<StudyState> emit) {
    final updatedFlashcards = List<FlashcardModel>.from(state.flashcards);
    if (event.index < updatedFlashcards.length) {
      updatedFlashcards[event.index] = updatedFlashcards[event.index].copyWith(
        isKnown: event.mark == 'known',
        isImportant: event.mark == 'important',
        needsReview: event.mark == 'review',
      );
      emit(state.copyWith(flashcards: updatedFlashcards));
    }
  }

  Future<void> _onChatMessageSent(
      StudyChatMessageSent event, Emitter<StudyState> emit) async {
    final userMessage = {'role': 'user', 'content': event.message};
    final updatedMessages = [...state.chatMessages, userMessage];
    emit(state.copyWith(chatMessages: updatedMessages, isLoading: true));

    try {
      final topicContentStr = state.topicContent.toString();
      final response = await _aiService.chatWithTopic(event.message, topicContentStr);
      final aiMessage = {'role': 'assistant', 'content': response};
      emit(state.copyWith(
        chatMessages: [...updatedMessages, aiMessage],
        isLoading: false,
      ));
    } catch (e) {
      final errorMessage = {'role': 'assistant', 'content': 'Error: $e'};
      emit(state.copyWith(
        chatMessages: [...updatedMessages, errorMessage],
        isLoading: false,
      ));
    }
  }
}
