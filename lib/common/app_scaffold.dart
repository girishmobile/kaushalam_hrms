import 'package:flutter/material.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:neeknots_admin/core/constants/string_constant.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final Widget? leading;
  final String? appTitle;
  final bool isTopSafeArea;
  final bool isBottomSafeArea;
  final double? leadingWidth;
  final  PreferredSizeWidget? appBar;
  final  List<Widget>? actions;
  const AppScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.appTitle,
    this.leadingWidth,
    this.leading,
    this.actions,
    this.isTopSafeArea = false,
    this.isBottomSafeArea = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: appBar??AppBar(
        actions: actions,
        leadingWidth: leadingWidth, // 👈 important
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: appGradientText(
          text:appTitle?.toUpperCase()?? "Hotline".toUpperCase(),
          //textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          gradient: appGradient(),
        ),
        leading: leading??appCircleIcon(
          onTap: (){
            Navigator.pop(context);
          },
          iconSize: 24,
          icon: Icons.arrow_back_rounded,gradient: appGradient(),),

        backgroundColor: Colors.white70,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [color1, color2, color3],
              // ),
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
