import 'package:shared_preferences/shared_preferences.dart';

const String prefsKeyOnboardingScreen = "PREFS_KEY_ONBOARDING_SCREEN";
const String notificationRequestPermissionGranted =
    "NOTIFICATION_REQUEST_PERMISSION_GRANTED";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  // record if user has already viewed onboarding screen locally
  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(prefsKeyOnboardingScreen, true);
  }

  // get isOnBoardingScreenViewed
  Future<bool> isOnBoardingScreenViewed() async {
    return _sharedPreferences.getBool(prefsKeyOnboardingScreen) ?? false;
  }

  Future<void> setNotificationRequestPermissionGranted() async {
    _sharedPreferences.setBool(notificationRequestPermissionGranted, true);
  }

  Future<bool> getNotificationRequestPermissionGranted() async {
    return _sharedPreferences.getBool(notificationRequestPermissionGranted) ??
        false;
  }
}
