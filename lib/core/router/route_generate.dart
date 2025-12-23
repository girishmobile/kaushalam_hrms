import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/models/all_leave_model.dart';
import 'package:neeknots_admin/models/hotline_count_model.dart';
import 'package:neeknots_admin/pages/login/forgot_password_page.dart';
import 'package:neeknots_admin/pages/login/login_page.dart';
import 'package:neeknots_admin/pages/login/signup_page.dart';
import 'package:neeknots_admin/pages/notification_page.dart';
import 'package:neeknots_admin/screens/all_leave_page.dart';
import 'package:neeknots_admin/screens/apply_leave_page.dart';
import 'package:neeknots_admin/screens/birthday_list.dart';
import 'package:neeknots_admin/screens/dashboard_screen.dart';
import 'package:neeknots_admin/screens/edit_leave_page.dart';
import 'package:neeknots_admin/screens/employee_leave_balance.dart';
import 'package:neeknots_admin/screens/holiday_page.dart';
import 'package:neeknots_admin/screens/hotline/hotline_list_page.dart';
import 'package:neeknots_admin/screens/hotline/hotline_page.dart';
import 'package:neeknots_admin/screens/kpi_details/kpi_details_screen.dart';
import 'package:neeknots_admin/screens/leave_summary_page.dart';
import 'package:neeknots_admin/screens/pending_leave_page.dart';
import 'package:neeknots_admin/screens/profile_page.dart';
import 'package:neeknots_admin/screens/profile_screen.dart';
import 'package:neeknots_admin/screens/setting/all_emplyee_page.dart';
import 'package:neeknots_admin/screens/setting/change_password_page.dart';
import 'package:neeknots_admin/screens/setting/edit_profile_page.dart';
import 'package:neeknots_admin/screens/setting/employee_detail_page.dart';
import 'package:neeknots_admin/screens/setting/my_hours_page.dart';
import 'package:neeknots_admin/screens/splash_screen.dart';

class RouteGenerate {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Widget screen;
    switch (settings.name) {
      case RouteName.splashScreen:
        screen = const SplashScreen();
        break;
      case RouteName.loginPage:
        screen = const LoginPage();
        break;
      case RouteName.singUpPage:
        screen = const SignupPage();
        break;
      case RouteName.forgotPasswordPage:
        screen = const ForgotPasswordPage();
        break;
      case RouteName.profilePage:
        screen = const ProfilePage();
        break;
      case RouteName.notificationPage:
        screen = const NotificationPage();
        break;
      //Orange theme
      case RouteName.dashboardScreen:
        screen = const DashboardScreen();
        break;
      case RouteName.leaveSummaryPage:
        final args = settings.arguments as String;
        screen = LeaveSummaryPage(pageTitle: args);
        break;
      case RouteName.applyLeavePage:
        screen = const ApplyLeavePage();
        break;
      case RouteName.profileScreen:
        final args = settings.arguments as Map<String, dynamic>;

        screen = ProfileScreen(
          employeeId: args["employeeId"],
          isCurrentUser: args["isCurrentUser"],
        );
        break;
      case RouteName.editProfilePage:
        screen = const EditProfilePage();
        break;
      case RouteName.changePasswordPage:
        screen = const ChangePasswordPage();
        break;
      case RouteName.myHoursPage:
        screen = const MyHoursPage();
        break;
      case RouteName.allEmplyeePage:
        screen = const AllEmplyeePage();
        break;
      case RouteName.employeeDetailPage:
        final args = settings.arguments as String;
        screen = EmployeeDetailPage(employeeId: args);
        break;
      case RouteName.holidayPage:
        screen = const HolidayPage();
        break;
      case RouteName.pendingLeavePage:
        screen = const PendingLeavePage();
        break;
      case RouteName.birthdayList:
        screen = const BirthdayList();
        break;
      case RouteName.employeeLeaveBalance:
        screen = const EmployeeLeaveBalance();
        break;
      case RouteName.allLeavePage:
        screen = const AllLeavePage();
        break;
      case RouteName.editLeavePage:
        final args = settings.arguments as MyLeave;
        screen = EditLeavePage(item: args);
        break;
      case RouteName.hotlineListPage:
        screen = const HotlineListPage();
        break;
      case RouteName.hotlinePage:
        final args = settings.arguments as HotlineCountModel;
        screen = HotlinePage(status: args);
        break;
      case RouteName.kpiDetailsScreen:
        final args = settings.arguments as Map<String, dynamic>;
        screen = KpiDetailsScreen(year: args["year"], month: args["month"]);
        break;

      default:
        screen = AppScaffold(
          child: Center(child: Text("No route define for ${settings.name}")),
        );
    }
    return _pageRouteBuilder(screen, settings);
  }

  static PageRouteBuilder _pageRouteBuilder(
    Widget screen,
    RouteSettings settings,
  ) {
    return PageRouteBuilder(
      opaque: false,
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
