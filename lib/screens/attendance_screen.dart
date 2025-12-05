import 'package:flutter/material.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/utility/utils.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [_kpiGridView(context), topBar(context)]);
  }

  Widget topBar(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    const topBarHeight = 48.0; // your Dashboard SafeArea Row
    final listTop = safeTop + topBarHeight + 16; // search bar height + spacing
    return Container(
      padding: EdgeInsets.only(top: listTop),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Attendance",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          appViewEffect(
            padding: EdgeInsets.all(8),
            borderRadius: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Year 2025",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                Icon(Icons.arrow_drop_down, size: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kpiGridView(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: listTop(context),
        bottom: listBottom(context),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(onTap: () {}, child: _buildGridItem());
      },
      itemCount: 12,
    );
  }

  Widget _buildGridItem() {
    return appViewEffect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          // Flexible details section
          appCircleIcon(
            icon: Icons.workspaces_outlined,
            gradient: appGradient(),
            iconSize: 36,
          ),
          Text(
            "January",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),

          Text(
            "50%",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
