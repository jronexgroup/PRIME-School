import 'package:equatable/equatable.dart';
import '../../../data/models/flashcard_model.dart';
import 'study_event.dart';

class StudyState extends Equatable {
  final StudyTab currentTab;
  final Map<String, dynamic>? topicContent;
  final List<FlashcardModel> flashcards;
  final int currentFlashcardIndex;
  final bool isAudioPlaying;
  final List<Map<String, dynamic>> chatMessages;
  final bool isLoading;
  final String? error;

  const StudyState({
    this.currentTab = StudyTab.understand,
    this.topicContent,
    this.flashcards = const [],
    this.currentFlashcardIndex = 0,
    this.isAudioPlaying = false,
    this.chatMessages = const [],
    this.isLoading = false,
    this.error,
  });

  StudyState copyWith({
    StudyTab? currentTab,
    Map<String, dynamic>? topicContent,
    List<FlashcardModel>? flashcards,
    int? currentFlashcardIndex,
    bool? isAudioPlaying,
    List<Map<String, dynamic>>? chatMessages,
    bool? isLoading,
    String? error,
  }) {
    return StudyState(
      currentTab: currentTab ?? this.currentTab,
      topicContent: topicContent ?? this.topicContent,
      flashcards: flashcards ?? this.flashcards,
      currentFlashcardIndex: currentFlashcardIndex ?? this.currentFlashcardIndex,
      isAudioPlaying: isAudioPlaying ?? this.isAudioPlaying,
      chatMessages: chatMessages ?? this.chatMessages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  String? get summary => topicContent?['summary'];
  List<String>? get breakdown => topicContent?['breakdown'] != null
      ? List<String>.from(topicContent!['breakdown'])
      : null;
  String? get example => topicContent?['example'];
  Map<String, String>? get keyTerms => topicContent?['keyTerms'] != null
      ? Map<String, String>.from(topicContent!['keyTerms'])
      : null;
  String? get audioUrl => topicContent?['audioUrl'];

  @override
  List<Object?> get props => [
        currentTab,
        topicContent,
        flashcards,
        currentFlashcardIndex,
        isAudioPlaying,
        chatMessages,
        isLoading,
        error,
      ];
}
