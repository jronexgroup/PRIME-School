import '../tts_service.dart';

class VoiceTutorService {
  final TtsService _ttsService;
  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;
  double _speed = 0.8;
  double get speed => _speed;

  static const List<String> studyTips = [
    'Take deep breaths. Stay focused on your goals.',
    'Remember: consistency is more important than intensity.',
    'The best time to start was yesterday. The next best time is now.',
    'Break your study into small, manageable chunks.',
    'Every minute of focused study brings you closer to your goals.',
    'Your brain learns best in short, focused sessions with breaks in between.',
    'Stay curious. Ask questions. Learning is a superpower.',
    'You are building a habit. One session at a time.',
    'Distractions are temporary. Knowledge is permanent.',
    'Take a 5-minute break. Stand up. Stretch. Hydrate.',
  ];

  VoiceTutorService(this._ttsService);

  Future<void> speak(String text) async {
    _isSpeaking = true;
    try {
      _ttsService.setLanguage('en-US');
      await _ttsService.speak(text);
    } catch (_) {}
    _isSpeaking = false;
  }

  Future<void> speakMotivationalTip() async {
    final tip = studyTips[DateTime.now().millisecondsSinceEpoch % studyTips.length];
    await speak(tip);
  }

  Future<void> speakSessionStart() async {
    await speak('Focus session started. Let us make the most of this time.');
  }

  Future<void> speakSessionEnd(int durationMinutes) async {
    await speak('Great work! You studied for $durationMinutes minutes. Keep it up!');
  }

  Future<void> speakDistractionWarning() async {
    await speak('It is study time. Please stay focused and avoid distractions.');
  }

  Future<void> speakPomodoroBreak() async {
    await speak('Focus session complete. Take a short break to recharge.');
  }

  Future<void> speakPomodoroFocus() async {
    await speak('Break is over. Time to focus again.');
  }

  void setSpeed(double speed) {
    _speed = speed.clamp(0.5, 1.5);
  }

  Future<void> stop() async {
    _isSpeaking = false;
    try {
      await _ttsService.stop();
    } catch (_) {}
  }
}
