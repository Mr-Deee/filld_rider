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
    apiKey: 'AIzaSyCapCYvAfS6bWtsUFA1FMsYO_YfsvAAGWg',
    appId: '1:538330805104:web:9f1a019d9f4ef3bee2d5b5',
    messagingSenderId: '538330805104',
    projectId: 'fill-d-db8f7',
    authDomain: 'fill-d-db8f7.firebaseapp.com',
    databaseURL: 'https://fill-d-db8f7-default-rtdb.firebaseio.com',
    storageBucket: 'fill-d-db8f7.appspot.com',
    measurementId: 'G-Y5VHYLJ37L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB5cFO7zVS8Vx4xxpMZg7YlZ0vzh5uawcE',
    appId: '1:538330805104:android:e365409acfcb4a3de2d5b5',
    messagingSenderId: '538330805104',
    projectId: 'fill-d-db8f7',
    databaseURL: 'https://fill-d-db8f7-default-rtdb.firebaseio.com',
    storageBucket: 'fill-d-db8f7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDeMKtQ8nlMnouNCvAt6JfHHGSC7bvRjKg',
    appId: '1:538330805104:ios:d250570a7b90054fe2d5b5',
    messagingSenderId: '538330805104',
    projectId: 'fill-d-db8f7',
    databaseURL: 'https://fill-d-db8f7-default-rtdb.firebaseio.com',
    storageBucket: 'fill-d-db8f7.appspot.com',
    androidClientId: '538330805104-1sq6iqj5dgfg90cca0dhqt3bmdr4cs8v.apps.googleusercontent.com',
    iosClientId: '538330805104-7hnu7dcag64ikh3lvj5ekcdehiihiaq1.apps.googleusercontent.com',
    iosBundleId: 'com.example.filldRider',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDeMKtQ8nlMnouNCvAt6JfHHGSC7bvRjKg',
    appId: '1:538330805104:ios:d250570a7b90054fe2d5b5',
    messagingSenderId: '538330805104',
    projectId: 'fill-d-db8f7',
    databaseURL: 'https://fill-d-db8f7-default-rtdb.firebaseio.com',
    storageBucket: 'fill-d-db8f7.appspot.com',
    androidClientId: '538330805104-1sq6iqj5dgfg90cca0dhqt3bmdr4cs8v.apps.googleusercontent.com',
    iosClientId: '538330805104-7hnu7dcag64ikh3lvj5ekcdehiihiaq1.apps.googleusercontent.com',
    iosBundleId: 'com.example.filldRider',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCapCYvAfS6bWtsUFA1FMsYO_YfsvAAGWg',
    appId: '1:538330805104:web:a12b32730a8a4887e2d5b5',
    messagingSenderId: '538330805104',
    projectId: 'fill-d-db8f7',
    authDomain: 'fill-d-db8f7.firebaseapp.com',
    databaseURL: 'https://fill-d-db8f7-default-rtdb.firebaseio.com',
    storageBucket: 'fill-d-db8f7.appspot.com',
    measurementId: 'G-S9P7MY4KB0',
  );

}