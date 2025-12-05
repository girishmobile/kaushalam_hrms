import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/string_constant.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/utility/utils.dart';

class CustomerDetailPage extends StatelessWidget {
  const CustomerDetailPage({super.key});

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
              appProfileImage(
                  isEdit: false,
                  context: context,
                  imageUrl: hostImage, radius: 60),
              SizedBox(height: 16),
              loadTitleText(title: "John Smith", textAlign: TextAlign.center),
              loadSubText(
                title: "Johnsmith@gmail.com",
                textAlign: TextAlign.center,
                fontSize: 12,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  loadSubText(
                    title: "Joined: 25-oct-2024",
                    textAlign: TextAlign.center,
                    fontSize: 12,
                  ),
                  SizedBox(height: 4),
                  loadSubText(
                    title: "Status: Active",
                    textAlign: TextAlign.center,
                    fontSize: 12,
                  ),
                ],
              ),
              SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: loadSubText(
                  title: "Last Order 10-oct-2024",
                  fontSize: 10,
                ),
              ),
              SizedBox(height: 16),
              _buildRowItem(
                context,
                title: "Orders 15",
                icon: Icons.shopping_bag_outlined,
                onTap: () =>
                    Navigator.pushNamed(context, RouteName.customerOrdersPage),
              ),
              SizedBox(height: 16),
              _buildRowItem(
                context,
                title: "Spent \$1500.00",
                icon: Icons.attach_money,
                onTap: () =>
                    Navigator.pushNamed(context, RouteName.customerSpentPage),
              ),
              SizedBox(height: 16),
              _buildRowItem(
                context,
                title: "Billing Address",
                icon: Icons.bookmark_outline,
              ),
              SizedBox(height: 16),
              _buildRowItem(
                context,
                title: "Shipping Address",
                icon: Icons.local_shipping_outlined,
              ),

              SizedBox(height: 16),
              _buildRowItem(
                context,
                title: "Activity log",
                icon: Icons.local_activity_outlined,
              ),

              SizedBox(height: 16),

              // Additional customer details can be added here
            ],
          ),
          appNavigationBar(
            title: "CUSTOMER DETAILS",
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return appGlassEffect(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          spacing: 4,
          children: [
            Icon(icon, size: 24, color: Colors.black54),
            loadTitleText(
              title: title,
              fontSize: 15,
              fontWight: FontWeight.w500,
              fontColor: Colors.black54,
            ),
            Spacer(),
            appForwardIcon(),
          ],
        ),
      ),
    );
  }
}
