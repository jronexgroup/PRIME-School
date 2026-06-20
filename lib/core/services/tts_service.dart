import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    await _tts.setLanguage('bn-IN');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    await initialize();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  Future<void> pause() async {
    await _tts.pause();
  }

  Future<bool> get isPlaying async {
    return await _tts.awaitSpeakCompletion(true);
  }

  void setLanguage(String language) {
    _tts.setLanguage(language);
  }

  void setSpeechRate(double rate) {
    _tts.setSpeechRate(rate);
  }

  void setPitch(double pitch) {
    _tts.setPitch(pitch);
  }
}
