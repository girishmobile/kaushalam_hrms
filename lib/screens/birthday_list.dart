import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/provider/emp_provider.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class BirthdayList extends StatelessWidget {
  const BirthdayList({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmpProvider>().getUpcomingBirthHodliday();
    });
    return AppScaffold(
      appTitle: "BIRTHDAY LIST",
      child: Consumer<EmpProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              _listOfEmployee(context, provider),
              // Positioned(
              //   top: appTopPadding(context),
              //   left: 24,
              //   right: 24,
              //   child: _searchBar(context),
              // ),
              /*appNavigationBar(
                title: "BIRTHDAY LIST",
                onTap: () {
                  Navigator.pop(context);
                },
              ),*/
              provider.isLoading ? showProgressIndicator() : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  Widget _listOfEmployee(BuildContext context, EmpProvider provider) {
    return ListView.separated(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 0,
        bottom: listBottom(context),
      ),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      cacheExtent: 500,
      itemBuilder: (context, index) {
        final birthday = provider.birthdays[index];

        return RepaintBoundary(
          child: GestureDetector(
            onTap: () {
              //Navigator.pushNamed(context, RouteName.employeeDetailPage);
            },
            child: birthDayCard(item: birthday),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemCount: provider.birthdays.length,
    );
  }


}
