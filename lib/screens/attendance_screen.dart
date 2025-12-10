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
            //topBar(context, provider),
            ListView(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: listTop(context, extra: 76),
                bottom: listBottom(context),
              ),
              children: [
                loadTitleText(title: '${provider.selectedDateRange} Details'),
                SizedBox(height: 4),
                _buildDetailListView(provider),
              ],
            ),
            _headerView(context, provider),
            Positioned(
              top: appTopPadding(context, extra: 64),
              left: 24,
              right: 24,
              child: _filterOption(provider),
            ),
            provider.isLoading ? showProgressIndicator() : SizedBox.shrink(),
          ],
        );
      },
    );
  }

  Widget _buildDetailListView(AttendanceProvider provider) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var data = provider.attendanceRecordModel?.data?.data?[index];
        return appViewEffect(
          margin: EdgeInsets.symmetric(vertical: 3),
          child: Column(
            spacing: 5,
            children: [
              _commonItemView(
                value: formatDate(
                  data?.date?.date.toString() ?? '',
                  format: "dd-MM-yyyy",
                ),
              ),
              _commonItemView(
                title: "Entry Time",
                value: data?.entryTime ?? '',
              ),
              _commonItemView(title: "Exit time", value: data?.exitTime ?? ''),
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
        );
      },

      separatorBuilder: (_, _) => SizedBox(height: 8),
      itemCount: provider.attendanceRecordModel?.data?.data?.length ?? 0,
    );
  }

  Widget _headerView(BuildContext context, AttendanceProvider provider) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: appTopPadding(context, extra: 8),
      ),
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
    return SizedBox(
      height: 64,

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
            fontSize: 12,
            fontWight: FontWeight.w600,
            fontColor: item['color'],
          ),
        ],
      ),
    );
  }

  Widget topBar(BuildContext context, AttendanceProvider provider) {
    final safeTop = MediaQuery.of(context).padding.top;
    const topBarHeight = 48.0; // your Dashboard SafeArea Row
    final listTop = safeTop + topBarHeight + 16; // search bar height + spacing
    return Container(
      padding: EdgeInsets.only(top: listTop),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView(
        children: [
          SizedBox(height: 10),
          _kpiGridView(context, provider),
          SizedBox(height: 10),
          loadTitleText(title: '${provider.selectedDateRange} Details'),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: provider.attendanceRecordModel?.data?.data?.length ?? 0,
            itemBuilder: (context, index) {
              var data = provider.attendanceRecordModel?.data?.data?[index];
              return appViewEffect(
                margin: EdgeInsets.symmetric(vertical: 3),
                child: Column(
                  spacing: 5,
                  children: [
                    _commonItemView(
                      value: formatDate(
                        data?.date?.date.toString() ?? '',
                        format: "dd-MM-yyyy",
                      ),
                    ),
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
              );
            },
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

  Widget _kpiGridView(BuildContext context, AttendanceProvider provider) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        shrinkWrap: true,
        // /physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,

        /* gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.3,
        ),*/
        itemBuilder: (context, index) {
          final item = provider.attendanceGridItems[index];
          return GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
              width: MediaQuery.sizeOf(context).width * 0.4,
              child: _buildGridItem(item: item),
            ),
          );
        },
        itemCount: provider.attendanceGridItems.length,
      ),
    );
  }

  Widget _buildGridItem({required Map<String, dynamic> item}) {
    return appViewEffect(
      //borderColor: item['color'],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 5,
        children: [
          /* appCircleIcon(
            icon: item["icon"],
            gradient: appGradient(),
            iconSize: 24,
          ),*/
          // Flexible details section
          Text(
            "${item["title"]}",
            textAlign: TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),

          Row(
            children: [
              Text(
                "${item["value"]}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: item['color'],
                  //  color: Colors.white,
                ),
              ),
              Text(
                "${item["desc"]}",
                maxLines: 2,

                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: item['color'],
                  //  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
