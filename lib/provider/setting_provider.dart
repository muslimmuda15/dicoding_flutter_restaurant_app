import 'package:dicoding_flutter_restaurant_app/util/time_converter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const TIME_PICKER_DATA = "time_picker_data";

class SettingProvider extends ChangeNotifier {
  late bool _isDarkMode;
  bool get isDarkMode => _isDarkMode;

  late bool _isAlarmOn;
  bool get isAlarmOn => _isAlarmOn;

  late TimeOfDay? _time;
  TimeOfDay? get time => _time;

  SettingProvider() {
    _time = null;
    _isDarkMode = false;
    _isAlarmOn = false;
    _loadTheme();
    _loadAlarm();
    _loadTime();
  }

  Future<void> _loadTime() async {
    final prefs = await SharedPreferences.getInstance();
    final time = prefs.getInt(TIME_PICKER_DATA);
    if (time == null) {
      _time = TimeOfDay(
        hour: 11,
        minute: 0,
      );
    } else {
      _time = intToTimeOfDay(time);
    }
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  void setTime(TimeOfDay time) async {
    _time = time;
    notifyListeners();
  }

  void setAlarm(bool value) async {
    _isAlarmOn = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAlarmOn', _isAlarmOn);

    notifyListeners();
  }

  void _loadAlarm() async {
    final prefs = await SharedPreferences.getInstance();
    _isAlarmOn = prefs.getBool('isAlarmOn') ?? false;
    notifyListeners();
  }

  void setThemMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);

    notifyListeners();
  }
}
