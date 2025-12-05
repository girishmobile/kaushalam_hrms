import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';

class TodaySalePage extends StatelessWidget {
  const TodaySalePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Stack(
        children: [
          ListView(children: [Center(child: Text('Today Sale Page'))]),
          appNavigationBar(
            title: "TODAY SALES",
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
