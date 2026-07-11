import 'dart:async';

enum PomodoroPhase { focus, break_, idle }

class PomodoroService {
  PomodoroPhase _phase = PomodoroPhase.idle;
  PomodoroPhase get phase => _phase;

  int _focusMinutes = 25;
  int _breakMinutes = 5;
  int _secondsRemaining = 0;
  int get secondsRemaining => _secondsRemaining;
  int get minutesRemaining => _secondsRemaining ~/ 60;
  int get secondsPart => _secondsRemaining % 60;

  int _cyclesCompleted = 0;
  int get cyclesCompleted => _cyclesCompleted;

  Timer? _timer;

  final _phaseController = StreamController<PomodoroPhase>.broadcast();
  Stream<PomodoroPhase> get phaseStream => _phaseController.stream;

  final _tickController = StreamController<int>.broadcast();
  Stream<int> get tickStream => _tickController.stream;

  bool get isRunning => _timer != null && _timer!.isActive;
  bool get isFocus => _phase == PomodoroPhase.focus;
  bool get isBreak => _phase == PomodoroPhase.break_;

  void configure({int focusMinutes = 25, int breakMinutes = 5}) {
    _focusMinutes = focusMinutes;
    _breakMinutes = breakMinutes;
  }

  void startFocus() {
    _phase = PomodoroPhase.focus;
    _secondsRemaining = _focusMinutes * 60;
    _phaseController.add(_phase);
    _tickController.add(_secondsRemaining);
    _startTimer();
  }

  void startBreak() {
    _phase = PomodoroPhase.break_;
    _secondsRemaining = _breakMinutes * 60;
    _phaseController.add(_phase);
    _tickController.add(_secondsRemaining);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        _tickController.add(_secondsRemaining);
      } else {
        _timer?.cancel();
        if (_phase == PomodoroPhase.focus) {
          _cyclesCompleted++;
          startBreak();
        } else {
          _phase = PomodoroPhase.idle;
          _phaseController.add(_phase);
        }
      }
    });
  }

  void pause() {
    _timer?.cancel();
  }

  void resume() {
    if (_phase != PomodoroPhase.idle) {
      _startTimer();
    }
  }

  void reset() {
    _timer?.cancel();
    _phase = PomodoroPhase.idle;
    _secondsRemaining = 0;
    _phaseController.add(_phase);
    _tickController.add(0);
  }

  void skipBreak() {
    if (_phase == PomodoroPhase.break_) {
      _timer?.cancel();
      _phase = PomodoroPhase.idle;
      _phaseController.add(_phase);
      _cyclesCompleted++;
      startFocus();
    }
  }

  void dispose() {
    _timer?.cancel();
    _phaseController.close();
    _tickController.close();
  }
}
