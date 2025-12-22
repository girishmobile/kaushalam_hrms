import 'package:flutter/material.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/models/my_kpi_model.dart';
import 'package:neeknots_admin/provider/my_kpi_provider.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class MyKpiScreen extends StatefulWidget {
  const MyKpiScreen({super.key});

  @override
  State<MyKpiScreen> createState() => _MyKpiScreenState();
}

class _MyKpiScreenState extends State<MyKpiScreen> {
  final GlobalKey _buttonKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  Future<void> init() async {
    final provider = Provider.of<MyKpiProvider>(context, listen: false);
    // Get current year dynamically
    final currentYear = DateTime.now().year.toString();

    // If selectedYear is empty or null, set it to current year
    if (provider.selectedYear.isEmpty) {
      provider.selectedYear = currentYear;
    }

    await provider.getKPIList(date: provider.selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyKpiProvider>(
      builder: (context, provider, child) {
        return appRefreshIndicator(
          onRefresh: () async {
            return provider.getKPIList(date: provider.selectedYear);
          },
          child: Stack(
            children: [
              Column(
                children: [
                  topBar(context, provider: provider),
                  Expanded(child: _kpiGridView(context, provider)),
                ],
              ),
              provider.isLoading ? showProgressIndicator() : SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  Widget _kpiGridView(BuildContext context, MyKpiProvider provider) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: listBottom(context),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (context, index) {
        final item = provider.kpiList[index];



        return GestureDetector(
          onTap: () {

            Navigator.pushNamed(context, RouteName.kpiDetailsScreen,arguments: {

              "month": '${item.month}',
              "year": provider.selectedYear.toString(),
            },);

          },
          child: _buildGridItem(index: index, item: item),
        );
      },
      itemCount: provider.kpiList.length,
    );
  }

  String getMonthName(int month) {
    const names = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return names[month - 1];
  }

  Widget _buildGridItem({required int index, required MyKpiModel item}) {
    final num? percent = item.percent;

    return appViewEffect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          // Flexible details section
          appCircleIcon(
            icon: Icons.line_axis_outlined,
            gradient: appGradient(),
            iconSize: 36,
          ),
          Text(
            getMonthName(item.month?.toInt() ?? 1),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),

          Text(
            '$percent%',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget topBar(BuildContext context, {required MyKpiProvider provider}) {
    return Container(
      padding: EdgeInsets.only(top: 0),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "YOUR KRA KPI",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          GestureDetector(
            onTap: () => showYearPopover(
              context: context,
              provider: provider,
              buttonKey: _buttonKey,
            ),
            key: _buttonKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: viewBackgroundGradinet(),

                border: Border.all(
                  color: const Color(0xFFFFAC55).withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    provider.selectedYear,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, size: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showYearPopover({
    required BuildContext context,
    required MyKpiProvider provider,
    required GlobalKey buttonKey,
  }) async {
    // Get button position
    final RenderBox button =
        buttonKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final Offset buttonPosition = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );
    final Size buttonSize = button.size;

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        buttonPosition.dx,
        buttonPosition.dy + buttonSize.height + 4, // pop below button
        overlay.size.width - buttonPosition.dx - buttonSize.width,
        0,
      ),
      items: provider.years.map((year) {
        return PopupMenuItem<String>(
          value: year,
          child: loadSubText(
            title: year,
            textAlign: TextAlign.center,
            fontSize: 16,
          ),
        );
      }).toList(),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    if (selected != null && selected != provider.selectedYear) {
      provider.setYear(selected); // ✅ Update Provider
    }
  }
}
