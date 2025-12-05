import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/string_constant.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/provider/login_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    final auth = Provider.of<LoginProvider>(context, listen: false);

    // await SecureStorage.deleteAll();

    await auth.checkLoginStatus();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      if (auth.loginSuccess) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.dashboardScreen,
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.loginPage,
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Center(child: loadAssetImage(name: applogo, height: 124)),
    );
  }
}
