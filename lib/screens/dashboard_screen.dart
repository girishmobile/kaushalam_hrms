import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:neeknots_admin/core/constants/string_constant.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/provider/app_provider.dart';
import 'package:neeknots_admin/provider/emp_provider.dart';
import 'package:neeknots_admin/provider/profile_provider.dart';
import 'package:neeknots_admin/screens/attendance_screen.dart';
import 'package:neeknots_admin/screens/calendar_screen.dart';
import 'package:neeknots_admin/screens/home_screen.dart';
import 'package:neeknots_admin/screens/my_kpi_screen.dart';
import 'package:neeknots_admin/screens/setting_screen.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
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
      "LEAVES",
      "", // Home has logo
      "ATTENDANCE",
      "SETTINGS",
    ];
    return AppScaffold(
      isTopSafeArea: true,
      child: Stack(
        children: [
          hrmsScreens[provider.pageIndex],
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
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final fullImageUrl =
            (provider.profileImage != null && provider.profileImage!.isNotEmpty)
            ? "${ApiConfig.imageBaseUrl}${provider.profileImage}"
            : hostImage;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appCircleImage(
                imageUrl: fullImageUrl,
                radius: 18,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RouteName.profileScreen,
                    arguments: provider.employeeId,
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

              appCircleIcon(
                icon: Icons.notifications_outlined,

                gradient: appGradient(),
                iconSize: 24,
                onTap: () {
                  Navigator.pushNamed(context, RouteName.notificationPage);
                },
              ),
            ],
          ),
        );
      },
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
            borderRadius: 45,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBottomIcon(
                  context,
                  index: 0,
                  icon: Icons.calendar_month_outlined,
                  title: "Calendar",
                  size: 24,
                ),
                _buildBottomIcon(
                  context,
                  index: 1,
                  icon: Icons.grade_outlined,
                  title: "My KPI",
                  size: 28,
                ),
                _buildBottomIcon(
                  context,
                  index: 2,
                  icon: Icons.home_outlined,
                  title: "Home",
                  size: 28,
                ),
                _buildBottomIcon(
                  context,
                  index: 3,
                  icon: Icons.perm_contact_cal_outlined,
                  title: "Attendance",
                  size: 24,
                ),
                _buildBottomIcon(
                  context,
                  index: 4,
                  icon: Icons.settings_outlined,
                  title: "Setting",
                  size: 28,
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
            color: overlayColor.withOpacity(opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor.withOpacity(0.4),
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
    double? size,
  }) {
    final provider = context.watch<AppProvider>();
    final isSelected = provider.pageIndex == index;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        appCircleIcon(
          icon: icon,
          iconSize: size, // ✅ selected = gradient, unselected = grey
          gradient: isSelected ? appGradient() : appOrangeOffGradient(),

          onTap: () => context.read<AppProvider>().setPageIndex(index),
        ),
        loadSubText(
          title: title,
          fontSize: 10,
          fontWight: isSelected ? FontWeight.w600 : FontWeight.w400,
          fontColor: isSelected ? btnColor2 : Colors.black54,
        ),
      ],
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
                  print("back to Dashboard");
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
