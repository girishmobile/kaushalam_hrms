import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:neeknots_admin/provider/app_provider.dart';
import 'package:neeknots_admin/provider/emp_provider.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class HolidayPage extends StatelessWidget {
  const HolidayPage({super.key});

  @override
  Widget build(BuildContext context) {
    /// Fetch API only once when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmpProvider>().getAllHolidays();
    });

    return AppScaffold(
      child: Consumer<EmpProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              ListView.separated(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: appTopPadding(context),
                  bottom: appBottomPadding(context),
                ),
                itemBuilder: (context, index) {
                  final holiday = provider.holidays[index];
                  return holidayCard(item: holiday);
                },
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemCount: provider.holidays.length,
              ),
              appNavigationBar(
                title: "HOLIDAY LIST",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              provider.isLoading ? showProgressIndicator() : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  Widget _holidayItem() {
    return appViewEffect(
      padding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 8),
      child: Row(
        spacing: 16,
        children: [
          Container(
            color: btnColor2.withValues(alpha: 0.1),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              children: [
                loadTitleText(title: "25"),
                loadTitleText(title: "Thus", fontSize: 14),
                loadSubText(title: "Dec"),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                loadTitleText(title: "Cristmas", fontSize: 14),
                loadTitleText(title: "25-Dec-2025", fontSize: 12),
                loadSubText(title: "Thusday"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
