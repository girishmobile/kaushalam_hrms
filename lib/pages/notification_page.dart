import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/models/notification_model.dart';
import 'package:neeknots_admin/provider/emp_notifi_provider.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<EmpNotifiProvider>().getEmployeeNotification();
    });
    return AppScaffold(
      child: Consumer<EmpNotifiProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              provider.notifications.isEmpty && !provider.isLoading
                  ? Center(child: Text("You don’t have any notification yet."))
                  : ListView.separated(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: listTop(context),
                        bottom: appBottomPadding(context),
                      ),
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: true,
                      cacheExtent: 500,
                      itemBuilder: (context, index) {
                        final dataModel = provider.notifications[index];
                        return RepaintBoundary(
                          child: GestureDetector(
                            onTap: () {},
                            child: notificationCard(dataModel),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemCount: provider.notifications.length,
                    ),
              _searchBar(context),
              appNavigationBar(
                title: "NOTIFICATION",
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

  Widget _searchBar(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    final topBarHeight = 48.0; // from Dashboard SafeArea Row
    return Positioned(
      top: safeTop + topBarHeight + 8,
      left: 24,
      right: 24,
      child: appOrangeTextField(hintText: "search", icon: Icons.search),
    );
  }
}
