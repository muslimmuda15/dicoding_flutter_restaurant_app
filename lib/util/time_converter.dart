import 'package:flutter/material.dart';

/*
  * This function contains utility functions to convert TimeOfDay to integer.
  * This is useful when we need to store TimeOfDay in SharedPreferences.
  */
int timeOfDayToInt(TimeOfDay time) {
  return time.hour * 60 + time.minute;
}

/*
 * This function contains utility functions to convert integer to TimeOfDay.
 * This is useful when we need to get TimeOfDay from SharedPreferences.
 */

TimeOfDay intToTimeOfDay(int totalMinutes) {
  int hours = totalMinutes ~/ 60;
  int minutes = totalMinutes % 60;
  return TimeOfDay(hour: hours, minute: minutes);
}
