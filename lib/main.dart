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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        navigatorKey: navigatorKey, // ✅ IMPORTANT
        title: 'Flutter Demo',
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
