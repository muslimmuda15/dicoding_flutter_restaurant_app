import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
