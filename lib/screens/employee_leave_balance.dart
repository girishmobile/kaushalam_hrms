import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:neeknots_admin/models/leave_balance_model.dart';
import 'package:neeknots_admin/provider/emp_provider.dart';
import 'package:neeknots_admin/provider/leave_balance_provider.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class EmployeeLeaveBalance extends StatelessWidget {
  const EmployeeLeaveBalance({super.key});

  @override
  Widget build(BuildContext context) {
    /// Fetch API only once when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaveBalanceProvider>().getAllEmployeeLeaveBalance();
    });

    return AppScaffold(
      child: Consumer<EmpProvider>(
        builder: (context, provider, chld) {
          return Consumer<LeaveBalanceProvider>(
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
                  appNavigationBar(
                    title: "LEAVE BALANCE",
                    onTap: () => Navigator.pop(context),
                  ),
                  provider.isLoading
                      ? showProgressIndicator()
                      : SizedBox.shrink(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _searchBar(BuildContext context, LeaveBalanceProvider provider) {
    return appOrangeTextField(
      textController: provider.nameController,
      hintText: "search by employee name",
      icon: Icons.search,
    );
  }

  Widget _listOfEmployee(BuildContext context, LeaveBalanceProvider provider) {
    return ListView.separated(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: listTop(context),
        bottom: appBottomPadding(context),
      ),
      itemBuilder: (context, index) {
        final leaves = provider.filteredList[index];

        return _leaveBalanceItem(item: leaves);
      },
      separatorBuilder: (_, _) => SizedBox(height: 8),
      itemCount: provider.filteredList.length,
    );
  }

  Widget _leaveBalanceItem({required EmpLeaveBalance item}) {
    final fullImageUrl =
        (item.profile_image != null && item.profile_image!.isNotEmpty)
        ? "${ApiConfig.imageBaseUrl}${item.profile_image}"
        : null;
    return appViewEffect(
      child: Column(
        spacing: 16,
        children: [
          Row(
            children: [
              appCircleImage(
                iconColor: btnColor2,
                borderColor: btnColor2.shade200,
                radius: 24,
                imageUrl: fullImageUrl,
                icon: Icons.person_outline,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${item.firstname} ${item.lastname}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          "Balance: ${item.balance}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              _buildRowItem(type: "CL", value: "${item.cl}"),
              _buildRowItem(type: "SL", value: "${item.sl}"),
              _buildRowItem(type: "PL", value: "${item.pl}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem({required String type, required String value}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: color1,
          border: Border.all(color: color2, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Center(child: loadSubText(title: type, fontSize: 12)),
            Center(child: loadTitleText(title: value, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
