import 'package:equatable/equatable.dart';

abstract class StudyOsEvent extends Equatable {
  const StudyOsEvent();

  @override
  List<Object?> get props => [];
}

class StudyOsStarted extends StudyOsEvent {}

class StudyOsStartSession extends StudyOsEvent {
  final String? scheduleId;
  final String? subjectId;
  final int durationMinutes;
  final bool enablePomodoro;

  const StudyOsStartSession({
    this.scheduleId,
    this.subjectId,
    this.durationMinutes = 60,
    this.enablePomodoro = false,
  });

  @override
  List<Object?> get props => [scheduleId, subjectId, durationMinutes, enablePomodoro];
}

class StudyOsEndSession extends StudyOsEvent {}

class StudyOsPauseSession extends StudyOsEvent {}

class StudyOsResumeSession extends StudyOsEvent {}

class StudyOsDistractionDetected extends StudyOsEvent {}

class StudyOsTimerTick extends StudyOsEvent {
  final int elapsedSeconds;

  const StudyOsTimerTick(this.elapsedSeconds);

  @override
  List<Object?> get props => [elapsedSeconds];
}

class StudyOsScheduleTriggered extends StudyOsEvent {
  final String scheduleId;

  const StudyOsScheduleTriggered(this.scheduleId);

  @override
  List<Object?> get props => [scheduleId];
}

class StudyOsLoadSchedules extends StudyOsEvent {}

class StudyOsAddSchedule extends StudyOsEvent {
  final Map<String, dynamic> scheduleData;

  const StudyOsAddSchedule(this.scheduleData);

  @override
  List<Object?> get props => [scheduleData];
}

class StudyOsDeleteSchedule extends StudyOsEvent {
  final String scheduleId;

  const StudyOsDeleteSchedule(this.scheduleId);

  @override
  List<Object?> get props => [scheduleId];
}

class StudyOsToggleSchedule extends StudyOsEvent {
  final String scheduleId;

  const StudyOsToggleSchedule(this.scheduleId);

  @override
  List<Object?> get props => [scheduleId];
}

class StudyOsPomodoroTick extends StudyOsEvent {
  final int secondsRemaining;

  const StudyOsPomodoroTick(this.secondsRemaining);

  @override
  List<Object?> get props => [secondsRemaining];
}

class StudyOsPomodoroPhaseChanged extends StudyOsEvent {
  final String phase;

  const StudyOsPomodoroPhaseChanged(this.phase);

  @override
  List<Object?> get props => [phase];
}
