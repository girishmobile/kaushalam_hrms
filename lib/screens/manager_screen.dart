import 'package:flutter/material.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/models/birth_holiday_model.dart';
import 'package:neeknots_admin/provider/emp_provider.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class ManagerScreen extends StatelessWidget {
  const ManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final holidays = provider.birthholidayModel?.holidays ?? <Holiday>[];
    final holidays =
        context.read<EmpProvider>().birthholidayModel?.holidays ?? <Holiday>[];
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 8,
            bottom: listBottom(context),
          ),
          children: [
            appGradientText(
              text: "Leave Request",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              gradient: appGradient(),
            ),
            const SizedBox(height: 8),

            _buildRowItem(
              icon: Icons.rocket_launch_outlined,
              title: "Leave request",
              onTap: () =>
                  Navigator.pushNamed(context, RouteName.pendingLeavePage),
            ),
            const SizedBox(height: 12),
            _buildRowItem(
              icon: Icons.people_outline,
              title: "Employees leave balance",
              onTap: () =>
                  Navigator.pushNamed(context, RouteName.employeeLeaveBalance),
            ),

            SizedBox(height: 16),
            appGradientText(
              text: "HR Department",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              gradient: appGradient(),
            ),
            const SizedBox(height: 8),

            _buildRowItem(
              icon: Icons.beach_access_outlined,
              title: "On Leave",
              onTap: () => Navigator.pushNamed(
                context,
                RouteName.hotlinePage,
                arguments: "on_leave",
              ),
            ),
            const SizedBox(height: 12),
            _buildRowItem(
              icon: Icons.free_breakfast_outlined,
              title: "On Break",
              onTap: () => Navigator.pushNamed(
                context,
                RouteName.hotlinePage,
                arguments: "on_break",
              ),
            ),
            const SizedBox(height: 12),
            _buildRowItem(
              icon: Icons.wifi_tethering_sharp,
              title: "Online Employees",
              onTap: () => Navigator.pushNamed(
                context,
                RouteName.hotlinePage,
                arguments: "Online",
              ),
            ),
            const SizedBox(height: 12),
            _buildRowItem(
              icon: Icons.wifi_tethering_off_outlined,
              title: "Offline Employees",
              onTap: () => Navigator.pushNamed(
                context,
                RouteName.hotlinePage,
                arguments: "Offline",
              ),
            ),
            const SizedBox(height: 12),
            _buildRowItem(
              icon: Icons.home_work_outlined,
              title: "Work from home Employee",
              onTap: () => Navigator.pushNamed(
                context,
                RouteName.hotlinePage,
                arguments: "on_wfh",
              ),
            ),
            const SizedBox(height: 12),
            _buildRowItem(
              icon: Icons.people_alt_outlined,
              title: "Total Employees",
              onTap: () =>
                  Navigator.pushNamed(context, RouteName.allEmplyeePage),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appGradientText(
                  text: "Upcoming Holidays",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  gradient: appGradient(),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteName.holidayPage),
                  child: loadSubText(title: "See All"),
                ),
              ],
            ),
            SizedBox(height: 4),
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final holiday = holidays[index];
                  return holidayCard(item: holiday);
                },
                separatorBuilder: (_, _) => SizedBox(width: 12),
                itemCount: holidays.length,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRowItem({
    required String title,
    required IconData icon,
    VoidCallback? onTap,
    Color iconColor = Colors.black54,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: appViewEffect(
        padding: const EdgeInsets.all(12),
        child: Row(
          spacing: 4,

          children: [
            Icon(icon, color: iconColor),
            Expanded(
              child: loadSubText(title: title, fontColor: Colors.black54),
            ),

            appForwardIcon(),
          ],
        ),
      ),
    );
  }


}
