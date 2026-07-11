import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class FocusDetectorService {
  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  bool _isFaceDown = false;
  bool get isFaceDown => _isFaceDown;

  final _faceDownController = StreamController<bool>.broadcast();
  Stream<bool> get faceDownStream => _faceDownController.stream;

  bool _isListening = false;

  Future<void> startListening() async {
    if (_isListening) return;
    _isListening = true;

    try {
      _accelSubscription = accelerometerEventStream().listen(
        (AccelerometerEvent event) {
          // Phone is face-down when Z is near -9.8 (gravity pointing down)
          // and X/Y are relatively small
          final isDown = event.z < -8.0 && event.x.abs() < 3.0 && event.y.abs() < 3.0;
          if (isDown != _isFaceDown) {
            _isFaceDown = isDown;
            _faceDownController.add(isDown);
          }
        },
        onError: (error) {
          // Sensors not available
          _isFaceDown = false;
        },
      );
    } catch (e) {
      _isFaceDown = false;
    }
  }

  void stopListening() {
    _isListening = false;
    _accelSubscription?.cancel();
    _accelSubscription = null;
  }

  void dispose() {
    stopListening();
    _faceDownController.close();
  }
}
