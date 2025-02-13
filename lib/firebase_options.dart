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
    apiKey: 'AIzaSyCkOokwxo6a9G92Bt3kL1uQo_aGBNp3cdk',
    appId: '1:922105823219:web:d56f110e38ad4c2c839c86',
    messagingSenderId: '922105823219',
    projectId: 'mobileapp-ee7ee',
    authDomain: 'mobileapp-ee7ee.firebaseapp.com',
    storageBucket: 'mobileapp-ee7ee.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAymXz_XMAQt46-xz_Uvz8Ds3EXGyza7jc',
    appId: '1:922105823219:android:4ad03caf651ce0d4839c86',
    messagingSenderId: '922105823219',
    projectId: 'mobileapp-ee7ee',
    storageBucket: 'mobileapp-ee7ee.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD3H7V8hVSISMp_7smMfjCJv_7fx3zXm54',
    appId: '1:922105823219:ios:49a15337569560a6839c86',
    messagingSenderId: '922105823219',
    projectId: 'mobileapp-ee7ee',
    storageBucket: 'mobileapp-ee7ee.appspot.com',
    iosBundleId: 'com.example.mobileApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD3H7V8hVSISMp_7smMfjCJv_7fx3zXm54',
    appId: '1:922105823219:ios:49a15337569560a6839c86',
    messagingSenderId: '922105823219',
    projectId: 'mobileapp-ee7ee',
    storageBucket: 'mobileapp-ee7ee.appspot.com',
    iosBundleId: 'com.example.mobileApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCkOokwxo6a9G92Bt3kL1uQo_aGBNp3cdk',
    appId: '1:922105823219:web:96f92c1e92d0cd9e839c86',
    messagingSenderId: '922105823219',
    projectId: 'mobileapp-ee7ee',
    authDomain: 'mobileapp-ee7ee.firebaseapp.com',
    storageBucket: 'mobileapp-ee7ee.appspot.com',
  );
}
