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
    apiKey: 'AIzaSyDv9-5zLOTX_fq_rDODMDUqenHvtm3u6U4',
    appId: '1:361365232824:android:dc8b8b71dd2db9b4ffa84d',
    messagingSenderId: '361365232824',
    projectId: 'test-d1bdb',
    databaseURL: 'https://test-d1bdb.firebaseio.com',
    storageBucket: 'test-d1bdb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCKF0lF9pOD2dwvoXvqNgZXFk-KG9jjbSI',
    appId: '1:361365232824:ios:105c11c22b99e3a6ffa84d',
    messagingSenderId: '361365232824',
    projectId: 'test-d1bdb',
    databaseURL: 'https://test-d1bdb.firebaseio.com',
    storageBucket: 'test-d1bdb.appspot.com',
    iosClientId: '361365232824-8qphve1o1jq7dveu510vu1oubr6biisd.apps.googleusercontent.com',
    iosBundleId: 'com.example.newsApp',
  );
}
