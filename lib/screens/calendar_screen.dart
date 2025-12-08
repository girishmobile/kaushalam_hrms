import 'package:flutter/material.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../api/api_config.dart';
import '../core/router/route_name.dart';
import '../provider/calendar_provider.dart';

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
                top: listTop,
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

  Widget _buildItem({
    required CalendarProvider provider,
    required Map<String, dynamic> event,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.profileScreen,
          arguments: {"employeeId": '${event['id']}', "isCurrentUser": false},
          //arguments: provider.employeeId,
        );
      },
      child: appViewEffect(
        borderRadius: 4,
        child: Row(
          spacing: 8,
          children: [
            event['type'] == "Birthday"
                ? appCircleImage(
                    borderColor: color3,
                    iconColor: color3,
                    imageUrl: "${ApiConfig.imageBaseUrl}${event['profile']}",
                    radius: 18,
                  )
                : Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(Icons.pending_actions, color: Colors.redAccent),
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
        markerBuilder: (context, date, events) {
          if (events.isEmpty) return const SizedBox();

          final firstEvent = events.first;
          if (firstEvent is! Map<String, dynamic>) {
            return const SizedBox();
          }

          final type = firstEvent['type']?.toString() ?? '';

          Color color;
          if (type == 'leave') {
            color = Colors.red;
          } else if (type == 'attendance') {
            color = Colors.green;
          } else {
            color = Colors.blue;
          }

          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          );
        },
      ),
      calendarStyle: CalendarStyle(
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

  Widget _buildHeader() {
    return Column(
      children: [
        const Divider(height: 20, thickness: 0.5, color: color3),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            rowItem(color: Colors.red, label: 'Leave', onTaped: () {}),
            //rowItem(color: Colors.green, label: 'Attendance', onTaped: () {}),
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
