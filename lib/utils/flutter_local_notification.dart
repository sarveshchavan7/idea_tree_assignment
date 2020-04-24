import 'package:flutter_local_notifications/flutter_local_notifications.dart';

mixin FlutterLocalNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings();

  // Initialize notification plugin
  void initNotification() async {
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Display notification
  void displayNotification() async {
    // If we integrate farebase notification will provide channel id,name and desc
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'This is Assignment',
        'idea tree assignment', platformChannelSpecifics,
        payload: 'item x');
  }
}
