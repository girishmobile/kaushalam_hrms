import 'package:flutter/material.dart';
import 'package:neeknots_admin/components/components.dart'
    hide getFormattedDate;
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:neeknots_admin/utility/utils.dart' hide getFormattedDate;
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../core/router/route_name.dart';
import '../models/user_model.dart';
import '../provider/calendar_provider.dart';
import '../utility/secure_storage.dart';
import '../utility/utils.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  Future<void> init() async {
    final provider = Provider.of<CalendarProvider>(context, listen: false);

    provider.getCalenderList(_selectedDay);
    setState(() {}); // 🔥 Force rebuild once data is ready
  }

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    final safeBottom = MediaQuery.of(context).padding.bottom;
    const topBarHeight = 48.0; // your Dashboard SafeArea Row
    final listTop = safeTop + topBarHeight; // search bar height + spacing
    final listBottom = safeBottom + topBarHeight + 16;
    return Consumer<CalendarProvider>(
      builder: (context, provider, child) {
        final selectedEvents = provider.getEventsForDay(_selectedDay);

        return Stack(
          children: [
            ListView(
              padding: EdgeInsetsGeometry.only(
                left: 16,
                right: 16,
                top: 0,
                bottom: listBottom,
              ),

              children: [
                _buildTableCalendar(provider: provider),
                _buildHeader(),

                ListView.builder(
                  shrinkWrap: true,
                  itemCount: selectedEvents.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final event = selectedEvents[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: _buildItem(provider: provider, event: event),
                    );
                  },
                ),
              ],
            ),
            provider.isLoading ? showProgressIndicator() : SizedBox.shrink(),
          ],
        );
      },
    );
  }

  Widget _builBasicRowInfo({
    required String label,
    required String titleText,
    Color? colorText,
  }) {
    return appViewEffect(
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          loadTitleText(title: label, fontWight: FontWeight.w500, fontSize: 12),
          Expanded(
            child: loadSubText(
              title: titleText,
              fontColor: colorText,
              textAlign: TextAlign.end,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required CalendarProvider provider,
    required Map<String, dynamic> event,
  }) {
    return InkWell(
      onTap: () async {
        if (event['type'] == "birthday") {
          UserModel? user = await SecureStorage.getUser();

          if (user?.role['name'].toString().toLowerCase() == "hr" ||
              user?.role['name'].toString().toLowerCase() == "super admin") {
            Navigator.pushNamed(
              context,
              RouteName.employeeDetailPage,
              arguments: "${event['id']}",
            );
          }
        }
        if (event['type'] == "leave") {
          UserModel? user = await SecureStorage.getUser();

          if (user?.role['name'].toString().toLowerCase() == "hr" ||
              user?.role['name'].toString().toLowerCase() == "super admin") {
            showCommonBottomSheet(
              context: context,
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: appGradientText(
                            text: "Leave Details",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            gradient: appGradient(),
                          ),
                        ),
                        appCircleIcon(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          icon: Icons.close,
                          gradient: appGradient(),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    _builBasicRowInfo(
                      label: "Leave Type : ",
                      titleText: event['leave_type'].toString().toUpperCase(),
                    ),
                    _builBasicRowInfo(
                      label: "Date : ",
                      titleText: formatDate(event['date']),
                    ),
                    _builBasicRowInfo(
                      label: "Days : ",
                      titleText: event['leave_count'].toString().toUpperCase(),
                    ),
                    _builBasicRowInfo(
                      label: "Half Day : ",
                      titleText: event['leave_type'].toString().toUpperCase(),
                    ),
                    _builBasicRowInfo(
                      label: "Reason : ",
                      titleText: event['reason'].toString().toUpperCase(),
                    ),
                    _builBasicRowInfo(
                      colorText:
                          event['status'].toString().toLowerCase() == "accept"
                          ? Colors.green
                          : Colors.red,
                      label: "Status By HR : ",
                      titleText: event['status'].toString().toUpperCase(),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
      child: appViewEffect(
        borderRadius: 4,
        child: Row(
          spacing: 8,
          children: [
            event['type'] == "birthday"
                ? appCircleImage(
                    borderColor: color3,
                    iconColor: color3,
                    imageUrl: setImagePath(event['profile']),
                    radius: 18,
                    icon: Icons.cake_outlined,
                  )
                : Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: event['type'] == "attendance"
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.redAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      event['type'] == "attendance"
                          ? Icons.access_time
                          : Icons.pending_actions,
                      color: event['type'] == "attendance"
                          ? Colors.green
                          : Colors.redAccent,
                    ),
                  ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  loadTitleText(
                    title: event['title'].toString(),
                    fontSize: 14,
                    fontWight: FontWeight.w600,
                  ),
                  loadSubText(
                    title: "Type: ${event['type'].toString().toUpperCase()}",
                    fontSize: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCalendar({required CalendarProvider provider}) {
    final DateTime firstDay = DateTime(2000, 1, 1);

    final DateTime lastDay = DateTime(DateTime.now().year, 12, 31);
    return TableCalendar(
      calendarFormat: provider.calendarFormat,
      // calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        leftChevronIcon: Icon(Icons.chevron_left, color: color3),
        rightChevronIcon:
            _focusedDay.year == lastDay.year &&
                _focusedDay.month == lastDay.month
            ? SizedBox()
            : Icon(Icons.chevron_right, color: color3),
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color3,
        ),
      ),

      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
        provider.getCalenderList(focusedDay); // 🔥 fetch new month
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },

      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final events = provider.getEventsForDay(day);
          if (events.isEmpty) return null;

          Map<String, dynamic>? attn;
          bool hasLeave = false;
          bool hasBirthday = false;

          for (var e in events) {
            if (e["type"] == "attendance") attn = e;
            if (e["type"] == "leave") hasLeave = true;
            if (e["type"] == "birthday") hasBirthday = true;
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              loadSubText(
                title: '${day.day}',
                fontSize: 12,
                fontColor: Colors.black,
              ),

              const SizedBox(height: 4),

              /// 🟢 Attendance hours text
              if (attn != null)
                Container(
                  decoration: commonBoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: loadSubText(
                    title: '${attn["hours"]}h ${attn["minutes"]}m',
                    fontSize: 8,
                    fontColor: Colors.black,
                    fontWight: FontWeight.w400,
                  ),
                ),

              const SizedBox(height: 2),

              /// 🔴 Leave + 🟣 Birthday dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (hasLeave) _dot(Colors.red),
                  if (hasBirthday) _dot(Colors.blue),
                  if (attn != null) _dot(Colors.green),
                ],
              ),
            ],
          );
        },
      ),

      calendarStyle: CalendarStyle(
        markersMaxCount: 0, // ❌ disable default black markers
        selectedDecoration: BoxDecoration(
          color: btnColor2,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: btnColor2.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        weekendTextStyle: TextStyle(color: Colors.redAccent),
      ),
      eventLoader: provider.getEventsForDay,
      selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
      focusedDay: _focusedDay,
      firstDay: firstDay,
      lastDay: lastDay,
    );
  }

  Widget _dot(Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Divider(height: 20, thickness: 0.5, color: color3),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            rowItem(color: Colors.red, label: 'Leave', onTaped: () {}),
            rowItem(color: Colors.green, label: 'Attendance', onTaped: () {}),
            rowItem(color: Colors.blue, label: 'Birthday', onTaped: () {}),
          ],
        ),
        const Divider(height: 20, thickness: 0.5, color: color3),
      ],
    );
  }

  Widget rowItem({
    required Color color,
    required String label,
    VoidCallback? onTaped,
  }) {
    return Material(
      child: InkWell(
        onTap: onTaped,
        child: Row(
          spacing: 8,
          children: [
            Container(
              width: 12,
              height: 12,

              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),

            loadSubText(title: label, fontSize: 12),
          ],
        ),
      ),
    );
  }
}
