import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/string_constant.dart';
import 'package:neeknots_admin/utility/utils.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
              appProfileImage(imageUrl: hostImage, radius: 60),
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

  // Widget _buildProfileImage() {
  //   return Container(
  //     padding: const EdgeInsets.all(4), // thickness of border
  //     decoration: BoxDecoration(
  //       shape: BoxShape.circle,
  //       gradient: appGradient(),
  //     ),
  //     child: Container(
  //       height: 120,
  //       width: 120,
  //       decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
  //       child: appCircleImage(imageUrl: hostImage, radius: 58, onTap: () {}),
  //     ),
  //   );
  // }
}
