import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_dialog.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/models/all_leave_model.dart';
import 'package:neeknots_admin/provider/leave_provider.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class LeaveSummaryPage extends StatefulWidget {
  final String pageTitle;

  const LeaveSummaryPage({super.key, required this.pageTitle});

  @override
  State<LeaveSummaryPage> createState() => _LeaveSummaryPageState();
}

class _LeaveSummaryPageState extends State<LeaveSummaryPage> {
  @override
  void initState() {
    super.initState();
    initLeave();
  }

  Future<void> initLeave() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaveProvider>().getAllLeaveByEmployee(
        title: widget.pageTitle,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Fetch API only once when page opens

    return AppScaffold(
      appTitle: "${widget.pageTitle.toUpperCase()} LEAVES",
      child: Consumer<LeaveProvider>(
        builder: (context, provider, child) {
          return appRefreshIndicator(
            onRefresh: () async {
              initLeave();
            },
            child: Stack(
              children: [
                provider.listOfLeave.isEmpty && !provider.isLoading
                    ? Center(
                        child: Text("You don’t have any leave records yet."),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 0,
                        ),
                        itemBuilder: (context, index) {
                          final leave = provider.listOfLeave[index];

                          return _buildLeaveItem(
                            item: leave,
                            provider: provider,
                          );
                        },
                        separatorBuilder: (_, _) => SizedBox(height: 8),
                        itemCount: provider.listOfLeave.length,
                      ),

                provider.isLoading
                    ? showProgressIndicator()
                    : SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
    );
  }

  String getAppliedDate(MyLeave item) {
    if (item.leaveHistory == null || item.leaveHistory!.isEmpty) return "-";

    final rawDate = item.leaveHistory!.first.createdAt?.date;
    return convertDate(rawDate);
  }

  Widget _buildLeaveItem({
    required MyLeave item,
    required LeaveProvider provider,
  }) {
    final displayLeave = getLeaveTypeName(item.leaveType?.leavetype);

    return appViewEffect(
      child: Column(
        spacing: 4,
        children: [
          rowItem(title: "Leave type:", subTitle: displayLeave),
          rowItem(title: "Days:", subTitle: "${item.leaveCount} Days"),
          rowItem(title: "Reason:", subTitle: "${item.reason}"),
          rowItem(
            title: "Status:",
            subTitle: "${item.status}",
            onEdit: () async {
              final refresh = await Navigator.pushNamed(
                context,
                RouteName.editLeavePage,
                arguments: item,
              );
              if (refresh == true) {
                initLeave();
              }
            },

            onDelete: () {
              showDialog(
                barrierColor: Colors.black.withValues(alpha: 0.2),
                context: context,
                builder: (_) => AppDialog(
                  title: "Delete",
                  message:
                      "Are you sure you want to delete this leave request?",
                  onConfirm: () async {
                    //delete login
                    Navigator.pop(context);
                    final Map<String, dynamic> body = {"id": item.id};
                    await provider.deleteLeave(body: body);
                    if (!mounted) return; // ✅ use the State's mounted
                    if (provider.deleteSuccess) {
                      showSnackBar(
                        context,
                        message: "Leave deleted successfully.",
                        bgColor: Colors.green,
                      );
                      initLeave();
                    } else {
                      showSnackBar(
                        context,
                        message: "Failed to delete leave request",
                        bgColor: Colors.redAccent,
                      );
                    }
                  },
                  onCancel: () => Navigator.pop(context),
                ),
              );
            },
          ),
          rowItem(title: "Applied:", subTitle: getAppliedDate(item)),
          SizedBox(height: 8),
          Container(
            height: 36,
            decoration: BoxDecoration(
              border: BoxBorder.all(color: color2, width: 1),
              // border: getStatusBorder(item.status),
            ),
            child: Center(
              child: appGradientText(
                text:
                    "Leave: ${comrateStartEndate(item.leaveDate?.date, item.leaveEndDate?.date)}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black54,
                ),
                gradient: appGradient(), // getStatusGradient(item.status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxBorder getStatusBorder(String? status) {
    final value = status?.toLowerCase() ?? "";
    switch (value) {
      case "pending":
        return BoxBorder.all(color: Colors.orange, width: 1);

      case "accept":
        return BoxBorder.all(color: Colors.green, width: 1);

      case "reject":
        return BoxBorder.all(color: Colors.red, width: 1);

      case "cancel":
        return BoxBorder.all(color: Colors.grey, width: 1);

      default:
        return BoxBorder.all(color: color2, width: 0);
    }
  }

  LinearGradient getStatusGradient(String? status) {
    final value = status?.toLowerCase() ?? "";

    switch (value) {
      case "pending":
        //return BoxBorder.all(color: Colors.orange, width: 1);
        return LinearGradient(colors: [btnColor1, btnColor2]);

      case "accept":
        //return BoxBorder.all(color: Colors.green, width: 1);
        return LinearGradient(colors: [Colors.green, Colors.lightGreen]);

      case "reject":
        //return BoxBorder.all(color: Colors.red, width: 1);
        return LinearGradient(colors: [Colors.red, Colors.redAccent.shade400]);

      case "cancel":
        //return BoxBorder.all(color: Colors.grey, width: 1);
        return LinearGradient(colors: [Colors.blueGrey, Colors.grey]);

      default:
        return appGradient();
    }
  }

  Widget rowItem({
    required String title,
    required String subTitle,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 12,
      children: [
        loadTitleText(title: title, fontWight: FontWeight.w600, fontSize: 12),
        Expanded(child: loadSubText(title: subTitle, fontSize: 12)),
        if (subTitle.toLowerCase() == "pending") ...[
          TextButton(
            onPressed: onEdit,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero, // Removes min tap target constraints
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text("Edit"),
          ),
          SizedBox(width: 10),
          TextButton(
            onPressed: onDelete,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero, // Removes min tap target constraints
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text("Delete"),
          ),
          SizedBox(width: 10),
        ],
      ],
    );
  }
}
