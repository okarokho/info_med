import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final darkTheme = ThemeData(
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF202020),
  dividerColor: Colors.white,
    primarySwatch: Colors.deepPurple,

  // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
  //     .copyWith(secondary: Colors.white),
);

final lightTheme = ThemeData(
  primaryColor: Colors.white,
  primarySwatch: Colors.deepPurple,
  brightness: Brightness.light,
  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
  dividerColor: Colors.black,
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
      .copyWith(secondary: Colors.black),
);

class SharedPreference with ChangeNotifier {
  SharedPreferences? _prefs;
  bool _darkTheme = false;
  String _language='Kurdish';
  bool get darkTheme => _darkTheme;
  String get language => _language;

  SharedPreference() {
    
    _getTheme();
    _getLanguage();
  }



  Future setTheme() async {
    await _initialize();
    final SharedPreferences themePrefs = _prefs!;
    themePrefs.setBool('isDark', _darkTheme);
  }

  _getTheme() async {
    await _initialize();
    final SharedPreferences themePrefs = _prefs!;
    _darkTheme = themePrefs.getBool('isDark') ?? false;
    notifyListeners();
  }

  Future setLanguage(String x) async {
    await _initialize();
    final SharedPreferences laguagePrefs = _prefs!;
    laguagePrefs.setString('lan', x);
    _language = x;
  }

 
  _getLanguage() async {
    await _initialize();
    final SharedPreferences laguagePrefs = _prefs!;
    _language = laguagePrefs.getString('lan') ?? 'Kurdish';
    notifyListeners();
  }

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    setTheme();
    notifyListeners();
  }

  _initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
}
