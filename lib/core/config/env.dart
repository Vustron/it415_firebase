import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'secret.env')
abstract class Env {
  @EnviedField(varName: 'WEB_API_KEY', obfuscate: true)
  static String webApiKey = _Env.webApiKey;

  @EnviedField(varName: 'WEB_APP_ID', obfuscate: true)
  static String webAppId = _Env.webAppId;

  @EnviedField(varName: 'WEB_MESSAGINGSENDER_ID', obfuscate: true)
  static String webMessagingSenderId = _Env.webMessagingSenderId;

  @EnviedField(varName: 'WEB_PROJECT_ID', obfuscate: true)
  static String webProjectId = _Env.webProjectId;

  @EnviedField(varName: 'WEB_AUTH_DOMAIN', obfuscate: true)
  static String webAuthDomain = _Env.webAuthDomain;

  @EnviedField(varName: 'WEB_STORAGEBUCKET', obfuscate: true)
  static String webStorageBucket = _Env.webStorageBucket;

  @EnviedField(varName: 'ANDROID_API_KEY', obfuscate: true)
  static String androidApiKey = _Env.androidApiKey;

  @EnviedField(varName: 'ANDROID_APP_ID', obfuscate: true)
  static String androidAppId = _Env.androidAppId;

  @EnviedField(varName: 'ANDROID_MESSAGINGSENDER_ID', obfuscate: true)
  static String androidMessagingSenderId = _Env.androidMessagingSenderId;

  @EnviedField(varName: 'ANDROID_PROJECT_ID', obfuscate: true)
  static String androidProjectId = _Env.androidProjectId;

  @EnviedField(varName: 'ANDROID_STORAGEBUCKET', obfuscate: true)
  static String androidStorageBucket = _Env.androidStorageBucket;

  @EnviedField(varName: 'IOS_API_KEY', obfuscate: true)
  static String iosApiKey = _Env.iosApiKey;

  @EnviedField(varName: 'IOS_APP_ID', obfuscate: true)
  static String iosAppId = _Env.iosAppId;

  @EnviedField(varName: 'IOS_MESSAGINGSENDER_ID', obfuscate: true)
  static String iosMessagingSenderId = _Env.iosMessagingSenderId;

  @EnviedField(varName: 'IOS_PROJECT_ID', obfuscate: true)
  static String iosProjectId = _Env.iosProjectId;

  @EnviedField(varName: 'IOS_STORAGEBUCKET', obfuscate: true)
  static String iosStorageBucket = _Env.iosStorageBucket;

  @EnviedField(varName: 'IOS_BUNDLE_ID', obfuscate: true)
  static String iosBundleId = _Env.iosBundleId;

  @EnviedField(varName: 'MACOS_API_KEY', obfuscate: true)
  static String macosApiKey = _Env.macosApiKey;

  @EnviedField(varName: 'MACOS_APP_ID', obfuscate: true)
  static String macosAppId = _Env.macosAppId;

  @EnviedField(varName: 'MACOS_MESSAGINGSENDER_ID', obfuscate: true)
  static String macosMessagingSenderId = _Env.macosMessagingSenderId;

  @EnviedField(varName: 'MACOS_PROJECT_ID', obfuscate: true)
  static String macosProjectId = _Env.macosProjectId;

  @EnviedField(varName: 'MACOS_STORAGEBUCKET', obfuscate: true)
  static String macosStorageBucket = _Env.macosStorageBucket;

  @EnviedField(varName: 'MACOS_BUNDLE_ID', obfuscate: true)
  static String macosBundleId = _Env.macosBundleId;

  @EnviedField(varName: 'WINDOWS_API_KEY', obfuscate: true)
  static String windowsApiKey = _Env.windowsApiKey;

  @EnviedField(varName: 'WINDOWS_APP_ID', obfuscate: true)
  static String windowsAppId = _Env.windowsAppId;

  @EnviedField(varName: 'WINDOWS_MESSAGINGSENDER_ID', obfuscate: true)
  static String windowsMessagingSenderId = _Env.windowsMessagingSenderId;

  @EnviedField(varName: 'WINDOWS_PROJECT_ID', obfuscate: true)
  static String windowsProjectId = _Env.windowsProjectId;

  @EnviedField(varName: 'WINDOWS_AUTH_DOMAIN', obfuscate: true)
  static String windowsAuthDomain = _Env.windowsAuthDomain;

  @EnviedField(varName: 'WINDOWS_STORAGEBUCKET', obfuscate: true)
  static String windowsStorageBucket = _Env.windowsStorageBucket;
}
