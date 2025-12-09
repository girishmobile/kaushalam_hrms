import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:neeknots_admin/components/components.dart';
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
              _kpiGridView(context, provider),
              topBar(context, provider: provider),
              provider.isLoading ? showProgressIndicator() : SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  Widget _kpiGridView(BuildContext context, MyKpiProvider provider) {
    return GridView.builder(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: listTop(context),
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
          onTap: () {},
          child: _buildGridItem(index: index, item: item),
        );
      },
      itemCount: provider.kpiList.length,
    );
  }

  Widget _buildGridItem({required int index, required MyKpiModel item}) {
    final num? percent = item.percent ;

    const List<String> monthNames = [
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
            monthNames[index],
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
    final safeTop = MediaQuery.of(context).padding.top;
    const topBarHeight = 48.0; // your Dashboard SafeArea Row
    final listTop = safeTop + topBarHeight + 16; // search bar height + spacing
    return Container(
      padding: EdgeInsets.only(top: listTop),
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

  Widget _buildGlassEffect({
    required Widget child,
    double borderRadius = 12,
    EdgeInsetsGeometry? padding,
    double blurSigma = 10,
    Color overlayColor = Colors.white,
    double opacity = 0.15,
    Color borderColor = Colors.white,
    double borderWidth = 1.0,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: overlayColor.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor.withValues(alpha: 0.4),
              width: borderWidth,
            ),
          ),
          child: child,
        ),
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
