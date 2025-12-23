import 'package:flutter/material.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/models/birth_holiday_model.dart';
import 'package:neeknots_admin/provider/emp_provider.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class EmployeeScreen extends StatefulWidget {
  final String employeeId;
  const EmployeeScreen({super.key, required this.employeeId});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  @override
  void initState() {
    super.initState();
    initEmp();
  }

  Future<void> initEmp() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<EmpProvider>(context, listen: false);
      await Future.wait([
        provider.getCurrentAttendance(),
        provider.getLeaveSummary(),
        provider.getLeaveBalance(body: {"emp_id": widget.employeeId}),
        // provider.getUpcomingBirthHodliday(),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmpProvider>(
      builder: (context, provider, child) {
        final birthdays = provider.birthholidayModel?.birthdays ?? <BirthDay>[];
        final holidays = provider.birthholidayModel?.holidays ?? <Holiday>[];
        return appRefreshIndicator(
          onRefresh: () async {
            initEmp();
          },
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 8,
                  bottom: listBottom(context, extra: 44),
                ),
                //padding: EdgeInsets.zero, // 👈 important
                primary: false,
                children: [
                  appGradientText(
                    text: "Your Attendance",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    gradient: appGradient(),
                  ),
                  SizedBox(height: 8),
                  _attendanceCart(context),
                  const SizedBox(height: 16),
                  appGradientText(
                    text: "Leave summary",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    gradient: appGradient(),
                  ),
                  const SizedBox(height: 16),

                  _buildRowItem(
                    title:
                        "Pending leave (${provider.leaveSummary?.pending ?? "0"})",
                    icon: Icons.hourglass_top_rounded,
                    iconColor: Colors.orange,
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteName.leaveSummaryPage,
                      arguments: "Pending",
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildRowItem(
                    title:
                        "Accepted leave (${provider.leaveSummary?.accept ?? "0"})",
                    icon: Icons.check_circle_outline_rounded,
                    iconColor: Colors.green,
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteName.leaveSummaryPage,
                      arguments: "Accept",
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildRowItem(
                    title:
                        "Cancel leave (${provider.leaveSummary?.cancel ?? "0"})",
                    icon: Icons.cancel_outlined,
                    iconColor: Colors.grey,
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteName.leaveSummaryPage,
                      arguments: "Cancel",
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildRowItem(
                    title:
                        "Reject leave (${provider.leaveSummary?.reject ?? "0"})",
                    icon: Icons.highlight_off_rounded,
                    iconColor: Colors.red,
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteName.leaveSummaryPage,
                      arguments: "Reject",
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRowItem(
                    title: "All leave (${provider.leaveSummary?.all ?? "0"})",
                    icon: Icons.list_alt_rounded,
                    iconColor: Colors.blue,
                    onTap: () =>
                        // Navigator.pushNamed(context, RouteName.allLeavePage),
                        Navigator.pushNamed(
                          context,
                          RouteName.leaveSummaryPage,
                          arguments: "All",
                        ),
                  ),

                  const SizedBox(height: 16),
                  appGradientText(
                    text: "Leave Balance",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    gradient: appGradient(),
                  ),
                  const SizedBox(height: 16),

                  _buildRowItem(
                    title: "Casual Leaves (${provider.leaveBalance?.cl ?? 0})",
                    icon: Icons.beach_access_outlined,
                    iconColor: Colors.teal,
                    onTap: () {},
                    showArrow: false,
                    //Navigator.pushNamed(context, RouteName.leaveSummaryPage),
                  ),
                  const SizedBox(height: 12),

                  _buildRowItem(
                    title: "Sick Leaves (${provider.leaveBalance?.sl ?? 0})",
                    icon: Icons.medical_services_outlined,
                    iconColor: Colors.redAccent,
                    onTap: () {},
                    showArrow: false,
                    //Navigator.pushNamed(context, RouteName.leaveSummaryPage),
                  ),
                  const SizedBox(height: 12),

                  _buildRowItem(
                    title: "Paid Leaves (${provider.leaveBalance?.pl ?? 0})",
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: Colors.indigo,
                    onTap: () {},
                    showArrow: false,
                    // Navigator.pushNamed(context, RouteName.leaveSummaryPage),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      appGradientText(
                        text: "Upcoming Birthday",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        gradient: appGradient(),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          RouteName.birthdayList,
                        ),
                        child: loadSubText(title: "See All"),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final birthday = birthdays[index];
                        return birthDayCard(item: birthday);
                      },
                      separatorBuilder: (_, _) => SizedBox(width: 12),
                      itemCount: birthdays.length,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      appGradientText(
                        text: "Upcoming Holidays",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
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
                    height: 100,
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
              provider.isLoading ? showProgressIndicator() : SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  Widget _attendanceCart(BuildContext context) {
    return appViewEffect(
      padding: const EdgeInsets.all(16),
      child: Consumer<EmpProvider>(
        builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildItem(
                      title: "Attendance",
                      value:
                          "${provider.attendanceModel?.presentDays ?? 0} Days",
                    ),
                  ),
                  Expanded(
                    child: _buildItem(
                      title: "Late",
                      value: "${provider.attendanceModel?.lateDays ?? 0} Days",
                    ),
                  ),
                  Expanded(
                    child: _buildItem(
                      title: "Absent",
                      value:
                          "${provider.attendanceModel?.absentDays ?? 0} Days",
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: _buildItem(
                      title: "Half Days",
                      value: "${provider.attendanceModel?.halfDays ?? 0} Days",
                    ),
                  ),
                  Expanded(
                    child: _buildItem(
                      title: "Worked hours",
                      value:
                          '${provider.attendanceModel?.empStaffing?['hours'] ?? 0} hr  ${provider.attendanceModel?.empStaffing?['minutes'] ?? 0} mins',
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ), // empty to maintain alignment
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRowItem({
    required String title,
    required IconData icon,
    Color? iconColor = Colors.black54,
    VoidCallback? onTap,
    bool showArrow = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: appViewEffect(
        padding: const EdgeInsets.all(12),
        child: Row(
          spacing: 4,

          children: [
            Icon(icon, color: iconColor),
            loadSubText(title: title, fontColor: Colors.black54),
            Spacer(),
            if (showArrow) appForwardIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
