import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/utility/utils.dart';

class MyHoursPage extends StatelessWidget {
  const MyHoursPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: appTopPadding(context),
              bottom: appBottomPadding(context),
            ),
            children: [Text("Comming soon...")],
          ),
          appNavigationBar(
            title: "MY HOURS",
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
