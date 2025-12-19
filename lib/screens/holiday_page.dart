import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
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
      appTitle: "HOLIDAY LIST",
      child: Consumer<EmpProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              ListView.separated(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 0,
                  bottom: appBottomPadding(context),
                ),
                itemBuilder: (context, index) {
                  final holiday = provider.holidays[index];
                  return holidayCard(item: holiday);
                },
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemCount: provider.holidays.length,
              ),

              provider.isLoading ? showProgressIndicator() : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }


}
