import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppFirebaseOptions {
  static FirebaseOptions getForCurrentPlatform() {
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

  static final FirebaseOptions web = FirebaseOptions(
    apiKey: dotenv.get("API_KEY"),
    appId: dotenv.get("APP_ID"),
    messagingSenderId: dotenv.get("MESSAGING_SENDER_ID"),
    projectId: dotenv.get("PROJECT_ID"),
    storageBucket: dotenv.get("STORAGE_BUCKET"),
    authDomain: dotenv.get("AUTH_DOMAIN"),
  );

  static final FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.get("API_KEY"),
    appId: dotenv.get("APP_ID"),
    messagingSenderId: dotenv.get("MESSAGING_SENDER_ID"),
    projectId: dotenv.get("PROJECT_ID"),
    storageBucket: dotenv.get("STORAGE_BUCKET"),
  );

  static final FirebaseOptions ios = FirebaseOptions(
    apiKey: dotenv.get("API_KEY"),
    appId: dotenv.get("APP_ID"),
    messagingSenderId: dotenv.get("MESSAGING_SENDER_ID"),
    projectId: dotenv.get("PROJECT_ID"),
    storageBucket: dotenv.get("STORAGE_BUCKET"),
    iosClientId: dotenv.get("IOS_CLIENT_ID"),
    iosBundleId: dotenv.get("IOS_BUNDLE_ID"),
  );
}
