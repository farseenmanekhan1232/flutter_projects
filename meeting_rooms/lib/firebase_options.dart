// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBnB_J-HEX7cr80n_OrIQ5jTMmapbTeNDg',
    appId: '1:896452279720:android:0b440dbc18ce7f5d2a719d',
    messagingSenderId: '896452279720',
    projectId: 'attendence-342dd',
    storageBucket: 'attendence-342dd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAyVrKthYfIdtk77szzRtVmZ4rPKlpnoPo',
    appId: '1:896452279720:ios:c2dedea6d55bb3d52a719d',
    messagingSenderId: '896452279720',
    projectId: 'attendence-342dd',
    storageBucket: 'attendence-342dd.appspot.com',
    androidClientId: '896452279720-b22m4nl2ietesifelekgic3tsrdtl073.apps.googleusercontent.com',
    iosClientId: '896452279720-d3kci6qb1ahfjb9cil539c6ru3uphpt0.apps.googleusercontent.com',
    iosBundleId: 'com.example.meetingRooms',
  );
}
