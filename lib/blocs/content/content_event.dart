import 'package:equatable/equatable.dart';

enum AppSide { school, tech }

abstract class ContentEvent extends Equatable {
  const ContentEvent();

  @override
  List<Object> get props => [];
}

class ContentSideChanged extends ContentEvent {
  final AppSide side;
  const ContentSideChanged(this.side);

  @override
  List<Object> get props => [side];
}

class ContentSubjectsLoaded extends ContentEvent {}

class ContentChaptersLoaded extends ContentEvent {
  final String subjectId;
  const ContentChaptersLoaded(this.subjectId);

  @override
  List<Object> get props => [subjectId];
}

class ContentTopicsLoaded extends ContentEvent {
  final String subjectId;
  final String chapterId;
  const ContentTopicsLoaded(this.subjectId, this.chapterId);

  @override
  List<Object> get props => [subjectId, chapterId];
}

class ContentTopicSelected extends ContentEvent {
  final String subjectId;
  final String chapterId;
  final String topicId;
  const ContentTopicSelected(this.subjectId, this.chapterId, this.topicId);

  @override
  List<Object> get props => [subjectId, chapterId, topicId];
}
