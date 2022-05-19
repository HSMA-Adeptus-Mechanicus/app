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
    apiKey: 'AIzaSyBQRiNkIvxOE1oZmZ1Lpj8DH9xIGs9RGLI',
    appId: '1:860263269238:web:bb705cf8e6b1c69396f057',
    messagingSenderId: '860263269238',
    projectId: 'scrum-for-fun',
    authDomain: 'scrum-for-fun.firebaseapp.com',
    databaseURL: 'https://scrum-for-fun-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'scrum-for-fun.appspot.com',
    measurementId: 'G-5771ZDZQLR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVa7gVURMM7ZM1FubTKp1Rg4-ZR3xNNA8',
    appId: '1:860263269238:android:d212d16c2d36b4a896f057',
    messagingSenderId: '860263269238',
    projectId: 'scrum-for-fun',
    databaseURL: 'https://scrum-for-fun-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'scrum-for-fun.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDX2Et3GMo6aRImlUu1NGgGqySU_0yURYg',
    appId: '1:860263269238:ios:30e4f3be135e87c696f057',
    messagingSenderId: '860263269238',
    projectId: 'scrum-for-fun',
    databaseURL: 'https://scrum-for-fun-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'scrum-for-fun.appspot.com',
    iosClientId: '860263269238-0gc55neinglamuv4q053lp93ffva9tj8.apps.googleusercontent.com',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDX2Et3GMo6aRImlUu1NGgGqySU_0yURYg',
    appId: '1:860263269238:ios:30e4f3be135e87c696f057',
    messagingSenderId: '860263269238',
    projectId: 'scrum-for-fun',
    databaseURL: 'https://scrum-for-fun-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'scrum-for-fun.appspot.com',
    iosClientId: '860263269238-0gc55neinglamuv4q053lp93ffva9tj8.apps.googleusercontent.com',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBQRiNkIvxOE1oZmZ1Lpj8DH9xIGs9RGLI',
    appId: '1:860263269238:web:928fc5ff761e674196f057',
    messagingSenderId: '860263269238',
    projectId: 'scrum-for-fun',
    authDomain: 'scrum-for-fun.firebaseapp.com',
    databaseURL: 'https://scrum-for-fun-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'scrum-for-fun.appspot.com',
    measurementId: 'G-RFJ82QRDWN',
  );
}