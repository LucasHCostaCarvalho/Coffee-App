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
    apiKey: 'AIzaSyAEZ9OdlGtblQb9rvzDOxlS-BL4bw4qnf4',
    appId: '1:834838472772:web:a69886acc7e809da1bf411',
    messagingSenderId: '834838472772',
    projectId: 'pavic-7e28d',
    authDomain: 'pavic-7e28d.firebaseapp.com',
    storageBucket: 'pavic-7e28d.firebasestorage.app',
    measurementId: 'G-8Q9EJ9726L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDiwW_UBMrvYTYJjJExiJc7tY7pFuSn0lI',
    appId: '1:834838472772:android:41c445b1239eae971bf411',
    messagingSenderId: '834838472772',
    projectId: 'pavic-7e28d',
    storageBucket: 'pavic-7e28d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDiButjyIR6wcFoZyEXAC-uN3vqDTaQ4CQ',
    appId: '1:834838472772:ios:a80c2d2c8dca00161bf411',
    messagingSenderId: '834838472772',
    projectId: 'pavic-7e28d',
    storageBucket: 'pavic-7e28d.firebasestorage.app',
    androidClientId: '834838472772-rnlncuhv20appg2dtaeju83geqf8upjf.apps.googleusercontent.com',
    iosClientId: '834838472772-vrogo82l42n41vpukarfppq7ouih8mcv.apps.googleusercontent.com',
    iosBundleId: 'com.example.coffeeapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDiButjyIR6wcFoZyEXAC-uN3vqDTaQ4CQ',
    appId: '1:834838472772:ios:a80c2d2c8dca00161bf411',
    messagingSenderId: '834838472772',
    projectId: 'pavic-7e28d',
    storageBucket: 'pavic-7e28d.firebasestorage.app',
    androidClientId: '834838472772-rnlncuhv20appg2dtaeju83geqf8upjf.apps.googleusercontent.com',
    iosClientId: '834838472772-vrogo82l42n41vpukarfppq7ouih8mcv.apps.googleusercontent.com',
    iosBundleId: 'com.example.coffeeapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAEZ9OdlGtblQb9rvzDOxlS-BL4bw4qnf4',
    appId: '1:834838472772:web:91ae7e8cd1ee5c551bf411',
    messagingSenderId: '834838472772',
    projectId: 'pavic-7e28d',
    authDomain: 'pavic-7e28d.firebaseapp.com',
    storageBucket: 'pavic-7e28d.firebasestorage.app',
    measurementId: 'G-B9LGVQ90HB',
  );

}