import 'dart:async';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:screen_brightness/screen_brightness.dart';

enum StudyModeState { idle, preparing, active, paused, exiting }

class StudyModeService {
  StudyModeState _state = StudyModeState.idle;
  StudyModeState get state => _state;

  final _stateController = StreamController<StudyModeState>.broadcast();
  Stream<StudyModeState> get stateStream => _stateController.stream;

  final _distractionController = StreamController<int>.broadcast();
  Stream<int> get distractionStream => _distractionController.stream;

  int _distractionCount = 0;
  int get distractionCount => _distractionCount;

  Timer? _sessionTimer;
  int _elapsedSeconds = 0;
  int get elapsedSeconds => _elapsedSeconds;

  final _elapsedController = StreamController<int>.broadcast();
  Stream<int> get elapsedStream => _elapsedController.stream;

  bool _faceDown = false;
  bool get isFaceDown => _faceDown;

  static const _channel = MethodChannel('com.jronex.prime_school/study_mode');

  Future<bool> startStudyMode() async {
    if (_state == StudyModeState.active) return true;
    _state = StudyModeState.preparing;
    _stateController.add(_state);

    try {
      // Try to enable screen pinning / lock task mode
      await _channel.invokeMethod('startLockTask');
    } catch (_) {}

    try {
      // Try to enable immersive mode
      await _channel.invokeMethod('setImmersiveMode', {'enabled': true});
    } catch (_) {}

    // Keep screen on
    await WakelockPlus.enable();

    // Dim screen slightly for reading
    try {
      await ScreenBrightness.instance.application
          .setApplicationScreenBrightness(0.8);
    } catch (_) {}

    _distractionCount = 0;
    _elapsedSeconds = 0;
    _state = StudyModeState.active;
    _stateController.add(_state);

    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;
      _elapsedController.add(_elapsedSeconds);
    });

    return true;
  }

  Future<void> pauseStudyMode() async {
    if (_state != StudyModeState.active) return;
    _state = StudyModeState.paused;
    _stateController.add(_state);
    _sessionTimer?.cancel();
  }

  Future<void> resumeStudyMode() async {
    if (_state != StudyModeState.paused) return;
    _state = StudyModeState.active;
    _stateController.add(_state);
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;
      _elapsedController.add(_elapsedSeconds);
    });
  }

  Future<void> endStudyMode() async {
    _state = StudyModeState.exiting;
    _stateController.add(_state);

    _sessionTimer?.cancel();
    _sessionTimer = null;
    await WakelockPlus.disable();

    try {
      await ScreenBrightness.instance.application
          .resetApplicationScreenBrightness();
    } catch (_) {}

    try {
      await _channel.invokeMethod('stopLockTask');
    } catch (_) {}

    try {
      await _channel.invokeMethod('setImmersiveMode', {'enabled': false});
    } catch (_) {}

    _state = StudyModeState.idle;
    _stateController.add(_state);
  }

  void recordDistraction() {
    _distractionCount++;
    _distractionController.add(_distractionCount);
  }

  void setFaceDown(bool value) {
    _faceDown = value;
  }

  int getElapsedSeconds() => _elapsedSeconds;

  Future<bool> isInLockTaskMode() async {
    try {
      return await _channel.invokeMethod('isInLockTaskMode') as bool? ?? false;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _sessionTimer?.cancel();
    _stateController.close();
    _distractionController.close();
    _elapsedController.close();
  }
}
