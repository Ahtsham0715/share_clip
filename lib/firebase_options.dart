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
    apiKey: 'AIzaSyBwRlhAw7lXzmbRg7tC7H9bSijwYskiMVQ',
    appId: '1:912626991406:web:c0b2439511b6ba3d7ebabf',
    messagingSenderId: '912626991406',
    projectId: 'shareclip-46cdd',
    authDomain: 'shareclip-46cdd.firebaseapp.com',
    storageBucket: 'shareclip-46cdd.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBE8m7J5T3eUARzLp1TvH6W28efX6mQuvg',
    appId: '1:912626991406:android:13e4fb7cdd00a9507ebabf',
    messagingSenderId: '912626991406',
    projectId: 'shareclip-46cdd',
    storageBucket: 'shareclip-46cdd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDJJnV1Wulz4ckn9Xbs1AgakzPa4o43Ig0',
    appId: '1:912626991406:ios:29ef26b0328b247d7ebabf',
    messagingSenderId: '912626991406',
    projectId: 'shareclip-46cdd',
    storageBucket: 'shareclip-46cdd.appspot.com',
    iosClientId: '912626991406-pmemefnknnbm22ifrfs398pesq3ft8gd.apps.googleusercontent.com',
    iosBundleId: 'com.example.shareClip',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDJJnV1Wulz4ckn9Xbs1AgakzPa4o43Ig0',
    appId: '1:912626991406:ios:29ef26b0328b247d7ebabf',
    messagingSenderId: '912626991406',
    projectId: 'shareclip-46cdd',
    storageBucket: 'shareclip-46cdd.appspot.com',
    iosClientId: '912626991406-pmemefnknnbm22ifrfs398pesq3ft8gd.apps.googleusercontent.com',
    iosBundleId: 'com.example.shareClip',
  );
}