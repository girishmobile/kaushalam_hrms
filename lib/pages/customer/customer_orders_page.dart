import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/string_constant.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/models/order_model.dart';
import 'package:neeknots_admin/utility/utils.dart';

class CustomerOrdersPage extends StatelessWidget {
  const CustomerOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Stack(
        children: [
          _listOfOrders(context),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: customerInformation(context),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: appNavigationBar(
              title: "CUSTOMER ORDERS",
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget customerInformation(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: appTopPadding(context),
      ),
      child: Container(
        color: Colors.white.withValues(alpha: 0.1),
        child: Row(
          spacing: 16,
          children: [
            appProfileImage(
              isEdit: false,
              context: context,
              imageUrl: hostImage,
              radius: 28,
              padding: EdgeInsets.all(0),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                loadTitleText(title: "John Smith"),
                loadSubText(title: "johnsmith@gmail.com"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _listOfOrders(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: appTopPadding(context, extra: 56 + 16),
        bottom: listBottom(context),
      ),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      cacheExtent: 500,
      itemBuilder: (context, index) {
        final order = sampleOrders[index % sampleOrders.length];
        return RepaintBoundary(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RouteName.orderDetailPage);
            },
            child: orderCard(order),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemCount: 40,
    );
  }
}
