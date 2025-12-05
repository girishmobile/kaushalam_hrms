import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/string_constant.dart';
import 'package:neeknots_admin/utility/utils.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

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
            children: [
              loadAssetImage(name: applogo, height: 128),
              const SizedBox(height: 32),
              loadSubText(title: "Current Password"),
              SizedBox(height: 8),
              appOrangeTextField(
                hintText: "Enter your current pasword",
                icon: Icons.lock_outline,
              ),
              const SizedBox(height: 16),
              loadSubText(title: "New Password"),
              SizedBox(height: 8),
              appOrangeTextField(
                hintText: "Enter your new pasword",
                icon: Icons.lock_outline,
              ),
              const SizedBox(height: 16),
              loadSubText(title: "Confirm Password"),
              SizedBox(height: 8),
              appOrangeTextField(
                hintText: "Enter your confirm pasword",
                icon: Icons.lock_outline,
              ),
              const SizedBox(height: 32),

              // Login Button
              gradientButton(title: "UPDATE", onPressed: () {}),
            ],
          ),
          appNavigationBar(
            title: "CHANGE PASSWORD",
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
