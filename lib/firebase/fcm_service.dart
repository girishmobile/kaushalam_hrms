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
    // 1️⃣ Request permission
    _messaging.requestPermission(alert: true, badge: true, sound: true);

    // 2️⃣ REQUIRED FOR iOS FOREGROUND
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    // 3️⃣ Token refresh (safe)
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      print('🔥 FCM Token: $token');
    });
    // 4️⃣ Foreground messages
    FirebaseMessaging.onMessage.listen(
      NotificationHandler.handleForegroundMessage,
    );

    // 5️⃣ Opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(
      NotificationHandler.handleMessageOpenedApp,
    );

    // 6️⃣ Opened from terminated
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      NotificationHandler.handleMessageOpenedApp(initialMessage);
    }
  }

  Future<void> fetchTokenSafely() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      final token = await FirebaseMessaging.instance.getToken();
      print('Delayed FCM token: $token');
    } catch (_) {
      // ignore
    }
  }
}
