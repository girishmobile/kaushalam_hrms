import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:neeknots_admin/core/router/route_generate.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/provider/app_provider.dart';
import 'package:neeknots_admin/provider/attendance_provider.dart';
import 'package:neeknots_admin/provider/calendar_provider.dart';
import 'package:neeknots_admin/provider/emp_notifi_provider.dart';
import 'package:neeknots_admin/provider/emp_provider.dart';
import 'package:neeknots_admin/provider/hotline_provider.dart';
import 'package:neeknots_admin/provider/leave_balance_provider.dart';
import 'package:neeknots_admin/provider/leave_provider.dart';
import 'package:neeknots_admin/provider/login_provider.dart';
import 'package:neeknots_admin/provider/manager_provider.dart';
import 'package:neeknots_admin/provider/my_kpi_provider.dart';
import 'package:neeknots_admin/provider/product_detail_provider.dart';
import 'package:neeknots_admin/provider/profile_provider.dart';
import 'package:neeknots_admin/provider/setting_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'firebase/firebase_options.dart';
import 'firebase/notification_service.dart';
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log(
    "📩 BG Notification received: ${message.messageId}, data: ${message.data}",
  );
}
Future<void> _initializeFirebase() async {
  int attempts = 0;
  const maxAttempts = 3;

  while (attempts < maxAttempts) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      return;
    } catch (e) {
      attempts++;

      if (attempts == maxAttempts) rethrow;
      await Future.delayed(Duration(seconds: 1));
    }
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();
List<SingleChildWidget> providers = [
  ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
  ChangeNotifierProvider<AppProvider>(create: (_) => AppProvider()),
  ChangeNotifierProvider<ProfileProvider>(create: (_) => ProfileProvider()),
  ChangeNotifierProvider<EmpProvider>(create: (_) => EmpProvider()),
  ChangeNotifierProvider<ManagerProvider>(create: (_) => ManagerProvider()),
  ChangeNotifierProvider<LeaveProvider>(create: (_) => LeaveProvider()),
  ChangeNotifierProvider<SettingProvider>(create: (_) => SettingProvider()),
  ChangeNotifierProvider<EmpNotifiProvider>(create: (_) => EmpNotifiProvider()),
  ChangeNotifierProvider<MyKpiProvider>(create: (_) => MyKpiProvider()),
  ChangeNotifierProvider<AttendanceProvider>(
    create: (_) => AttendanceProvider(),
  ),
  ChangeNotifierProvider<LeaveBalanceProvider>(
    create: (_) => LeaveBalanceProvider(),
  ),
  ChangeNotifierProvider<ProductDetailProvider>(
    create: (_) => ProductDetailProvider(),
  ),
  ChangeNotifierProvider<HotlineProvider>(create: (_) => HotlineProvider()),
  ChangeNotifierProvider<CalendarProvider>(create: (_) => CalendarProvider()),
];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Initialize core services

    await _initializeFirebase();

    // Initialize notifications after Firebase
    await NotificationService.initializeApp(navigatorKey: navigatorKey);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  } catch (e, s) {
    debugPrint('🔥 Critical initialization error: $e\n$s');
    // We'll continue to show UI even if services fail
  }
  runApp( MyApp( navigatorKey: navigatorKey,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,  required this.navigatorKey,});
  final GlobalKey<NavigatorState> navigatorKey;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        navigatorKey: navigatorKey,
       // showPerformanceOverlay: true,
        title: 'hrms',
        theme: ThemeData(
          fontFamily: "Poppins",
          colorScheme: ColorScheme.fromSeed(seedColor: btnColor2),
        ),
        initialRoute: RouteName.splashScreen,
        onGenerateRoute: RouteGenerate.onGenerateRoute,
        debugShowCheckedModeBanner: false,
        // home: DashboardPage(),
      ),
    );
  }
}
