import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyByTCrL2cfVnpQJdXcqEneqq2XtpzFls68',
    appId: '1:377307332673:web:3983794e66c1379470c6c0',
    messagingSenderId: '377307332673',
    projectId: 'appcittymagic',
    authDomain: 'appcittymagic.firebaseapp.com',
    storageBucket: 'appcittymagic.appspot.com',
    measurementId: 'G-JY5VGXCZML',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyATxPD91HLq8fcT5ZtBehHtZmsiDYQ4Zdw',
    appId: '1:377307332673:android:002cc0c92a9b49db70c6c0',
    messagingSenderId: '377307332673',
    projectId: 'appcittymagic',
    storageBucket: 'appcittymagic.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAVTtUUoFdbsxkuHZPFUZczpoWOLyB0slg',
    appId: '1:377307332673:ios:dcfb86db6a85c72f70c6c0',
    messagingSenderId: '377307332673',
    projectId: 'appcittymagic',
    storageBucket: 'appcittymagic.appspot.com',
    iosBundleId: 'com.example.cittyquibdo',
  );
}
