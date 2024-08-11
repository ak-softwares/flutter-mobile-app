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
    apiKey: 'AIzaSyDaEvrQZdlv80sOqs4ETsHbzrw1Rws2te4',
    appId: '1:387716439678:web:b237fec047f98abefa822f',
    messagingSenderId: '387716439678',
    projectId: 'aramarket-in-2772c',
    authDomain: 'aramarket-in-2772c.firebaseapp.com',
    storageBucket: 'aramarket-in-2772c.appspot.com',
    measurementId: 'G-9PKDPWPLQS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDlK7RhMhPNbBuPSrFuPEAJtyKozqzgifs',
    appId: '1:387716439678:android:38ffaecb06e4f00cfa822f',
    messagingSenderId: '387716439678',
    projectId: 'aramarket-in-2772c',
    storageBucket: 'aramarket-in-2772c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB2etUmA72KBHTqQJsJGScG3gbNDHzm0a8',
    appId: '1:387716439678:ios:aef3969b4a0e289ffa822f',
    messagingSenderId: '387716439678',
    projectId: 'aramarket-in-2772c',
    storageBucket: 'aramarket-in-2772c.appspot.com',
    androidClientId: '387716439678-q0fe8vuotaun287n07t79fbn1n0m8r0s.apps.googleusercontent.com',
    iosClientId: '387716439678-9c6cm4s6gvlsao358vfek7ld8h270199.apps.googleusercontent.com',
    iosBundleId: 'com.example.aramarketNew',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB2etUmA72KBHTqQJsJGScG3gbNDHzm0a8',
    appId: '1:387716439678:ios:af251201f0a23624fa822f',
    messagingSenderId: '387716439678',
    projectId: 'aramarket-in-2772c',
    storageBucket: 'aramarket-in-2772c.appspot.com',
    androidClientId: '387716439678-q0fe8vuotaun287n07t79fbn1n0m8r0s.apps.googleusercontent.com',
    iosClientId: '387716439678-rcgc2kqp46d3b0opp3dbkpnl05io0b56.apps.googleusercontent.com',
    iosBundleId: 'com.example.aramarketNew.RunnerTests',
  );
}