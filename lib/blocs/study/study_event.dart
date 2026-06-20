import 'package:equatable/equatable.dart';

enum StudyTab { understand, flashcards, quiz, qaBank, chat }

abstract class StudyEvent extends Equatable {
  const StudyEvent();

  @override
  List<Object> get props => [];
}

class StudyTabChanged extends StudyEvent {
  final StudyTab tab;
  const StudyTabChanged(this.tab);

  @override
  List<Object> get props => [tab];
}

class StudyContentLoaded extends StudyEvent {
  final String subjectId;
  final String chapterId;
  final String topicId;
  const StudyContentLoaded(this.subjectId, this.chapterId, this.topicId);

  @override
  List<Object> get props => [subjectId, chapterId, topicId];
}

class StudyAudioPlayed extends StudyEvent {}

class StudyAudioStopped extends StudyEvent {}

class StudyFlashcardFlipped extends StudyEvent {
  final int index;
  const StudyFlashcardFlipped(this.index);

  @override
  List<Object> get props => [index];
}

class StudyFlashcardMarked extends StudyEvent {
  final int index;
  final String mark;
  const StudyFlashcardMarked(this.index, this.mark);

  @override
  List<Object> get props => [index, mark];
}

class StudyChatMessageSent extends StudyEvent {
  final String message;
  const StudyChatMessageSent(this.message);

  @override
  List<Object> get props => [message];
}
