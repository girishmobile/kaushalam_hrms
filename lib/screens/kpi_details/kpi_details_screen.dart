import 'package:flutter/material.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:provider/provider.dart';

import '../../common/app_scaffold.dart';
import '../../models/kpi_details_model.dart';
import '../../provider/my_kpi_provider.dart';
import '../../utility/utils.dart';

class KpiDetailsScreen extends StatefulWidget {
  const KpiDetailsScreen({super.key, required this.year, required this.month});

  final String year;
  final String month;

  @override
  State<KpiDetailsScreen> createState() => _KpiDetailsScreenState();
}

class _KpiDetailsScreenState extends State<KpiDetailsScreen> {
  late final int _year;
  late final int _month;

  @override
  void initState() {
    super.initState();

    _year = int.parse(widget.year);
    _month = int.parse(widget.month);

    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final provider = context.read<MyKpiProvider>();
    provider.selectedYear = provider.selectedYear.isEmpty
        ? DateTime.now().year.toString()
        : provider.selectedYear;

    await provider.getKPIDetailsList(month: widget.month, year: widget.year);
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime(_year, _month, 1);

    return AppScaffold(
      appTitle: "${getFormattedDate(date, format: "MMM")}-$_year",
      child: Consumer<MyKpiProvider>(
        builder: (_, provider, __) {
          return Stack(
            children: [
              CustomScrollView(
                slivers: [_kpiHeaderSliver(), _kpiListSliver(provider)],
              ),
              if (provider.isLoading) showProgressIndicator(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return appViewEffect(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: loadTitleText(
                title: "Date",
                fontSize: 14,
                fontColor: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: loadTitleText(
                title: "Target \n Point",
                fontSize: 14,
                fontColor: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,

              child: loadTitleText(
                title: "Actual\n Point",
                fontSize: 14,
                fontColor: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem({
    required String dateValue,
    String? remarkValue,
    required String targetValue,
    required String actualValue,
  }) {
    final hasRemark = remarkValue != null && remarkValue.trim().isNotEmpty;

    return appViewEffect(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: loadSubText(
                  title: dateValue,
                  fontSize: 14,
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: loadSubText(
                  title: targetValue,
                  fontSize: 14,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: loadSubText(
                  title: actualValue,
                  fontSize: 14,
                  textAlign: TextAlign.right,
                  fontColor: getActualValueColor(
                    num.tryParse(actualValue) ?? 0,
                  ),
                ),
              ),
            ],
          ),
          if (hasRemark) ...[
            const SizedBox(height: 8),
            loadSubText(
              title: remarkValue,
              fontSize: 12,
              textAlign: TextAlign.left,
            ),
          ],
        ],
      ),
    );
  }

  List<DateTime> _getDaysInMonth(int year, int month) {
    final lastDay = DateTime(year, month + 1, 0);
    return List.generate(lastDay.day, (i) => DateTime(year, month, i + 1));
  }

  Color getActualValueColor(num actualValue) {
    if (actualValue < 50) {
      return Colors.deepOrange; // < 50
    } else if (actualValue < 60) {
      return Colors.blueGrey; // 50–59
    } else if (actualValue < 70) {
      return Colors.orange; // 60–69
    } else if (actualValue < 80) {
      return Colors.green; // 70–79
    } else if (actualValue < 90) {
      return Colors.green; // 80–89
    } else if (actualValue < 100) {
      return Colors.green; // 90–99
    } else {
      return Colors.green.shade900; // 100+
    }
  }

  SliverList _kpiListSliver(MyKpiProvider provider) {
    final days = _getDaysInMonth(_year, _month);

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final day = days[index];
        final formattedDay = getFormattedDate(day, format: 'yyyy-MM-dd');
        final item = provider.kpiDetailsList
            .cast<KpiDetailsModel?>()
            .firstWhere(
              (e) => e?.date?.date?.split(' ').first == formattedDay,
              orElse: () => null,
            );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: _buildRowItem(
            dateValue: getFormattedDate(day, format: 'dd-MM-yyyy'),
            targetValue: item?.targetValue?.toString() ?? '0',
            actualValue: item?.actualValue?.toString() ?? '0',
            remarkValue: item?.remarks ?? '',
          ),
        );
      }, childCount: days.length),
    );
  }

  SliverPersistentHeader _kpiHeaderSliver() {
    return SliverPersistentHeader(
      pinned: true, // header stays visible
      delegate: _KpiHeaderDelegate(child: _buildHeader()),
    );
  }
}

class _KpiHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _KpiHeaderDelegate({required this.child});

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
