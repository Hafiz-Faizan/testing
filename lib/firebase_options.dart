// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB_KaRzIHLyCZ-QBKkkMUTyBt721ACWUDg',
    appId: '1:528304362991:web:3c7f5fb498a96d0cb8d21a',
    messagingSenderId: '528304362991',
    projectId: 'emerge-be2bc',
    authDomain: 'emerge-be2bc.firebaseapp.com',
    storageBucket: 'emerge-be2bc.appspot.com',
    measurementId: 'G-8TDP98RP33',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyByeABcuQnp2C5EdeM18Z_lL4Si9ViwMdc',
    appId: '1:528304362991:android:08e0605cc6c090d8b8d21a',
    messagingSenderId: '528304362991',
    projectId: 'emerge-be2bc',
    storageBucket: 'emerge-be2bc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAtDCNLcEo7RGf3n9DlQBWyxvlTShyHmIM',
    appId: '1:528304362991:ios:4f8630a4ec81ec86b8d21a',
    messagingSenderId: '528304362991',
    projectId: 'emerge-be2bc',
    storageBucket: 'emerge-be2bc.appspot.com',
    iosBundleId: 'com.example.emerge',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAtDCNLcEo7RGf3n9DlQBWyxvlTShyHmIM',
    appId: '1:528304362991:ios:4f8630a4ec81ec86b8d21a',
    messagingSenderId: '528304362991',
    projectId: 'emerge-be2bc',
    storageBucket: 'emerge-be2bc.appspot.com',
    iosBundleId: 'com.example.emerge',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB_KaRzIHLyCZ-QBKkkMUTyBt721ACWUDg',
    appId: '1:528304362991:web:dae2d31d13819934b8d21a',
    messagingSenderId: '528304362991',
    projectId: 'emerge-be2bc',
    authDomain: 'emerge-be2bc.firebaseapp.com',
    storageBucket: 'emerge-be2bc.appspot.com',
    measurementId: 'G-M3DZKEPDL1',
  );
}
