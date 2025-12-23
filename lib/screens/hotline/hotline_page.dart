import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/models/hotline_count_model.dart';
import 'package:neeknots_admin/provider/app_provider.dart';
import 'package:neeknots_admin/provider/manager_hotline_provider.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class HotlinePage extends StatelessWidget {
  final HotlineCountModel status;
  const HotlinePage({super.key, required this.status});

  Map<String, String> getStatus(HotlineCountModel item) {
    final value = item.title.toLowerCase();
    switch (value) {
      case "on_leave":
        return {"text": "ON LEAVE (${item.count})", "status": "on-leave"};

      case "on_wfh":
        return {"text": "WORK FROM HOME (${item.count})", "status": "wfh"};

      case "on_break":
        return {"text": "ON BREAK (${item.count})", "status": "on-break"};

      case "online":
        return {"text": "ONLINE (${item.count})", "status": "online"};

      case "offline":
        return {"text": "OFFLINE (${item.count})", "status": "offline"};

      default:
        return {"text": "ALL EMPLOYEES (${item.count})", "status": ""};
    }
  }

  @override
  Widget build(BuildContext context) {
    String userRole = "employee";

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Any post frame callback actions can be added here
      final statusCode = getStatus(status)["status"] ?? "";
      context.read<ManagerHotlineProvider>().getAllHotline(status: statusCode);
      userRole = await getUserRole();
    });
    return AppScaffold(
      appTitle: getStatus(status)["text"] ?? "ALL EMPLOYEES",
      child: Consumer<ManagerHotlineProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 0,
                  bottom: appBottomPadding(context),
                ),
                child: Column(
                  spacing: 10,
                  children: [
                    _searchBar(context, provider),
                    provider.hotlineDataList.isEmpty && !provider.isLoading
                        ? Expanded(
                            child: Center(
                              child: Text("You don’t have any records yet."),
                            ),
                          )
                        : Expanded(
                            child: _listOfEmployee(context, provider, userRole),
                          ),
                  ],
                ),
              ),

              provider.isLoading ? showProgressIndicator() : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  Widget _searchBar(BuildContext context, ManagerHotlineProvider provider) {
    return appOrangeTextField(
      textController: provider.nameController,
      hintText: "search by employee name",
      icon: Icon(Icons.search),
      focusNode: provider.searchFocus,
    );
  }

  Widget _listOfEmployee(
    BuildContext context,
    ManagerHotlineProvider provider,
    String userRole,
  ) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      cacheExtent: 500,
      itemBuilder: (context, index) {
        final employee = provider.filteredList[index];
        return RepaintBoundary(
          child: GestureDetector(
            onTap: () {
              if (userRole == "hr" || userRole == "super admin") {
                Navigator.pushNamed(
                  context,
                  RouteName.employeeDetailPage,
                  arguments: "${employee.id}",
                );
              }
            },
            child: hotlineCard(employee),
          ),
        );
      },
      itemCount: provider.filteredList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}
