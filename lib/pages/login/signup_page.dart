import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/router/route_name.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    const topBarHeight = 48.0; // your Dashboard SafeArea Row
    final listTop = safeTop + topBarHeight + 8; // search bar height + spacing
    return AppScaffold(
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: listTop,
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            children: [
              //loadAssetImage(name: applogo, height: 64),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: appGradientText(
                  text: "CREATE ACCOUNT",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  gradient: appGradient(),
                ),
              ),
              const SizedBox(height: 16),
              appOrangeTextField(
                hintText: "Username",
                //   icon: commonPrefixIcon(image: icPassword),
              ),
              const SizedBox(height: 16),
              appOrangeTextField(
                hintText: "Employee ID or Email",
                // icon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              appOrangeTextField(
                hintText: "Mobile Number",
                //  icon: Icons.phone_iphone_outlined,
              ),
              const SizedBox(height: 16),
              appOrangeTextField(
                hintText: "Password",
                //icon: Icons.lock_outline,
              ),
              const SizedBox(height: 16),

              appOrangeTextField(
                hintText: "Confirm Password",
                // icon: Icons.lock_outline,
              ),
              const SizedBox(height: 32),
              // SignUp Button
              gradientButton(title: "SIGN UP", onPressed: () {}),
            ],
          ),
          appNavigationBar(
            title: "SIGN UP",
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
