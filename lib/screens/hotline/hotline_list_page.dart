import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:neeknots_admin/core/constants/context_extension.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/models/hotline_count_model.dart';
import 'package:neeknots_admin/provider/hotline_list_provider.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class HotlineListPage extends StatefulWidget {
  const HotlineListPage({super.key});

  @override
  State<HotlineListPage> createState() => _HotlineListPageState();
}

class _HotlineListPageState extends State<HotlineListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initilized();
    });
  }

  Future<void> initilized() async {
    final provider = context.read<HotlineListProvider>();
    await Future.wait([provider.getHotlineCountData()]);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Consumer<HotlineListProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: appTopPadding(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 4,
                  children: [
                    _hotlineOption(provider),
                    Expanded(
                      child:
                          provider.hotline_employees.isEmpty &&
                              !provider.isLoading
                          ? Center(
                              child: Text("You don’t have any records yet."),
                            )
                          : _listOfHotline(context, provider),
                    ),
                  ],
                ),
              ),
              appNavigationBar(
                title: "HOTLINE",
                onTap: () => Navigator.pop(context),
              ),
              provider.isLoading ? showProgressIndicator() : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  Widget _listOfHotline(BuildContext context, HotlineListProvider provider) {
    return ListView.separated(
      padding: EdgeInsets.only(
        left: 0,
        bottom: appBottomPadding(context),
        right: 0,
        top: 12,
      ),
      primary: false,
      itemBuilder: (ctx, idx) {
        final item = provider.hotline_employees[idx];
        return hotlineCard(
          item,
          showArrow: false,
          onTaped: () {
            Navigator.pushNamed(
              context,
              RouteName.employeeDetailPage,
              arguments: "${item.id}",
            );
          },
        );
      },
      separatorBuilder: (_, _) => SizedBox(height: 8),
      itemCount: provider.hotline_employees.length,
    );
  }

  BoxBorder getStatusBorder(String? status) {
    final value = status?.toLowerCase() ?? "";
    switch (value) {
      case "pending":
        return BoxBorder.all(color: Colors.orange, width: 1);

      case "accept":
        return BoxBorder.all(color: Colors.green, width: 1);

      case "reject":
        return BoxBorder.all(color: Colors.red, width: 1);

      case "cancel":
        return BoxBorder.all(color: Colors.grey, width: 1);

      default:
        return BoxBorder.all(color: color2, width: 0);
    }
  }

  Widget _hotlineOption(HotlineListProvider provider) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, inx) {
          final item = provider.hotlineCount[inx];
          final isSelected = item.title == provider.selectedTitle;

          return _buildOptionItem(
            item,
            isSelected,
            onTap: () {
              provider.selectHotline(item.title);
            },
          );
        },
        separatorBuilder: (_, _) => SizedBox(width: 8),
        itemCount: provider.hotlineCount.length,
      ),
    );
  }

  Widget _buildOptionItem(
    HotlineCountModel item,
    bool isSelected, {
    VoidCallback? onTap,
  }) {
    final deptName = item.title.toTitleCase();
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(microseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          // color: isSelected ? Colors.orange.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? btnColor2 : color2, width: 1),
          gradient: viewBackgroundGradinet(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            loadSubText(
              title: deptName,
              fontSize: 12,
              fontWight: isSelected ? FontWeight.w500 : FontWeight.normal,
              fontColor: isSelected ? btnColor2 : Colors.black54,
            ),
            SizedBox(width: 6),
            loadSubText(
              title: "(${item.count})",
              fontSize: 10,
              fontWight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontColor: isSelected ? btnColor2 : Colors.black54,
            ),
            if (isSelected) ...[
              SizedBox(width: 6),
              Icon(Icons.check, size: 16, color: btnColor2),
            ],
          ],
        ),
      ),
    );
  }
}
