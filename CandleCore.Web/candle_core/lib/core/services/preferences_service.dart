import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _onboardingDoneKey = 'onboarding_done';

  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  bool get onboardingDone => _prefs.getBool(_onboardingDoneKey) ?? false;

  Future<void> setOnboardingDone() =>
      _prefs.setBool(_onboardingDoneKey, true);
}
