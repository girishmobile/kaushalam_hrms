import 'package:flutter/material.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:neeknots_admin/core/constants/string_constant.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final bool isTopSafeArea;
  final bool isBottomSafeArea;

  const AppScaffold({
    super.key,
    required this.child,
    this.isTopSafeArea = false,
    this.isBottomSafeArea = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [color1, color2, color3],
              // ),
              //gradient: appOrangeGradient(),
              color: Colors.white,
            ),
          ),
          // Container(
          //   color: Colors.black.withValues(alpha: 0.05), // light overlay
          // ),
          SafeArea(top: isTopSafeArea, bottom: isBottomSafeArea, child: child),
        ],
      ),
    );
  }
}
