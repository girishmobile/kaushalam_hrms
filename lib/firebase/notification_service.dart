import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../core/router/route_name.dart';


@pragma('vm:entry-point') // 👈 Needed so native code can call it
class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static String? token;
  static bool _permissionRequested = false;

  @pragma('vm:entry-point')
  void initNotificationListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log(
        "🔥 FG Notification received: ${message.messageId}, data: ${message.data}",
      );
      await _showLocalNotification(message);
    });
  }

  static Future<void> initializeApp({
    required GlobalKey<NavigatorState> navigatorKey,
  }) async {
    _navigatorKey = navigatorKey;
    await Firebase.initializeApp();
    await _initializeLocalNotifications();
    await _initializeFirebaseMessaging();
    await initFirebaseToken();

    // Handle notification tap when app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message != null) {
        final safeData = message.data.map(
          (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
        );

        _handlePayloadNavigation(
          payload: safeData['category'] ?? '',
          data: safeData,
        );
      }
    });
  }

  /// Token setup
  static Future<void> initFirebaseToken() async {
    if (Platform.isIOS) {
      // Request permissions on iOS
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      // Note: APNS token will be obtained asynchronously by native code.
      // Do NOT call getAPNSToken() directly as it will fail if not yet available.
    }

    // Wait a bit for APNS token to be available (iOS)
    if (Platform.isIOS) {
      await Future.delayed(const Duration(seconds: 1));
    }

    try {
      token = await FirebaseMessaging.instance.getToken();
      debugPrint("✅ Firebase Token obtained: $token");
    } catch (e) {
      debugPrint('❌ Error getting FCM token: $e');
      token = null;
    }

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      token = newToken;
      debugPrint("✅ Token refreshed: $token");
    });
  }

  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // 👇 Create Android channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // Must match AndroidManifest.xml
      'High Importance Notifications', // Human-readable name
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    // Register the channel with system
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null) {
          try {
            final data = jsonDecode(payload);
            _handlePayloadNavigation(data: data, payload: data['category']);
          } catch (e) {
            debugPrint('Error decoding payload: $e');
          }
        }
      },
    );
  }

  /// FCM setup
  static Future<void> _initializeFirebaseMessaging() async {
    if (_permissionRequested) return;
    _permissionRequested = true;

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      debugPrint('Notification permission declined');
      return;
    }

    debugPrint('Notification permission granted');

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("🔥 Foreground FCM: ${message.data}");
      await _showLocalNotification(message);
    });

    // App opened by tapping notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("📩 Notification opened (background): ${message.data}");
      _handlePayloadNavigation(
        payload: message.data['type'],
        data: message.data,
      );
    });
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      RemoteNotification? notification = message.notification;

      final String title =
          notification?.title ?? message.data['title'] ?? 'New Notification';
      final String body = notification?.body ?? message.data['body'] ?? '';

      final safeData = message.data.map(
        (k, v) => MapEntry(k.toString(), v?.toString() ?? ''),
      );

      await _localNotificationsPlugin.show(
        0,
        title,
        body,
        const NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: jsonEncode(safeData),
      );
    } catch (e) {
      debugPrint("Error showing notification: $e");
    }
  }

  /// Background handler called by native

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    final safeData = message.data.map(
      (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
    );

    debugPrint("🌙 Background notification saved: ${message.messageId}");
    _handlePayloadNavigation(payload: safeData['type'] ?? '', data: safeData);
  }

  /// Handle navigation from notification
  static Future<void> _handlePayloadNavigation({
    required String payload,
    required Map<String, dynamic> data,
  }) async {
    debugPrint('Handling payload: $payload');

    switch (data['type']) {
      case 'leave_request':
        _navigatorKey.currentState?.pushNamed(RouteName.dashboardScreen);
        break;

      default:
        _navigatorKey.currentState?.pushNamed(RouteName.dashboardScreen);
    }
  }
}
