import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/order_card.dart';
import 'package:neeknots_admin/common/sales_bar_chart.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/string_constant.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/models/order_model.dart';
import 'package:neeknots_admin/utility/utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    const topBarHeight = 48.0; // your Dashboard SafeArea Row
    final listTop = safeTop + topBarHeight + 8; // search bar height + spacing

    return ListView(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: listTop,
        bottom: listBottom(context),
      ),
      children: [
        Text(
          "Summary",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          spacing: 16,
          children: [
            Expanded(
              child: _dashboardItem(
                onTap: () =>
                    Navigator.pushNamed(context, RouteName.todaySalesPage),
                icon: Icons.trending_up_rounded,
                title: "Today Sales",
                subTitle: "+10% income",
                value: "989",
              ),
            ),
            Expanded(
              child: _dashboardItem(
                onTap: () =>
                    Navigator.pushNamed(context, RouteName.allProductPage),
                icon: Icons.production_quantity_limits_rounded,
                title: "Total Product",
                subTitle: "+8% New product",
                value: "1020",
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          spacing: 16,
          children: [
            Expanded(
              child: _dashboardItem(
                onTap: () =>
                    Navigator.pushNamed(context, RouteName.allOrderPage),
                icon: Icons.shopping_bag_outlined,
                title: "Total Order",
                subTitle: "+10% income",
                value: "989",
              ),
            ),
            Expanded(
              child: _dashboardItem(
                icon: Icons.people_outline_rounded,
                title: "Total Customer",
                subTitle: "+10% income",
                value: "989",
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        appGlassEffect(
          child: Container(
            width: double.infinity,
            height: 250,
            alignment: Alignment.center,
            child: SalesBarChart(),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Trending Products",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        _topTenProduct(),
        const SizedBox(height: 16),
        Text(
          "Last 10 Orders",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        _topTenOrders(),
      ],
    );
  }

  Widget _dashboardItem({
    required IconData icon,
    required String title,
    required String subTitle,
    required String value,
    VoidCallback? onTap,
  }) {
    return appGlassEffect(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          //  Icon(icon, size: 36, color: Colors.black54),
          appCircleIcon(icon: icon, iconSize: 36, gradient: appGradient()),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Colors.black54,
            ),
          ),

          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _topTenProduct() {
    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, RouteName.productDetailPage),
            child: Container(
              width: 170,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: appGlassEffect(
                padding: const EdgeInsets.only(
                  left: 1,
                  right: 1,
                  bottom: 8,
                  top: 1,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: loadAssetImage(
                        name: productImage,
                        width: 168,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Umbrella Lamp-Large 36 inch",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatPrice(120 + index),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            10 > 0 ? "In Stock: ${10}" : "Out of Stock",
                            style: TextStyle(
                              fontSize: 12,
                              color: 10 > 0 ? Colors.black54 : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _topTenOrders() {
    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sampleOrders.length,
        itemBuilder: (context, index) {
          final order = sampleOrders[index];
          return GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, RouteName.orderDetailPage),
            child: OrderCard(order: order),
          );
        },
      ),
    );
  }
}
