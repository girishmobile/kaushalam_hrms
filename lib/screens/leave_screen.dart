import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:neeknots_admin/utility/utils.dart';

class LeaveScreen extends StatelessWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _listOfLeaves(context),
        _buildFilter(context),
        _leaveRequest(context),
      ],
    );
  }

  Widget _listOfLeaves(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: listTop(context),
        bottom: listBottom(context, extra: 48),
      ),
      children: [
        SizedBox(
          height: 90,
          child: appViewEffect(child: Text("Leave requested...")),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 90,
          child: appViewEffect(child: Text("Leave requested...")),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 90,
          child: appViewEffect(child: Text("Leave requested...")),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 90,
          child: appViewEffect(child: Text("Leave requested...")),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 90,
          child: appViewEffect(child: Text("Leave requested...")),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 90,
          child: appViewEffect(child: Text("Leave requested...")),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 90,
          child: appViewEffect(child: Text("Leave requested...")),
        ),
        //SizedBox(height: 48),
      ],
    );
  }

  Widget _leaveRequest(BuildContext context) {
    final safeBottom = MediaQuery.of(context).padding.bottom;
    const bottomBarHeight = 70.0; // your Dashboard bottom bar height

    return Positioned.fill(
      // bottom: safeBottom + bottomBarHeight + 8,
      //left: 48,
      //right: 48,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: safeBottom + bottomBarHeight + 4),
          child: Container(
            //margin: const EdgeInsets.symmetric(horizontal: 24),
            height: 48,
            decoration: BoxDecoration(
              gradient: appGradient(colors: [btnColor1, btnColor2]),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextButton.icon(
              onPressed: () {},

              label: const Text(
                "Apply Leave",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    final topBarHeight = 48.0; // from Dashboard SafeArea Row
    return Positioned(
      top: safeTop + topBarHeight + 8,
      left: 24,
      right: 24,
      child: appOrangeTextField(hintText: "search", icon: Icon(Icons.search)),
    );
  }

  Widget _buildFilter(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    final topBarHeight = 48.0; // from Dashboard SafeArea Row
    return Positioned(
      top: safeTop + topBarHeight + 8,
      left: 24,
      right: 24,
      child: Row(
        spacing: 16,
        children: [
          Expanded(
            child: appViewEffect(
              child: Text(
                "Duration All",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Expanded(
            child: appViewEffect(
              child: Text(
                "Status All",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassEffect({
    required Widget child,
    double borderRadius = 8,
    EdgeInsetsGeometry? padding,
    double blurSigma = 10,
    Color overlayColor = Colors.white,
    double opacity = 0.15,
    Color borderColor = Colors.white,
    double borderWidth = 1.0,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: overlayColor.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor.withValues(alpha: 0.4),
              width: borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
