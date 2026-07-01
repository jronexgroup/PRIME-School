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
  List<String>? get simpleBreakdown => topicContent?['simple_breakdown'] != null
      ? List<String>.from(topicContent!['simple_breakdown'])
      : null;
  String? get realLifeExample => topicContent?['real_life_example'];
  List<Map<String, dynamic>>? get keyTerms => topicContent?['key_terms'] != null
      ? List<Map<String, dynamic>>.from(topicContent!['key_terms'])
      : null;
  List<Map<String, dynamic>>? get timeline => topicContent?['timeline'] != null
      ? List<Map<String, dynamic>>.from(topicContent!['timeline'])
      : null;
  List<Map<String, dynamic>>? get causeEffect => topicContent?['cause_effect'] != null
      ? List<Map<String, dynamic>>.from(topicContent!['cause_effect'])
      : null;
  List<Map<String, dynamic>>? get importantPersonalities =>
      topicContent?['important_personalities'] != null
          ? List<Map<String, dynamic>>.from(topicContent!['important_personalities'])
          : null;
  List<Map<String, dynamic>>? get importantPlaces => topicContent?['important_places'] != null
      ? List<Map<String, dynamic>>.from(topicContent!['important_places'])
      : null;
  String? get mapDescription => topicContent?['map_description'];
  String? get voiceScript => topicContent?['voice_script'];
  String? get sidebarContent => topicContent?['sidebar_content'];
  Map<String, dynamic>? get quiz => topicContent?['quiz'] != null
      ? Map<String, dynamic>.from(topicContent!['quiz'])
      : null;
  Map<String, dynamic>? get bookQuestions => topicContent?['book_questions'] != null
      ? Map<String, dynamic>.from(topicContent!['book_questions'])
      : null;
  Map<String, dynamic>? get examBank => topicContent?['exam_bank'] != null
      ? Map<String, dynamic>.from(topicContent!['exam_bank'])
      : null;
  List<dynamic>? get examTips => topicContent?['exam_tips'];
  String? get audioUrl => topicContent?['audioUrl'];
  Map<String, dynamic>? get importantHighlights => topicContent?['important_highlights'] != null
      ? Map<String, dynamic>.from(topicContent!['important_highlights'])
      : null;

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
