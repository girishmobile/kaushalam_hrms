import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/provider/emp_provider.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class AllEmplyeePage extends StatefulWidget {
  const AllEmplyeePage({super.key});

  @override
  State<AllEmplyeePage> createState() => _AllEmplyeePageState();
}

class _AllEmplyeePageState extends State<AllEmplyeePage> {
  @override
  void initState() {
    super.initState();

    initEmployee();
  }

  Future<void> initEmployee() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<EmpProvider>(context, listen: false);
      await Future.wait([provider.getDepartment(), provider.getAllEmployees()]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Consumer<EmpProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              _listOfEmployee(context, provider),
              Positioned(
                top: appTopPadding(context),
                left: 24,
                right: 24,
                child: _searchBar(context, provider),
              ),
              Positioned(
                top: appTopPadding(context, extra: 64),
                left: 24,
                right: 24,
                child: _filterOption(provider: provider),
              ),
              appNavigationBar(
                title: "EMPLOYEES",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              provider.isLoading ? showProgressIndicator() : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  Widget _filterOption({required EmpProvider provider}) {
    if (provider.isLoading && provider.departments.isEmpty) {
      return Center(
        child: Text(
          "Loading...",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final isSelected = provider.selectedIndex == index;
          final dept = provider.departments.isNotEmpty
              ? provider.departments[index]
              : null;
          final deptName = dept != null ? dept.name : "Loading...";
          return GestureDetector(
            onTap: () {
              hideKeyboard(context);
              provider.nameController.clear();
              provider.setSelectedIndex(index);
              final dept = provider.departments[index];
              provider.filterByDepartment(dept.name);
            },
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
                    deptName,
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
        itemCount: provider.departments.length,
      ),
    );
  }

  Widget _searchBar(BuildContext context, EmpProvider provider) {
    return appOrangeTextField(
      textController: provider.nameController,
      hintText: "search by employee name",
      icon: Icon(Icons.search),
      focusNode: provider.searchFocus,
    );
  }

  Widget _listOfEmployee(BuildContext context, EmpProvider provider) {
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
        final employee = provider.filteredList[index];
        return RepaintBoundary(
          child: GestureDetector(
            onTap: () {
              // Navigator.pushNamed(context, RouteName.employeeDetailPage);
              Navigator.pushNamed(
                context,
                RouteName.profileScreen,
                arguments: {
                  "employeeId": '${employee.id}',
                  "isCurrentUser": false,
                },
              );
            },
            child: employeeCard(employee),
          ),
        );
      },
      itemCount: provider.filteredList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
