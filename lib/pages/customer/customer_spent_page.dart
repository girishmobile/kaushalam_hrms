import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/models/order_model.dart';
import 'package:neeknots_admin/utility/utils.dart';

class CustomerSpentPage extends StatelessWidget {
  const CustomerSpentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: appTopPadding(context),
            ),
            child: Column(
              children: [
                _buildTotalSpent(),
                Expanded(child: _listOfOrders(context)),
              ],
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: appNavigationBar(
              title: "TOTAL SPENT",
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSpent() {
    return appGlassEffect(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              loadSubText(title: "Total Spent", fontWight: FontWeight.w500),
              loadSubText(title: "\$1500.00", fontWight: FontWeight.w500),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              loadSubText(title: "Total Orders", fontWight: FontWeight.w500),
              loadSubText(title: "15", fontWight: FontWeight.w500),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              loadSubText(title: "Payment Method", fontWight: FontWeight.w500),
              loadSubText(title: "Credit Card", fontWight: FontWeight.w500),
            ],
          ),
          loadSubText(title: "Last Order:- 10-Nov-2025", fontSize: 12),
        ],
      ),
    );
  }

  Widget _listOfOrders(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(
        left: 0,
        right: 0,
        top: 16,
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
      itemCount: 15,
    );
  }
}
