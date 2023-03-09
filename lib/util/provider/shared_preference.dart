import 'package:flutter/material.dart';
import 'package:info_med/l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

// settings for darkTheme
final darkTheme = ThemeData(
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  dividerColor: Colors.white,
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple)
      .copyWith(background: const Color(0xFF202020)),
);
// settings for lightTheme
final lightTheme = ThemeData(
  primaryColor: Colors.white,
  brightness: Brightness.light,
  dividerColor: Colors.black,
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
      .copyWith(secondary: Colors.black)
      .copyWith(background: const Color.fromARGB(255, 255, 255, 255)),
);

class SharedPreference with ChangeNotifier {
  // shared preference instance
  SharedPreferences? _prefs;
  // theme
  bool _darkTheme = false;
  // language
  Locale _language = L10n.all[2];
  bool get darkTheme => _darkTheme;
  Locale get language => _language;

  SharedPreference() {
    _getTheme();
    _getLanguage();
  }

  // change the theme
  Future setTheme() async {
    await _initialize();
    final SharedPreferences themePrefs = _prefs!;
    themePrefs.setBool('isDark', _darkTheme);
  }

  // get the theme
  _getTheme() async {
    await _initialize();
    final SharedPreferences themePrefs = _prefs!;
    _darkTheme = themePrefs.getBool('isDark') ?? false;
    notifyListeners();
  }

  // change the language
  Future setLanguage(String x) async {
    await _initialize();
    final SharedPreferences laguagePrefs = _prefs!;
    laguagePrefs.setString('lan', x);
    switch (x) {
      case 'کوردی':
        _language = L10n.all[2];
        break;
      case 'English':
        _language = L10n.all[0];
        break;
      default:
        _language = L10n.all[1];
    }
    notifyListeners();
  }

  // get the language
  _getLanguage() async {
    await _initialize();
    final SharedPreferences laguagePrefs = _prefs!;
    String x = laguagePrefs.getString('lan') ?? 'English';
    switch (x) {
      case 'کوردی':
        _language = L10n.all[2];
        break;
      case 'English':
        _language = L10n.all[0];
        break;
      default:
        _language = L10n.all[1];
    }
    notifyListeners();
  }

  // change the theme
  void toggleTheme() {
    _darkTheme = !_darkTheme;
    setTheme();
    notifyListeners();
  }

  // initialize shared preference
  _initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
}
