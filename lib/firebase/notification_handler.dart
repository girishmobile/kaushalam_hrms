import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:neeknots_admin/firebase/local_notification_service.dart';

class NotificationHandler {
  static Future<void> handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await LocalNotificationService.show(
      title: notification.title ?? '',
      body: notification.body ?? '',
      payload: message.data['route'],
    );
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Background message: ${message.messageId}');
  }

  static Future<void> handleMessageOpenedApp(RemoteMessage message) async {
    print('Opened app from notification: ${message.messageId}');
  }
}
