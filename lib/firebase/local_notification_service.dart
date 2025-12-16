import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(iOS: ios, android: android);
    await _plugin.initialize(settings);
  }

  static Future<void> show({
    required String title,
    required String body,
    String? payload,
  }) async {
    const ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const android = AndroidNotificationDetails(
      'default_channel', // id
      'Default', // name
      channelDescription: 'Default channel for notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const details = NotificationDetails(iOS: ios, android: android);

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }
}
