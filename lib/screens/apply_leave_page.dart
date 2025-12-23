import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/string_constant.dart';
import 'package:neeknots_admin/provider/leave_provider.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class ApplyLeavePage extends StatefulWidget {
  const ApplyLeavePage({super.key});

  @override
  State<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

final halfDayTypes = ["First Half", "Second Half"];

class _ApplyLeavePageState extends State<ApplyLeavePage> {
  DateTime? fromDate;
  DateTime? toDate;
  String? employeeId;
  LeaveDropdownItem? selectedLeaveType;

  //half day
  bool isHalfDay = false;
  String? halfDayType;
  double totalDays = 0.0;
  final reasonController = TextEditingController();
  //for leave type
  List<LeaveDropdownItem> dropListItem = [];
  @override
  void initState() {
    super.initState();

    initEmp();
  }

  Future<void> initEmp() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<LeaveProvider>(context, listen: false);
      await Future.wait([
        provider.loadUserdataFromstorage().then((value) {
          Map<String, dynamic> body = {"emp_id": provider.employeeId};
          provider.getLeaveTypes(body: body).then((value) {
            dropListItem = provider.getLeaveTypeDropdownItems();
          });
        }),
      ]);
      employeeId = provider.employeeId;
    });
  }

  String formatDate(DateTime? date) {
    if (date == null) return "dd/mm/yyyy";
    return "${date.day}-${date.month}-${date.year}";
  }

  void calculateDays() {
    if (fromDate == null || toDate == null) {
      totalDays = 0;
      return;
    }

    // 🔥 Validation
    if (isHalfDay && fromDate != toDate) {
      isHalfDay = false; // auto turn OFF
      totalDays = (toDate!.difference(fromDate!).inDays + 1).toDouble();

      // Show message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Half day is allowed only for the same date")),
      );
      return;
    }

    // 🔥 Normal days
    if (!isHalfDay) {
      totalDays = (toDate!.difference(fromDate!).inDays + 1).toDouble();
    }

    // 🔥 Half-day
    if (isHalfDay && fromDate == toDate) {
      totalDays = 0.5;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appTitle: "LEAVE REQUEST",
      child: Consumer<LeaveProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              ListView(
                padding: EdgeInsets.only(left: 24, right: 24, top: 0),
                children: [
                  // FROM DATE
                  loadSubText(title: "From", fontWight: FontWeight.w600),
                  SizedBox(height: 8),
                  appViewEffect(
                    onTap: () async {
                      final picked = await appDatePicker(
                        context,
                        minDate: DateTime.now(),
                      );
                      if (picked != null) {
                        if (isWeekend(picked)) {
                          if (!context.mounted) return;
                          showSnackBar(
                            context,
                            message: "Weekend is not allowed for leave",
                            bgColor: Colors.redAccent,
                          );
                          return;
                        }
                        if (isHoliday(picked)) {
                          if (!context.mounted) return;
                          showSnackBar(
                            context,
                            message: "Holiday is not allowed for leave",
                            bgColor: Colors.redAccent,
                          );
                          return;
                        }

                        setState(() {
                          fromDate = picked;
                          resetLeave();
                        });
                        calculateDays();
                      }
                    },
                    child: Row(
                      children: [
                        Expanded(child: Text(formatDate(fromDate))),
                        Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // TO DATE
                  loadSubText(title: "To", fontWight: FontWeight.w600),
                  SizedBox(height: 8),
                  appViewEffect(
                    onTap: () async {
                      if (fromDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please select From Date first"),
                          ),
                        );
                        return;
                      }
                      final picked = await appDatePicker(
                        context,
                        minDate: fromDate ?? DateTime.now(),
                      );
                      if (picked != null) {
                        if (isWeekend(picked)) {
                          if (!context.mounted) return;
                          showSnackBar(
                            context,
                            message: "Weekend is not allowed for leave",
                            bgColor: Colors.redAccent,
                          );
                          return;
                        }
                        if (isHoliday(picked)) {
                          if (!context.mounted) return;
                          showSnackBar(
                            context,
                            message: "Holiday is not allowed for leave",
                            bgColor: Colors.redAccent,
                          );
                          return;
                        }
                        setState(() {
                          toDate = picked;
                          resetLeave();
                        });
                        calculateDays();
                      }
                    },
                    child: Row(
                      children: [
                        Expanded(child: Text(formatDate(toDate))),
                        Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),
                  loadSubText(title: "Days", fontWight: FontWeight.w600),
                  SizedBox(height: 8),
                  appViewEffect(
                    child: Row(
                      children: [
                        Expanded(child: Text("$totalDays Days")),
                        Icon(Icons.pending_actions, color: Colors.black54),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  loadSubText(title: "Leave Type", fontWight: FontWeight.w600),
                  SizedBox(height: 16),
                  appViewEffect(
                    onTap: () async {
                      // final dropListItem = provider.getLeaveTypeDropdownItems();

                      final selected = await appBottomSheet(
                        context,
                        selected: selectedLeaveType,
                        dataType: dropListItem,
                      );
                      if (selected != null) {
                        setState(() => selectedLeaveType = selected);
                      }
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedLeaveType?.label ?? "Select Leave Type",
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.black54),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),
                  loadSubText(title: "Half day", fontWight: FontWeight.w600),
                  SizedBox(height: 8),
                  _buildHaldDay(),
                  SizedBox(height: 16),
                  loadSubText(title: "Reason", fontWight: FontWeight.w600),
                  SizedBox(height: 8),
                  loadMultiLineTextField(textController: reasonController),

                  SizedBox(height: 24),
                  gradientButton(
                    title: "Apply Leave",
                    onPressed: () {
                      validateAndApplyLeave(provider);
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

  Widget _buildHaldDay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Switch(
          value: isHalfDay,
          onChanged: (value) {
            setState(() {
              isHalfDay = value;
              // default value when turned ON
              if (isHalfDay) {
                // Validate immediately
                if (fromDate == null || toDate == null) {
                  isHalfDay = false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please select From & To date first"),
                    ),
                  );
                } else if (fromDate != toDate) {
                  isHalfDay = false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Half day allowed only when dates match"),
                    ),
                  );
                }
              }
              if (isHalfDay) {
                halfDayType = "First Half";
              } else {
                halfDayType = null;
              }
              calculateDays();
            });
          },
        ),

        if (isHalfDay)
          appViewEffect(
            onTap: () async {
              final selected = await appSimpleBottomSheet(
                context,
                selected: halfDayType,
                dataType: halfDayTypes,
              );
              if (selected != null) {
                setState(() => halfDayType = selected);
              }
            },
            child: Row(
              children: [
                Text(halfDayType ?? "First Half"),
                Icon(Icons.arrow_drop_down, color: Colors.black54),
              ],
            ),
          ),
      ],
    );
  }

  void validateAndApplyLeave(LeaveProvider provider) {
    if (fromDate == null) {
      showError("Please select From Date");
      return;
    }

    if (toDate == null) {
      showError("Please select To Date");
      return;
    }

    if (toDate!.isBefore(fromDate!)) {
      showError("To Date must be after From Date");
      return;
    }
    if (selectedLeaveType == null) {
      showError("Please select a leave type");
      return;
    }
    // Half Day Only for Single Day
    if (isHalfDay && fromDate != toDate) {
      showError("Half-day leave can be applied only for one day");
      return;
    }

    if (isHalfDay && halfDayType == null) {
      showError("Please select First Half or Second Half");
      return;
    }

    if (isHalfDay) {
      totalDays = 0.5;
    } else {
      totalDays = toDate!.difference(fromDate!).inDays + 1;
    }
    if (reasonController.text.trim().isEmpty) {
      return showError("Please enter reason for leave");
    }
    // Success
    Map<String, dynamic> body = {
      "leave_id": null,
      "user_id": int.tryParse(employeeId ?? "0"),
      "leave_date": getFormattedDate(
        fromDate ?? DateTime.now(),
        format: "dd-MM-yyyy",
      ),
      "leave_end_date": getFormattedDate(
        toDate ?? DateTime.now(),
        format: "dd-MM-yyyy",
      ),
      "leave_count": totalDays,
      "leave_type": selectedLeaveType?.type.toJson(),
      // ✅ This sends full JSON of selected type
      "half_day": isHalfDay,
      "half_day_type": halfDayType,
      "reason": reasonController.text.trim(),
      // "location ":locationProvider.currentAddress
    };
    leaveRequest(provider, body);
  }

  Future<void> leaveRequest(
    LeaveProvider provider,
    Map<String, dynamic> body,
  ) async {
    await provider.applyLeave(body: body);
    if (!mounted) return; // ✅ use the State's mounted
    if (provider.applySuccess) {
      showSnackBar(
        context,
        message: provider.errorMessage ?? "Leave applied successfully.",
        bgColor: Colors.green,
      );

      Navigator.pop(context, true); // request refresh
    } else {
      showSnackBar(
        context,
        message:
            provider.errorMessage ??
            "Unable to process your leave request. Please try again.",
        bgColor: Colors.redAccent,
      );
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void showSuccess(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));
  }

  void resetLeave() {
    // reset leave type when date changes
    selectedLeaveType = null;

    // when user change FROM date, re-check half day rule
    if (isHalfDay && fromDate != toDate) {
      isHalfDay = false;
    }
  }
}
