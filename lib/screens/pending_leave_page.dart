import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:neeknots_admin/common/app_dialog.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:neeknots_admin/models/all_leave_model.dart';
import 'package:neeknots_admin/provider/app_provider.dart';
import 'package:neeknots_admin/provider/manager_provider.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class PendingLeavePage extends StatefulWidget {
  const PendingLeavePage({super.key});

  @override
  State<PendingLeavePage> createState() => _PendingLeavePageState();
}

class _PendingLeavePageState extends State<PendingLeavePage> {
  int selectedIndex = 0;

  String userId = "";

  final List<String> filters = [
    "Recent Leave",
    "Today Leave",
    "Early Leave",
    "Pending Leave",
    "Approved Leave",
    "Rejected Leave",
    "Canceled Leave",
  ];
  @override
  void initState() {
    super.initState();
    initLeave();
  }

  Future<void> initLeave() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ManagerProvider>().getAllLeavesForManager();
      userId = context.read<AppProvider>().employeeId ?? '';
      print("UserID:- $userId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Consumer<ManagerProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              provider.listOfLeave.isEmpty && !provider.isLoading
                  ? Center(child: Text("You don’t have any leave records yet."))
                  : ListView.separated(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: appTopPadding(context),
                        bottom: appBottomPadding(context),
                      ),
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: true,
                      cacheExtent: 500,
                      itemBuilder: (context, index) {
                        final leave = provider.listOfLeave[index];
                        return RepaintBoundary(
                          child: GestureDetector(
                            onTap: () {
                              showCommonBottomSheet(
                                context: context,
                                content: _leaveInfoView(leave: leave),
                              );
                            },
                            child: leaveCard(
                              item: leave,
                              onAccept: () async {
                                if (userId != "${leave.userId?.id}") {
                                  Map<String, dynamic> body = {"id": leave.id};

                                  showDialog(
                                    context: context,
                                    builder: (_) => AppDialog(
                                      title: "Approved",
                                      message:
                                          "Are you sure you want to approve this leave?",
                                      confirmText: "Yes",
                                      cancelText: "No",
                                      onConfirm: () async {
                                        Navigator.pop(context);
                                        await provider.approvedLeave(
                                          context,
                                          body: body,
                                        );
                                      },
                                      onCancel: () => Navigator.pop(context),
                                    ),
                                  );
                                } else {
                                  if (!context.mounted) return;
                                  showSnackBar(
                                    context,
                                    message:
                                        "You can't approve your own leave.!",
                                    bgColor: Colors.redAccent,
                                  );
                                }
                              },
                              onReject: () {
                                if (userId != "${leave.userId?.id}") {
                                  showRejectLeaveDialog(context, (
                                    reason,
                                  ) async {
                                    Map<String, dynamic> body = {
                                      "id": leave.id,
                                      "reject_reason": reason,
                                    };
                                    await provider.rejectLeave(
                                      context,
                                      body: body,
                                    );
                                  });
                                } else {
                                  if (!context.mounted) return;
                                  showSnackBar(
                                    context,
                                    message:
                                        "You can't reject your own leave.!",
                                    bgColor: Colors.redAccent,
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemCount: provider.listOfLeave.length,
                    ),
              appNavigationBar(
                title: "LEAVES REQUEST",
                onTap: () => Navigator.pop(context),
              ),
              provider.isLoading ? showProgressIndicator() : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  Widget _leaveInfoView({required MyLeave leave}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              loadTitleText(title: "Leave Details", fontWight: FontWeight.w500),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero, // Removes min tap target constraints
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Expanded(
            child: appViewEffect(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        appCircleImage(
                          imageUrl: setImagePath(leave.userId?.profileImage),
                          radius: 24,
                          icon: Icons.person_outline,
                          iconColor: color3,
                          borderColor: color2,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              loadTitleText(
                                title:
                                    "${leave.userId?.firstname} ${leave.userId?.lastname}",
                                fontSize: 14,
                                fontWight: FontWeight.w500,
                              ),
                              loadSubText(
                                title:
                                    "Leave On: ${convertDate(leave.leaveDate?.date, format: "dd-MMM-yyyy")}",
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ),
                        loadSubText(
                          title: leave.status ?? '',
                          fontColor: color3,
                          fontSize: 12,
                        ),
                      ],
                    ),
                    _buidRowItem(
                      label: "Leave Type",
                      titleText: getLeaveTypeName(
                        leave.leaveType?.leavetype ?? '',
                      ),
                    ),
                    _buidRowItem(
                      label: "Date",
                      titleText: comrateStartEndate(
                        leave.leaveDate?.date.toString(),
                        leave.leaveEndDate?.date.toString(),
                      ),
                    ),
                    _buidRowItem(
                      label: "Days",
                      titleText: leave.leaveCount ?? '',
                    ),
                    _buidRowItem(
                      label: "Half Day",
                      titleText: leave.halfDay == true ? "Yes" : "No",
                    ),
                    _buidRowItem(
                      label: "Location",
                      titleText: leave.location ?? '',
                    ),
                    Column(
                      spacing: 4,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        loadTitleText(
                          title: "Reason",
                          fontWight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        loadSubText(
                          fontSize: 12,
                          title:
                              "${leave.reason} this is leave reasing for the testiing multiple line of the year greathe thing in life 2025",
                        ),
                      ],
                    ),
                    loadTitleText(
                      title: "Leave History",
                      fontWight: FontWeight.w600,
                      fontSize: 12,
                    ),

                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: leave.leaveHistory?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Html(
                          data: leave.leaveHistory?[index].msg ?? '',
                          style: {
                            "body": Style(
                              fontSize: FontSize(12),
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero,
                            ),
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buidRowItem({required String label, required String titleText}) {
    return Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        loadTitleText(title: label, fontWight: FontWeight.w500, fontSize: 12),
        Expanded(
          child: loadSubText(
            title: titleText,
            textAlign: TextAlign.end,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _filterOption() {
    return Positioned(
      top: appTopPadding(context, extra: 8),
      left: 24,
      right: 24,
      child: SizedBox(
        width: double.infinity,
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,

          itemBuilder: (context, index) {
            final isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () => setState(() => selectedIndex = index),
              child: AnimatedContainer(
                duration: Duration(microseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  // color: isSelected ? Colors.orange.shade50 : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? btnColor2 : color2,
                    width: 1,
                  ),
                  gradient: viewBackgroundGradinet(),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      filters[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.normal,
                        color: isSelected ? btnColor2 : Colors.black54,
                      ),
                    ),
                    if (isSelected) ...[
                      SizedBox(width: 6),
                      Icon(Icons.check, size: 16, color: btnColor2),
                    ],
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (_, _) => SizedBox(width: 10),
          itemCount: filters.length,
        ),
      ),
    );
  }

  // Widget _listOfLeaveRequest(BuildContext context) {
  //   return ListView.separated(
  //     padding: EdgeInsets.only(
  //       left: 24,
  //       right: 24,
  //       top: appTopPadding(context),
  //       bottom: appBottomPadding(context),
  //     ),
  //     addAutomaticKeepAlives: false,
  //     addRepaintBoundaries: true,
  //     cacheExtent: 500,
  //     itemBuilder: (context, index) {
  //       final custModel = sampleCustomers[index];
  //       return RepaintBoundary(
  //         child: GestureDetector(
  //           onTap: () {
  //             Navigator.pushNamed(context, RouteName.employeeDetailPage);
  //           },
  //           child: leaveCard(custModel),
  //         ),
  //       );
  //     },
  //     separatorBuilder: (context, index) => const SizedBox(height: 8),
  //     itemCount: sampleCustomers.length,
  //   );
  // }
}
