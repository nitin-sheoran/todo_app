// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
//
// class LocalNotification {
//   static final FlutterLocalNotificationsPlugin
//   _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   static final GlobalKey<NavigatorState> navigatorKey =
//   GlobalKey<NavigatorState>();
//
//   static Future init() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initializationSettings =
//     InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//     _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (details) async {
//         await _handleNotificationResponse(details);
//       },
//     );
//   }
//
//   static Future<void> _handleNotificationResponse(details) async {
//     // await navigatorKey.currentState?.push(
//     //   MaterialPageRoute(
//     //     builder: (context) =>
//     //     const DownloadScreen(), // Navigate to DownloadScreen
//     //   ),
//     // );
//   }
//
//   static Future showNotification(
//       {required int id,
//         required String title,
//         required String body,
//         required String payload}) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails('NotaAI', 'PushNotificationAppChannel',
//         importance: Importance.max,
//         priority: Priority.high,
//         playSound: true,
//         enableVibration: true,
//         ticker: 'ticker');
//     const NotificationDetails notificationDetails =
//     NotificationDetails(android: androidNotificationDetails);
//     await _flutterLocalNotificationsPlugin
//         .show(id, title, body, notificationDetails, payload: payload);
//   }
//
//   Future scheduleNotification(
//       {required int id,
//         String? title,
//         String? body,
//         String? payLoad,
//         required DateTime scheduledNotificationDateTime}) async {
//     AndroidNotificationDetails androidNotificationDetails =
//     const AndroidNotificationDetails("NotaAI", "PushNotificationAppChannel",
//         importance: Importance.max, priority: Priority.high);
//     NotificationDetails notificationDetails =
//     NotificationDetails(android: androidNotificationDetails);
//     return _flutterLocalNotificationsPlugin.zonedSchedule(
//         id,
//         title,
//         body,
//         tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
//         notificationDetails,
//         uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime,
//         androidAllowWhileIdle: true);
//   }
//
//   void stopNotifications(
//       int id,
//       ) async {
//     _flutterLocalNotificationsPlugin.cancel(id);
//   }
// }
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotification {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  static Future<void> showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin
        .show(id, title, body, platformChannelSpecifics, payload: payload);
  }

  static Future<void> scheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      required DateTime scheduledDate,
      String? payload}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    final tz.TZDateTime scheduledTZDate =
        tz.TZDateTime.from(scheduledDate, tz.local);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTZDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }
}
