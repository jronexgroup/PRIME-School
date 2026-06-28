import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE',
    appId: '1:231477345112:android:6ac5c671747b742899432d',
    messagingSenderId: '231477345112',
    projectId: 'prime-school-de654',
    storageBucket: 'prime-school-de654.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE',
    appId: '1:231477345112:android:6ac5c671747b742899432d',
    messagingSenderId: '231477345112',
    projectId: 'prime-school-de654',
    storageBucket: 'prime-school-de654.firebasestorage.app',
    iosBundleId: 'com.jronex.primeSchool',
  );
}
