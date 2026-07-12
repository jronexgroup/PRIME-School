import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/study_os/study_mode_service.dart';
import '../../core/services/study_os/study_schedule_service.dart';
import '../../core/services/study_os/pomodoro_service.dart';
import '../../core/services/study_os/reward_service.dart';
import '../../core/services/study_os/study_analytics_service.dart';
import '../../core/services/study_os/voice_tutor_service.dart';
import '../../core/services/study_os/focus_detector_service.dart';
import '../../core/services/study_os/smart_notes_service.dart';
import '../../core/models/study_session.dart';
import 'study_os_event.dart';
import 'study_os_state.dart';

class StudyOsBloc extends Bloc<StudyOsEvent, StudyOsState> {
  final StudyModeService studyModeService;
  final StudyScheduleService scheduleService;
  final PomodoroService pomodoroService;
  final RewardService rewardService;
  final StudyAnalyticsService analyticsService;
  final SmartNotesService smartNotesService;
  final VoiceTutorService? voiceTutorService;
  final FocusDetectorService? focusDetectorService;

  late final StreamSubscription<int> _elapsedSub;
  late final StreamSubscription<int> _distractionSub;
  late final StreamSubscription<int> _pomodoroTickSub;
  late final StreamSubscription<dynamic> _pomodoroPhaseSub;
  StreamSubscription<bool>? _faceDownSub;
  StreamSubscription<void>? _leaveAttemptSub;
  late final StreamSubscription<dynamic> _scheduleSub;

  StudySession? _currentSession;

  StudyOsBloc({
    required this.studyModeService,
    required this.scheduleService,
    required this.pomodoroService,
    required this.rewardService,
    required this.analyticsService,
    required this.smartNotesService,
    this.voiceTutorService,
    this.focusDetectorService,
  }) : super(const StudyOsState()) {
    on<StudyOsStarted>(_onStarted);
    on<StudyOsStartSession>(_onStartSession);
    on<StudyOsEndSession>(_onEndSession);
    on<StudyOsPauseSession>(_onPauseSession);
    on<StudyOsResumeSession>(_onResumeSession);
    on<StudyOsDistractionDetected>(_onDistractionDetected);
    on<StudyOsTimerTick>(_onTimerTick);
    on<StudyOsScheduleTriggered>(_onScheduleTriggered);
    on<StudyOsLoadSchedules>(_onLoadSchedules);
    on<StudyOsAddSchedule>(_onAddSchedule);
    on<StudyOsDeleteSchedule>(_onDeleteSchedule);
    on<StudyOsToggleSchedule>(_onToggleSchedule);
    on<StudyOsPomodoroTick>(_onPomodoroTick);
    on<StudyOsPomodoroPhaseChanged>(_onPomodoroPhaseChanged);

    _elapsedSub = studyModeService.elapsedStream.listen((seconds) {
      add(StudyOsTimerTick(seconds));
    });

    _distractionSub = studyModeService.distractionStream.listen((_) {
      add(StudyOsDistractionDetected());
    });

    _pomodoroTickSub = pomodoroService.tickStream.listen((seconds) {
      add(StudyOsPomodoroTick(seconds));
    });

    _pomodoroPhaseSub = pomodoroService.phaseStream.listen((phase) {
      add(StudyOsPomodoroPhaseChanged(phase.name));
    });

    _faceDownSub = focusDetectorService?.faceDownStream.listen((isDown) {
      studyModeService.setFaceDown(isDown);
    });

    _scheduleSub = scheduleService.onScheduleTrigger.listen((schedule) {
      add(StudyOsScheduleTriggered(schedule.id));
    });

    _leaveAttemptSub = studyModeService.leaveAttemptStream.listen((_) {
      studyModeService.recordDistraction();
      studyModeService.reengageLockTask();
    });
  }

