import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    FlutterLocalNotificationsPlugin().initialize(
      initializationSettings,
    );
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
        ),
        body: Container(
          child: Center(
            child: Text('Test Notifications'),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _configureLocalTimeZone();
            var scheduledNotificationDateTime = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));
            var androidPlatformChannelSpecifics = AndroidNotificationDetails(
              'your other channel id',
              'your other channel name',
              'your other channel description',
            );
            var iOSPlatformChannelSpecifics = IOSNotificationDetails();
            NotificationDetails platformChannelSpecifics = NotificationDetails(
              android: androidPlatformChannelSpecifics,
              iOS: iOSPlatformChannelSpecifics,
            );

            await FlutterLocalNotificationsPlugin().zonedSchedule(
              099,
              'scheduled title',
              'scheduled body',
              scheduledNotificationDateTime,
              platformChannelSpecifics,
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
            );
            print(scheduledNotificationDateTime);
          },
        ),
      ),
    );
  }
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  print(timeZoneName);
  tz.setLocalLocation(tz.getLocation(timeZoneName));
  // tz.setLocalLocation(tz.getLocation('America/Detroit'));
}

Future<void> configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  try {
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  } catch (e) {
// Failed to get timezone or device is GMT or UTC, assign generic timezone
    const String fallback = 'Africa/Accra';
    tz.setLocalLocation(tz.getLocation(fallback));
  }
}
