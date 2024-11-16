import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

import 'env.dart';

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: Env.webApiKey,
        appId: Env.webAppId,
        messagingSenderId: Env.webMessagingSenderId,
        projectId: Env.webProjectId,
        authDomain: Env.webAuthDomain,
        storageBucket: Env.webStorageBucket,
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return FirebaseOptions(
          apiKey: Env.androidApiKey,
          appId: Env.androidAppId,
          messagingSenderId: Env.androidMessagingSenderId,
          projectId: Env.androidProjectId,
          storageBucket: Env.androidStorageBucket,
        );
      case TargetPlatform.iOS:
        return FirebaseOptions(
          apiKey: Env.iosApiKey,
          appId: Env.iosAppId,
          messagingSenderId: Env.iosMessagingSenderId,
          projectId: Env.iosProjectId,
          storageBucket: Env.iosStorageBucket,
          iosBundleId: Env.iosBundleId,
        );
      case TargetPlatform.macOS:
        return FirebaseOptions(
          apiKey: Env.macosApiKey,
          appId: Env.macosAppId,
          messagingSenderId: Env.macosMessagingSenderId,
          projectId: Env.macosProjectId,
          storageBucket: Env.macosStorageBucket,
          iosBundleId: Env.macosBundleId,
        );
      case TargetPlatform.windows:
        return FirebaseOptions(
          apiKey: Env.windowsApiKey,
          appId: Env.windowsAppId,
          messagingSenderId: Env.windowsMessagingSenderId,
          projectId: Env.windowsProjectId,
          authDomain: Env.windowsAuthDomain,
          storageBucket: Env.windowsStorageBucket,
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
