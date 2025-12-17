import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
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
import 'package:neeknots_admin/provider/manager_hotline_provider.dart';
import 'package:neeknots_admin/provider/manager_provider.dart';
import 'package:neeknots_admin/provider/my_kpi_provider.dart';
import 'package:neeknots_admin/provider/setting_provider.dart';
import 'package:neeknots_admin/utility/image_utils.dart';
import 'package:neeknots_admin/utility/secure_storage.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

import '../api/api_config.dart';
import '../provider/profile_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    initSetting();
  }

  Future<void> initSetting() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<SettingProvider>().loadUserdataFromstorage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Consumer<SettingProvider>(
        builder: (context, provider, child) {
          final username =
              "${provider.userModel?.firstname ?? ""} ${provider.userModel?.lastname ?? ""}";
          final email = provider.userModel?.email ?? "";

          return Stack(
            children: [
              ListView(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: appTopPadding(context),
                ),
                children: [
                  Consumer<ProfileProvider>(
                    builder: (_, profileProvider, _) {
                      return appProfileImage(
                        text: provider.userModel?.firstname ?? '',
                        context: context,
                        imageUrl:
                            "${ApiConfig.imageBaseUrl}${profileProvider.profileImage}",
                        radius: 60,
                        isEdit: false,
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  loadTitleText(title: username, textAlign: TextAlign.center),
                  loadSubText(title: email, textAlign: TextAlign.center),
                  SizedBox(height: 32),
                  _buildRowItem(
                    title: "Edit Profile",
                    icon: icMenuProfile,
                    onTap: () =>
                        /*  Navigator.pushNamed(context, RouteName.editProfilePage),*/
                        Navigator.pushNamed(
                          context,
                          RouteName.profileScreen,
                          arguments: {
                            "employeeId": '${provider.userModel?.id ?? 0}',
                            "isCurrentUser": true,
                          },
                          // arguments: '${provider.userModel?.id??0}',
                        ),
                  ),
                  const SizedBox(height: 12),

                  _buildRowItem(
                    title: "Change Password",
                    icon: icPassword,
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteName.changePasswordPage,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildRowItem(
                    title: "My Hours",
                    icon: icHours,
                    onTap: () =>
                        Navigator.pushNamed(context, RouteName.myHoursPage),
                  ),
                  const SizedBox(height: 12),

                  _buildRowItem(
                    title: "Employees",
                    icon: icEmployee,
                    onTap: () =>
                        Navigator.pushNamed(context, RouteName.allEmplyeePage),
                  ),
                  const SizedBox(height: 12),
                  _buildRowItem(
                    title: "Hotline",
                    icon: icHotline,
                    onTap: () =>
                        Navigator.pushNamed(context, RouteName.hotlineListPage),
                  ),
                  const SizedBox(height: 24),
                  gradientButton(
                    title: "LOGOUT",
                    onPressed: () async {
                      provider.setLoading(true);
                      await SecureStorage.deleteAll().then((val) {
                        provider.setLoading(false);
                      });

                      if (!context.mounted) return;
                      // 🔥 Set page index BEFORE navigation
                      context.read<AppProvider>().resetApp();
                      context.read<MyKpiProvider>().reset();
                      context.read<AttendanceProvider>().reset();
                      context.read<CalendarProvider>().reset();
                      context.read<EmpNotifiProvider>().reset();
                      context.read<EmpProvider>().reset();
                      context.read<HotlineProvider>().reset();
                      context.read<LeaveBalanceProvider>().reset();
                      context.read<LeaveProvider>().reset();
                      context.read<LoginProvider>().reset();
                      context.read<ManagerHotlineProvider>().reset();
                      context.read<ManagerProvider>().reset();
                      context.read<ProfileProvider>().reset();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteName.loginPage,
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
              provider.isLoading ? showProgressIndicator() : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRowItem({
    required String title,
    required String icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: appViewEffect(
        padding: const EdgeInsets.all(12),
        child: Row(
          spacing: 8,

          children: [
            commonPrefixIcon(image: icon),
            //Icon(icon, color: Colors.black54),
            loadSubText(title: title, fontColor: Colors.black54),
            Spacer(),
            appForwardIcon(),
          ],
        ),
      ),
    );
  }
}
