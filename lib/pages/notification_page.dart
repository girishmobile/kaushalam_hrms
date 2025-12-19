import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/provider/emp_notifi_provider.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<EmpNotifiProvider>().getEmployeeNotification();
       context.read<EmpNotifiProvider>().readAllNotification();
    });
    return AppScaffold(
      appTitle: "NOTIFICATION",
      child: Consumer<EmpNotifiProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              Padding(
                padding:EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 0,
                  bottom: appBottomPadding(context),
                ),
                child: Column(
                  spacing: 10,
                  children: [
                    _searchBar(context, provider),
                    Expanded(
                      child: provider.filteredList.isEmpty && !provider.isLoading
                          ? Center(
                              child: Text("You don’t have any notification yet."),
                            )
                          : ListView.separated(
                              padding: EdgeInsets.zero,
                              addAutomaticKeepAlives: false,
                              addRepaintBoundaries: true,
                              cacheExtent: 500,
                              itemBuilder: (context, index) {
                                final dataModel = provider.filteredList[index];
                                return RepaintBoundary(
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: notificationCard(dataModel),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 8),
                              itemCount: provider.filteredList.length,
                            ),
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

  Widget _searchBar(BuildContext context, EmpNotifiProvider provider) {
    return appOrangeTextField(
      textController: provider.nameController,
      hintText: "search",
      icon: const Icon(Icons.search),
    );
  }

}
