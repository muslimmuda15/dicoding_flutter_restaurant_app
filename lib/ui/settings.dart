import 'package:dicoding_flutter_restaurant_app/notification/local_notification_provider.dart';
import 'package:dicoding_flutter_restaurant_app/provider/setting_provider.dart';
import 'package:dicoding_flutter_restaurant_app/util/time_converter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final notifProvider = Provider.of<LocalNotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Card(
              margin: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              semanticContainer: true,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        Icon(Icons.contrast),
                        SizedBox(
                          width: 16,
                        ),
                        Text('Dark Mode'),
                      ],
                    ),
                    Switch(
                      value: settingProvider.isDarkMode,
                      onChanged: (value) {
                        settingProvider.setThemMode();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              semanticContainer: true,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () async {
                  if (!context.mounted) return;

                  final prefs = await SharedPreferences.getInstance();

                  int time = prefs.getInt(TIME_PICKER_DATA) ??
                      timeOfDayToInt(TimeOfDay(hour: 11, minute: 0));

                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: intToTimeOfDay(time),
                  );

                  if (pickedTime != null) {
                    await prefs.setInt(
                      TIME_PICKER_DATA,
                      timeOfDayToInt(pickedTime),
                    );
                    settingProvider.setTime(pickedTime);
                    notifProvider.cancelNotification(0);
                    notifProvider.scheduleDailyNotification(0);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Icon(Icons.notifications),
                              SizedBox(
                                width: 16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Jam makan siang',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    settingProvider.time != null
                                        ? "${settingProvider.time?.format(context)}"
                                        : TimeOfDay(hour: 11, minute: 0)
                                            .format(context),
                                    style: TextStyle(
                                      height: 1,
                                      fontSize: 36,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      Switch(
                        value: settingProvider.isAlarmOn,
                        onChanged: (value) async {
                          final prefs = await SharedPreferences.getInstance();
                          settingProvider.setAlarm(value);
                          if (value) {
                            int time = prefs.getInt(TIME_PICKER_DATA) ??
                                timeOfDayToInt(
                                  TimeOfDay(hour: 11, minute: 0),
                                );

                            settingProvider.setTime(intToTimeOfDay(time));
                            notifProvider.scheduleDailyNotification(0);
                            Fluttertoast.showToast(
                              msg: "Alarm set ON",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                          } else {
                            notifProvider.cancelNotification(0);
                            Fluttertoast.showToast(
                              msg: "Alarm set OFF",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
