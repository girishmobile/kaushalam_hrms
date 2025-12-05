import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/models/customer_model.dart';
import 'package:neeknots_admin/utility/utils.dart';

class AllEmplyeePage extends StatefulWidget {
  const AllEmplyeePage({super.key});

  @override
  State<AllEmplyeePage> createState() => _AllEmplyeePageState();
}

class _AllEmplyeePageState extends State<AllEmplyeePage> {
  int selectedIndex = 0;

  final List<String> filters = [
    "All",
    "Admin",
    "HR",
    "Web Designing",
    "Development",
    "Marketing",
    "SEO",
    "Management",
    "Desinger",
    "Networking",
    "Bussiness Analyst",
    "QA",
    "Mobile Application",
    "HTML",
    "Account",
    "Content Writer",
    "Shopify",
    "Deo",
  ];
  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    final topBarHeight = 48.0; // from Dashboard SafeArea Row
    return AppScaffold(
      child: Stack(
        children: [
          _listOfEmployee(context),
          Positioned(
            top: safeTop + topBarHeight + 8,
            left: 24,
            right: 24,
            child: _searchBar(context),
          ),
          Positioned(
            top: appTopPadding(context, extra: 64),
            left: 24,
            right: 24,
            child: _filterOption(),
          ),
          appNavigationBar(
            title: "EMPLOYEES",
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _filterOption() {
    return SizedBox(
      width: double.infinity,
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,

        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedIndex = index),
            child: AnimatedContainer(
              duration: Duration(microseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                // color: isSelected ? Colors.orange.shade50 : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? btnColor2 : color2,
                  width: 1,
                ),
                gradient: viewBackgroundGradinet(),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filters[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w500
                          : FontWeight.normal,
                      color: isSelected ? btnColor2 : Colors.black54,
                    ),
                  ),
                  if (isSelected) ...[
                    SizedBox(width: 6),
                    Icon(Icons.check, size: 16, color: btnColor2),
                  ],
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, _) => SizedBox(width: 10),
        itemCount: filters.length,
      ),
    );
  }

  Widget _listOfEmployee(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: listTop(context, extra: 44),
        bottom: listBottom(context),
      ),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      cacheExtent: 500,
      itemBuilder: (context, index) {
        final custModel = sampleCustomers[index];
        return RepaintBoundary(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RouteName.employeeDetailPage);
            },
            child: employeeCard(custModel),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemCount: sampleCustomers.length,
    );
  }

  Widget _searchBar(BuildContext context) {
    return appOrangeTextField(hintText: "search", icon: Icons.search);
  }
}
