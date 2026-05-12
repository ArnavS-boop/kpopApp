import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  void setLight() {
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  void setDark() {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  void toggle() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
