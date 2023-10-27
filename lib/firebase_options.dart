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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBcaYzVqfJhAFds12aBNHbWTGRccamrRpw',
    appId: '1:994270000473:web:afe99cc48fe4f179660848',
    messagingSenderId: '994270000473',
    projectId: 'graduation-project-d17b0',
    authDomain: 'graduation-project-d17b0.firebaseapp.com',
    storageBucket: 'graduation-project-d17b0.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCDjEigda9NOeyygR13zkp6WcHYHW8pi_E',
    appId: '1:994270000473:android:83cce380b12fbdd9660848',
    messagingSenderId: '994270000473',
    projectId: 'graduation-project-d17b0',
    storageBucket: 'graduation-project-d17b0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDvPq8cJWpKUfmLVR39rRdhkgcToG0Ffr4',
    appId: '1:994270000473:ios:7b4775d7dea0bc3f660848',
    messagingSenderId: '994270000473',
    projectId: 'graduation-project-d17b0',
    storageBucket: 'graduation-project-d17b0.appspot.com',
    iosBundleId: 'com.example.graduationProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDvPq8cJWpKUfmLVR39rRdhkgcToG0Ffr4',
    appId: '1:994270000473:ios:2c15fbd7be1d2809660848',
    messagingSenderId: '994270000473',
    projectId: 'graduation-project-d17b0',
    storageBucket: 'graduation-project-d17b0.appspot.com',
    iosBundleId: 'com.example.graduationProject.RunnerTests',
  );
}
