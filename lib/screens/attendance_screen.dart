import 'package:flutter/material.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/provider/attendance_provider.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceProvider>().initializeTodayAttendance();
    });
    return Consumer<AttendanceProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            Column(
              spacing: 10,
              children: [
                _headerView(context, provider),
                _filterOption(provider),
                Expanded(child: _buildDetailListView(context, provider)),
              ],
            ),

            /*Positioned(
              top: appTopPadding(context, extra: 64),
              left: 24,
              right: 24,
              child: _filterOption(provider),
            ),*/
            provider.isLoading ? showProgressIndicator() : SizedBox.shrink(),
          ],
        );
      },
    );
  }

  Widget _buildDetailListView(
    BuildContext context,
    AttendanceProvider provider,
  ) {
    return ListView.separated(
      padding: EdgeInsets.only(
        left: 24.0,
        right: 24,
        bottom: appBottomPadding(context, extra: 64),
      ),
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        var data = provider.attendanceRecordModel?.data?.data?[index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            _commonItemView(
              title: formatDate(
                data?.date?.date.toString() ?? '',
                format: "dd-MMM-yyyy",
              ),
              fontWight: FontWeight.w600,
            ),
            appViewEffect(
              child: Column(
                spacing: 5,
                children: [
                  _commonItemView(
                    title: "Entry Time",
                    value: data?.entryTime ?? '',
                  ),
                  _commonItemView(
                    title: "Exit time",
                    value: data?.exitTime ?? '',
                  ),
                  _commonItemView(
                    title: "Break time",
                    value: data?.breakTime ?? '',
                  ),
                  _workItemView(
                    title: "Working Hours",
                    value:
                        '${data?.staffing?.hours ?? 0} hrs  ${data?.staffing?.minutes ?? 0} mins',
                  ),
                ],
              ),
            ),
          ],
        );
      },

      separatorBuilder: (_, _) => SizedBox(height: 16),
      itemCount: provider.attendanceRecordModel?.data?.data?.length ?? 0,
    );
  }

  Widget _headerView(BuildContext context, AttendanceProvider provider) {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 24, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          appGradientText(
            text: "Attendance",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            gradient: appGradient(),
          ),
          appViewEffect(
            padding: EdgeInsets.only(left: 12, right: 4, top: 6, bottom: 6),
            borderRadius: 8,
            onTap: () async {
              final selected = await appSimpleBottomSheet(
                context,
                selected: provider.selectedDateRange,
                dataType: provider.dateType,
                onClose: () => Navigator.of(context).pop(),
              );
              if (selected != null) {
                provider.handleDateRangeSelection(context, selected);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  provider.selectedDateRange,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.black54, size: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterOption(AttendanceProvider provider) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24),
      height: 68,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = provider.attendanceGridItems[index];
          return _filterGridItem(item: item);
        },
        separatorBuilder: (_, _) => SizedBox(width: 8),
        itemCount: provider.attendanceGridItems.length,
      ),
    );
  }

  Widget _filterGridItem({required Map<String, dynamic> item}) {
    return appViewEffect(
      child: Column(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          loadTitleText(
            title: item['title'],
            fontSize: 12,
            fontWight: FontWeight.w500,
          ),
          loadTitleText(
            title: "${item['value']}${item['desc']}",
            fontSize: 13,
            fontWight: FontWeight.w600,
            fontColor: item['color'],
          ),
        ],
      ),
    );
  }

  Widget _commonItemView({
    String? title,
    String? value,
    FontWeight? fontWight,
    Color? colorText,
  }) {
    return Row(
      children: [
        Expanded(
          child: loadSubText(
            fontColor: colorText,
            title: title ?? "Date",
            fontSize: 12,
            fontWight: fontWight ?? FontWeight.w400,
          ),
        ),
        loadSubText(
          title: value,
          fontColor: colorText ?? Colors.black,
          fontSize: 12,
          fontWight: fontWight ?? FontWeight.w400,
        ),
      ],
    );
  }

  Widget _workItemView({String? title, String? value}) {
    return Row(
      children: [
        Expanded(
          child: appGradientText(
            text: title ?? "-",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            gradient: appGradient(),
          ),
        ),

        appGradientText(
          text: value ?? "-",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          gradient: appGradient(),
        ),
      ],
    );
  }
}
