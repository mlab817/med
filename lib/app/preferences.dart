import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

const String prefsKeyOnboardingScreen = "PREFS_KEY_ONBOARDING_SCREEN";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  // record if user has already viewed onboarding screen locally
  Future<void> setOnBoardingScreenViewed() async {
    log("setting onboardingScreenViewed to true");
    _sharedPreferences.setBool(prefsKeyOnboardingScreen, true);
  }

  // get isOnBoardingScreenViewed
  Future<bool> isOnBoardingScreenViewed() async {
    log("retrieving onboardingScreenViewed to true");
    return _sharedPreferences.getBool(prefsKeyOnboardingScreen) ?? false;
  }
}
