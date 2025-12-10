import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/provider/manager_hotline_provider.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class HotlinePage extends StatelessWidget {
  final String status;
  const HotlinePage({super.key, required this.status});

  Map<String, String> getStatus(String status) {
    final value = status.toLowerCase();

    switch (value) {
      case "on_leave":
        return {"text": "ON LEAVE", "status": "on-leave"};

      case "on_wfh":
        return {"text": "WORK FROM HOME", "status": "wfh"};

      case "on_break":
        return {"text": "ON BREAK", "status": "on-break"};

      case "online":
        return {"text": "ONLINE", "status": "online"};

      case "offline":
        return {"text": "OFFLINE", "status": "offline"};

      default:
        return {"text": "ALL EMPLOYEES", "status": ""};
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Any post frame callback actions can be added here
      final statusCode = getStatus(status)["status"] ?? "";
      context.read<ManagerHotlineProvider>().getAllHotline(status: statusCode);
    });
    return AppScaffold(
      child: Consumer<ManagerHotlineProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              provider.hotlineDataList.isEmpty && !provider.isLoading
                  ? Center(child: Text("You don’t have any records yet."))
                  : _listOfEmployee(context, provider),
              Positioned(
                top: appTopPadding(context),
                left: 24,
                right: 24,
                child: _searchBar(context, provider),
              ),
              appNavigationBar(
                title: getStatus(status)["text"] ?? "ALL EMPLOYEES",
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

  Widget _searchBar(BuildContext context, ManagerHotlineProvider provider) {
    return appOrangeTextField(
      textController: provider.nameController,
      hintText: "search by employee name",
      icon: Icons.search,
      focusNode: provider.searchFocus,
    );
  }

  Widget _listOfEmployee(
    BuildContext context,
    ManagerHotlineProvider provider,
  ) {
    return ListView.separated(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: listTop(context),
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
