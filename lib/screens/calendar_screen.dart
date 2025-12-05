import 'package:flutter/material.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    final safeBottom = MediaQuery.of(context).padding.bottom;
    const topBarHeight = 48.0; // your Dashboard SafeArea Row
    final listTop = safeTop + topBarHeight; // search bar height + spacing
    final listBottom = safeBottom + topBarHeight + 16;
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
            _buildTableCalendar(),
            _builHeader(),
            // ListView.separated(
            //   padding: EdgeInsets.only(bottom: listBottom),
            //   shrinkWrap: true,
            //   itemBuilder: (context, index) {
            //     return appViewEffect(
            //       child: Center(child: Text("comming soon...")),
            //     );
            //   },
            //   separatorBuilder: (_, __) => SizedBox(height: 8),
            //   itemCount: 10,
            // ),
            /// FIX: Do NOT use ListView inside ListView → use Column
            ...List.generate(
              10,
              (index) => Padding(
                padding: const EdgeInsetsGeometry.only(bottom: 8),
                child: _buildItem(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItem() {
    return appViewEffect(
      borderRadius: 4,
      child: Row(
        spacing: 8,
        children: [
          Container(
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
                  title: "Girish Cahuahn",
                  fontSize: 14,
                  fontWight: FontWeight.w600,
                ),
                loadSubText(title: "Type: Leave", fontSize: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color3,
        ),
      ),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
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
      selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
      focusedDay: _focusedDay,
      firstDay: DateTime.utc(2025, 1, 1),
      lastDay: DateTime.utc(2025, 12, 31),
    );
  }

  Widget _builHeader() {
    return Column(
      children: [
        const Divider(height: 20, thickness: 0.5, color: color3),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final double topOffset;
  final Widget child;

  _StickyHeaderDelegate({
    required this.height,
    required this.child,
    required this.topOffset,
  });

  @override
  double get minExtent => height + topOffset;
  @override
  double get maxExtent => height + topOffset;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    double offset = shrinkOffset > topOffset ? topOffset : shrinkOffset;

    return Transform.translate(
      offset: Offset(0, -offset), // moves up as you scroll
      child: Column(
        children: [
          SizedBox(height: topOffset), // reserve real top bar space
          child, // sticky content
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(old) => true;
}

/**
 *  CustomScrollView(
          slivers: [
            // 1️⃣ Real space for Top Bar (fixes overlapping)
            SliverPadding(
              padding: EdgeInsets.only(left: 16, right: 16),
              sliver: SliverToBoxAdapter(child: _buildTableCalendar()),
            ),
            //Stikcy row
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverPersistentHeader(
                pinned: true,
                delegate: _StickyHeaderDelegate(
                  child: _builHeader(),
                  topOffset: listTop,
                  height: 60,
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: listBottom),
              sliver: SliverList.separated(
                itemBuilder: (context, index) {
                  return appViewEffect(
                    borderRadius: 4,
                    child: Center(child: Text("Comming soon...")),
                  );
                },
                separatorBuilder: (_, __) => SizedBox(height: 8),
                itemCount: 80,
              ),
            ),

            // Scrollable List
          ],
        ),
  
 */
