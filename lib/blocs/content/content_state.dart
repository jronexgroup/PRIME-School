import 'package:equatable/equatable.dart';
import '../../../data/models/subject_model.dart';
import '../../../data/models/chapter_model.dart';
import '../../../data/models/topic_model.dart';
import 'content_event.dart';

class ContentState extends Equatable {
  final AppSide currentSide;
  final List<SubjectModel> subjects;
  final List<ChapterModel> chapters;
  final List<TopicModel> topics;
  final String? selectedSubjectId;
  final String? selectedChapterId;
  final String? selectedTopicId;
  final Map<String, dynamic>? topicContent;
  final bool isLoading;
  final String? error;

  const ContentState({
    this.currentSide = AppSide.school,
    this.subjects = const [],
    this.chapters = const [],
    this.topics = const [],
    this.selectedSubjectId,
    this.selectedChapterId,
    this.selectedTopicId,
    this.topicContent,
    this.isLoading = false,
    this.error,
  });

  ContentState copyWith({
    AppSide? currentSide,
    List<SubjectModel>? subjects,
    List<ChapterModel>? chapters,
    List<TopicModel>? topics,
    String? selectedSubjectId,
    String? selectedChapterId,
    String? selectedTopicId,
    Map<String, dynamic>? topicContent,
    bool? isLoading,
    String? error,
  }) {
    return ContentState(
      currentSide: currentSide ?? this.currentSide,
      subjects: subjects ?? this.subjects,
      chapters: chapters ?? this.chapters,
      topics: topics ?? this.topics,
      selectedSubjectId: selectedSubjectId ?? this.selectedSubjectId,
      selectedChapterId: selectedChapterId ?? this.selectedChapterId,
      selectedTopicId: selectedTopicId ?? this.selectedTopicId,
      topicContent: topicContent ?? this.topicContent,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  List<SubjectModel> get currentSubjects =>
      subjects.where((s) => s.side == currentSide.name).toList();

  @override
  List<Object?> get props => [
        currentSide,
        subjects,
        chapters,
        topics,
        selectedSubjectId,
        selectedChapterId,
        selectedTopicId,
        topicContent,
        isLoading,
        error,
      ];
}