  Future<void> _onStarted(StudyOsStarted event, Emitter<StudyOsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await scheduleService.initialize();
      await analyticsService.initialize();
      await rewardService.initialize();
      focusDetectorService?.startListening();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onStartSession(StudyOsStartSession event, Emitter<StudyOsState> emit) async {
    if (state.sessionState != StudyOsSessionState.idle) return;

    emit(state.copyWith(isLoading: true));
    try {
      await studyModeService.startStudyMode();
      voiceTutorService?.speakSessionStart();

      _currentSession = StudySession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        startedAt: DateTime.now(),
        plannedDurationMinutes: event.durationMinutes,
        subjectId: event.subjectId,
        scheduleId: event.scheduleId,
      );

      if (event.enablePomodoro) {
        pomodoroService.configure();
        pomodoroService.startFocus();
      }

      emit(state.copyWith(
        sessionState: StudyOsSessionState.active,
        elapsedSeconds: 0,
        distractionCount: 0,
        pomodoroSecondsRemaining: event.enablePomodoro
            ? pomodoroService.secondsRemaining
            : 0,
        pomodoroPhase: event.enablePomodoro ? 'focus' : 'idle',
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to start: $e'));
    }
  }

  Future<void> _onEndSession(StudyOsEndSession event, Emitter<StudyOsState> emit) async {
    if (state.sessionState == StudyOsSessionState.idle) return;

    try {
      await studyModeService.endStudyMode();
      pomodoroService.reset();
      voiceTutorService?.stop();

      if (_currentSession != null) {
        _currentSession!.endedAt = DateTime.now();
        _currentSession!.actualDurationSeconds = state.elapsedSeconds;
        _currentSession!.distractionCount = state.distractionCount;
        _currentSession!.completed = true;
        _currentSession!.pomodoroCycles = state.pomodoroCycles;
        _currentSession!.faceDownBonus = state.faceDown;

        await analyticsService.recordSession(_currentSession!);
        await rewardService.rewardSession(_currentSession!);
        voiceTutorService?.speakSessionEnd(state.elapsedSeconds ~/ 60);
      }

      _currentSession = null;

      emit(const StudyOsState());
    } catch (e) {
      emit(state.copyWith(sessionState: StudyOsSessionState.idle));
    }
  }

  Future<void> _onPauseSession(StudyOsPauseSession event, Emitter<StudyOsState> emit) async {
    await studyModeService.pauseStudyMode();
    pomodoroService.pause();
    emit(state.copyWith(sessionState: StudyOsSessionState.paused));
  }

  Future<void> _onResumeSession(StudyOsResumeSession event, Emitter<StudyOsState> emit) async {
    await studyModeService.resumeStudyMode();
    pomodoroService.resume();
    emit(state.copyWith(sessionState: StudyOsSessionState.active));
  }

  void _onDistractionDetected(StudyOsDistractionDetected event, Emitter<StudyOsState> emit) {
    studyModeService.recordDistraction();
    voiceTutorService?.speakDistractionWarning();
    emit(state.copyWith(distractionCount: state.distractionCount + 1));
  }

  void _onTimerTick(StudyOsTimerTick event, Emitter<StudyOsState> emit) {
    emit(state.copyWith(elapsedSeconds: event.elapsedSeconds));
  }

  Future<void> _onScheduleTriggered(StudyOsScheduleTriggered event, Emitter<StudyOsState> emit) async {
    final now = DateTime.now();
    final currentMinute = now.hour * 60 + now.minute;
    final schedule = scheduleService.getSchedule(event.scheduleId);
    if (schedule == null) return;

    final endMin = schedule.endHour * 60 + schedule.endMinute;

    if (currentMinute == endMin) {
      await _onEndSession(const StudyOsEndSession(), emit);
    }
  }

  void _onLoadSchedules(StudyOsLoadSchedules event, Emitter<StudyOsState> emit) {
    // Schedules are loaded on demand via the service
  }

  Future<void> _onAddSchedule(StudyOsAddSchedule event, Emitter<StudyOsState> emit) async {
    try {
      await scheduleService.createSchedule(
        name: event.scheduleData['name'] as String? ?? 'Study Session',
        startHour: event.scheduleData['startHour'] as int,
        startMinute: event.scheduleData['startMinute'] as int,
        endHour: event.scheduleData['endHour'] as int,
        endMinute: event.scheduleData['endMinute'] as int,
        daysOfWeek: List<int>.from(event.scheduleData['daysOfWeek'] ?? [1,2,3,4,5,6,7]),
        subjectId: event.scheduleData['subjectId'] as String?,
      );
    } catch (_) {}
  }

  Future<void> _onDeleteSchedule(StudyOsDeleteSchedule event, Emitter<StudyOsState> emit) async {
    await scheduleService.deleteSchedule(event.scheduleId);
  }

  Future<void> _onToggleSchedule(StudyOsToggleSchedule event, Emitter<StudyOsState> emit) async {
    await scheduleService.toggleSchedule(event.scheduleId);
  }

  void _onPomodoroTick(StudyOsPomodoroTick event, Emitter<StudyOsState> emit) {
    emit(state.copyWith(pomodoroSecondsRemaining: event.secondsRemaining));
  }

  void _onPomodoroPhaseChanged(StudyOsPomodoroPhaseChanged event, Emitter<StudyOsState> emit) {
    emit(state.copyWith(pomodoroPhase: event.phase));
    if (event.phase == 'break_') {
      voiceTutorService?.speakPomodoroBreak();
      emit(state.copyWith(pomodoroCycles: state.pomodoroCycles + 1));
    } else if (event.phase == 'focus') {
      voiceTutorService?.speakPomodoroFocus();
    }
  }

  @override
  Future<void> close() {
    _elapsedSub.cancel();
    _distractionSub.cancel();
    _pomodoroTickSub.cancel();
    _pomodoroPhaseSub.cancel();
    _faceDownSub?.cancel();
    _leaveAttemptSub?.cancel();
    _scheduleSub.cancel();
    studyModeService.dispose();
    scheduleService.dispose();
    pomodoroService.dispose();
    focusDetectorService?.dispose();
    return super.close();
  }
}
