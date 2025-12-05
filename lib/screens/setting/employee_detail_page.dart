import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/string_constant.dart';
import 'package:neeknots_admin/utility/utils.dart';

class EmployeeDetailPage extends StatelessWidget {
  const EmployeeDetailPage({super.key});

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
            ),
            children: [
              appProfileImage(
                  isEdit: false,
                  context: context,
                  imageUrl: hostImage, radius: 60),
              SizedBox(height: 16),
              loadTitleText(title: "John Smith", textAlign: TextAlign.center),
              loadSubText(
                title: "iOS developer",
                textAlign: TextAlign.center,
                fontSize: 12,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  loadSubText(
                    title: "Joined: 13-June-2013",
                    textAlign: TextAlign.center,
                    fontSize: 12,
                  ),
                  SizedBox(height: 4),
                  loadSubText(
                    title: "Status: Active",
                    textAlign: TextAlign.center,
                    fontSize: 12,
                  ),
                ],
              ),
            ],
          ),
          appNavigationBar(
            title: "Employee Details",
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
