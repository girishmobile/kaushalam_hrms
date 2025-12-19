import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/string_constant.dart';
import 'package:neeknots_admin/utility/utils.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
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
                text: "Shophia",
                isEdit: true,
                context: context,
                imageUrl: hostImage,
                radius: 60,
              ),
              SizedBox(height: 16),
              loadTitleText(title: "Shophia Lee", textAlign: TextAlign.center),
              loadSubText(title: "Execiutive", textAlign: TextAlign.center),
            ],
          ),
          appNavigationBar(
            title: "PROFILE",
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

}
