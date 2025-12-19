import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/provider/app_provider.dart';
import 'package:neeknots_admin/provider/emp_provider.dart';
import 'package:neeknots_admin/provider/profile_provider.dart';
import 'package:neeknots_admin/screens/attendance_screen.dart';
import 'package:neeknots_admin/screens/calendar_screen.dart';
import 'package:neeknots_admin/screens/home_screen.dart';
import 'package:neeknots_admin/screens/my_kpi_screen.dart';
import 'package:neeknots_admin/screens/setting_screen.dart';
import 'package:neeknots_admin/utility/image_utils.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

import '../provider/emp_notifi_provider.dart';
import '../utility/secure_storage.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<EmpProvider>(context, listen: false);

      await Future.wait([
        provider.updateFCMToken(),
        provider.getUpcomingBirthHodliday(),
        context.read<EmpNotifiProvider>().getEmployeeNotification(),
      ]);
    });
    super.initState();
    _initdashboard();
  }

  Future<void> _initdashboard() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      final user = await SecureStorage.getUser();
      final body = {"employee_id": user?.id};
      await Future.wait([
        provider.getUserProfile(body: body, isCurrentUser: true),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final hrmsScreens = [
      CalendarScreen(),
      MyKpiScreen(),
      HomeScreen(),
      AttendanceScreen(),
      SettingScreen(),
    ];
    final titles = [
      "CALENDAR",
      "MY KPI",
      "", // Home has logo
      "ATTENDANCE",
      "SETTINGS",
    ];
    return AppScaffold(
      //isTopSafeArea: true,
      child: Stack(
        children: [
          hrmsScreens[provider.pageIndex],
          Positioned(
            child: Container(
              height: appTopPadding(context),
              width: double.infinity,
              color: Colors.white,
            ),
          ),
          topBar(
            context,
            provider: provider,
            title: titles[provider.pageIndex],
          ),
          bottomBar(context),
          if (provider.pageIndex == 2 && !provider.isManager)
            _leaveRequest(context),
        ],
      ),
    );
  }

  Widget topBar(
    BuildContext context, {
    required AppProvider provider,
    required String title,
  }) {
    return SafeArea(
      child: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<ProfileProvider>(
                  builder: (_, profileProvider, _) {
                    return appCircleImage(
                      borderColor: color2,
                      text: profileProvider.profileModel?.firstname,
                      imageUrl: setImagePath(profileProvider.profileImage),
                      radius: 18,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteName.profileScreen,
                          arguments: {
                            "employeeId": provider.employeeId,
                            "isCurrentUser": true,
                          },
                          //arguments: provider.employeeId,
                        );
                      },
                    );
                  },
                ),

                // ✅ Show logo only for Home, otherwise show title
                provider.pageIndex == 2
                    ? appGradientText(
                        text: "KAUSHALAM",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                        gradient: appGradient(),
                      ) //loadAssetImage(name: headerlogo, height: 26)
                    : appGradientText(
                        text: title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        gradient: appGradient(),
                      ), //loadAssetImage(name: headerlogo, height: 26)

                Consumer<EmpNotifiProvider>(
                  builder: (context, empProvider, _) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteName.notificationPage,
                        );
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          appGradientImage(
                            imagePath: icNotification,
                            size: 24,
                            gradient: appGradient(),
                          ),
                          Positioned(
                            right: -2,
                            top: -3,
                            child: Container(
                              decoration: commonBoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              width: 18,
                              height: 18,
                              child: Center(
                                child: loadSubText(
                                  title: empProvider.unreadCount.toString(),
                                  fontColor: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget bottomBar(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        bottom: true,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),

          child: _buildGlassEffect(
            // overlayColor: Colors.white,
            borderRadius: 45,
            borderColor: Colors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBottomIcon(
                  context,
                  index: 0,

                  icon: Icons.calendar_month_outlined,
                  title: "Calendar",
                  imagePath: icMenuCalender,
                  size: 24,
                ),
                _buildBottomIcon(
                  context,
                  index: 1,
                  icon: Icons.grade_outlined,
                  title: "My KPI",
                  imagePath: icMenuKPI,
                  size: 20,
                ),
                _buildBottomIcon(
                  context,
                  index: 2,
                  icon: Icons.home_outlined,
                  title: "Home",
                  imagePath: icMenuHome,
                  size: 20,
                ),
                _buildBottomIcon(
                  context,
                  index: 3,
                  icon: Icons.perm_contact_cal_outlined,
                  title: "Attendance",
                  imagePath: icMenuAttendance,
                  size: 20,
                ),
                _buildBottomIcon(
                  context,
                  index: 4,
                  icon: Icons.settings_outlined,
                  title: "Setting",
                  imagePath: icSetting,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassEffect({
    required Widget child,
    double borderRadius = 12,
    EdgeInsetsGeometry? padding,
    double blurSigma = 10,
    Color overlayColor = Colors.white,
    double opacity = 0.15,
    Color borderColor = Colors.white,
    double borderWidth = 1.0,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: overlayColor.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor.withValues(alpha: 0.4),
              width: borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildBottomIcon(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String title,
    required String imagePath,
    double? size,
  }) {
    final provider = context.watch<AppProvider>();
    final isSelected = provider.pageIndex == index;

    return InkWell(
      onTap: () => context.read<AppProvider>().setPageIndex(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // appCircleIcon(
          //   icon: icon,
          //   iconSize: size, // ✅ selected = gradient, unselected = grey
          //   gradient: isSelected ? appGradient() : appOrangeOffGradient(),
          // ),
          appGradientImage(
            imagePath: imagePath,
            size: 24,
            gradient: isSelected ? appGradient() : appOrangeOffGradient(),
          ),
          loadSubText(
            title: title,
            fontSize: 10,
            fontWight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontColor: isSelected ? btnColor2 : Colors.black45,
          ),
        ],
      ),
    );
  }

  Widget _leaveRequest(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: appBottomPadding(context, extra: 60),
          ),
          child: Container(
            //margin: const EdgeInsets.symmetric(horizontal: 24),
            height: 44,
            decoration: BoxDecoration(
              gradient: appGradient(colors: [btnColor1, btnColor2]),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextButton.icon(
              onPressed: () async {
                final refresh = await Navigator.pushNamed(
                  context,
                  RouteName.applyLeavePage,
                );

                if (refresh == true) {
                  // user is employee
                  final emp = context.read<EmpProvider>();
                  final app = context.read<AppProvider>();
                  await Future.wait([
                    emp.getLeaveSummary(),
                    emp.getLeaveBalance(body: {"emp_id": app.employeeId}),
                  ]);
                }
              },

              label: const Text(
                "Apply Leave",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
