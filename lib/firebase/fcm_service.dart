import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_handler.dart';

// Background handler must be top-level
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationHandler.handleBackgroundMessage(message);
}

class FirebaseMessagingService {
  FirebaseMessagingService._();
  static final FirebaseMessagingService instance = FirebaseMessagingService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static void registerBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> initialize() async {
    _messaging.requestPermission();

    FirebaseMessaging.onMessage.listen(
      NotificationHandler.handleForegroundMessage,
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      NotificationHandler.handleMessageOpenedApp,
    );
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      NotificationHandler.handleMessageOpenedApp(initialMessage);
    }
    final token = await _messaging.getToken();
    print("🔥 FCM Token: $token");
  }
}
