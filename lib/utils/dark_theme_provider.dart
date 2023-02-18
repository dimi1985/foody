import 'package:flutter/material.dart';
import 'package:foody/utils/shared_preference.dart';

class DarkThemeProvider with ChangeNotifier {
  GlobalSharedPreference darkThemePreference = GlobalSharedPreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}
