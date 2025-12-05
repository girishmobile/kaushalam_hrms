import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:neeknots_admin/utility/utils.dart';

class AllLeavePage extends StatefulWidget {
  const AllLeavePage({super.key});

  @override
  State<AllLeavePage> createState() => _AllLeavePageState();
}

class _AllLeavePageState extends State<AllLeavePage> {
  int selectedIndex = 0;

  final List<String> filters = [
    "All",
    "Casual Leave",
    "Sick Leave",
    "Paid Leave",
  ];
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: listTop(context),
              bottom: appBottomPadding(context),
            ),
            children: [Text("comming soon...")],
          ),
          Positioned(
            top: appTopPadding(context),
            left: 24,
            right: 24,
            child: _filterOption(),
          ),
          appNavigationBar(
            title: "ALL LEAVES",
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _filterOption() {
    return SizedBox(
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
    );
  }
}
