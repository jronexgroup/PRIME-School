import 'package:equatable/equatable.dart';

enum StudyOsSessionState { idle, active, paused }

class StudyOsState extends Equatable {
  final StudyOsSessionState sessionState;
  final int elapsedSeconds;
  final int distractionCount;
  final int currentScheduleIndex;
  final int pomodoroSecondsRemaining;
  final String pomodoroPhase;
  final int pomodoroCycles;
  final bool faceDown;
  final bool isLoading;
  final String? error;

  const StudyOsState({
    this.sessionState = StudyOsSessionState.idle,
    this.elapsedSeconds = 0,
    this.distractionCount = 0,
    this.currentScheduleIndex = -1,
    this.pomodoroSecondsRemaining = 0,
    this.pomodoroPhase = 'idle',
    this.pomodoroCycles = 0,
    this.faceDown = false,
    this.isLoading = false,
    this.error,
  });

  String get elapsedFormatted {
    final h = elapsedSeconds ~/ 3600;
    final m = (elapsedSeconds % 3600) ~/ 60;
    final s = elapsedSeconds % 60;
    if (h > 0) return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String get pomodoroFormatted {
    final m = pomodoroSecondsRemaining ~/ 60;
    final s = pomodoroSecondsRemaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  StudyOsState copyWith({
    StudyOsSessionState? sessionState,
    int? elapsedSeconds,
    int? distractionCount,
    int? currentScheduleIndex,
    int? pomodoroSecondsRemaining,
    String? pomodoroPhase,
    int? pomodoroCycles,
    bool? faceDown,
    bool? isLoading,
    String? error,
  }) {
    return StudyOsState(
      sessionState: sessionState ?? this.sessionState,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      distractionCount: distractionCount ?? this.distractionCount,
      currentScheduleIndex: currentScheduleIndex ?? this.currentScheduleIndex,
      pomodoroSecondsRemaining: pomodoroSecondsRemaining ?? this.pomodoroSecondsRemaining,
      pomodoroPhase: pomodoroPhase ?? this.pomodoroPhase,
      pomodoroCycles: pomodoroCycles ?? this.pomodoroCycles,
      faceDown: faceDown ?? this.faceDown,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    sessionState,
    elapsedSeconds,
    distractionCount,
    currentScheduleIndex,
    pomodoroSecondsRemaining,
    pomodoroPhase,
    pomodoroCycles,
    faceDown,
    isLoading,
    error,
  ];
}
