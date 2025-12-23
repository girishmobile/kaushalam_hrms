import 'package:flutter/material.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:provider/provider.dart';

import '../../common/app_scaffold.dart';
import '../../models/kpi_details_model.dart';
import '../../provider/my_kpi_provider.dart';
import '../../utility/utils.dart';

class KpiDetailsScreen extends StatefulWidget {
  const KpiDetailsScreen({
    super.key,
    required this.year,
    required this.month,
  });

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

    await provider.getKPIDetailsList(
      month: widget.month,
      year: widget.year,
    );
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime(_year, _month, 1);

    return AppScaffold(
      appTitle:
      "My KPI ${getFormattedDate(date, format: "MMM")}-$_year",
      child: Consumer<MyKpiProvider>(
        builder: (_, provider, __) {
          return Stack(
            children: [
              _kpiList(provider),
              if (provider.isLoading) showProgressIndicator(),
            ],
          );
        },
      ),
    );
  }

  Widget _kpiList(MyKpiProvider provider) {
    final days = _getDaysInMonth(_year, _month);

    return ListView.separated(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: appBottomPadding(context),
      ),
      itemCount: days.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, index) {
        final day = days[index];
        final formattedDay =
        getFormattedDate(day, format: 'yyyy-MM-dd');

        final item = provider.kpiDetailsList
            .cast<KpiDetailsModel?>()
            .firstWhere(
              (e) =>
          e?.date?.date?.split(' ').first == formattedDay,
          orElse: () => null,
        );

        return appViewEffect(
          child: Column(
            spacing: 5,
            children: [
              _commonItemView(
                title: "Date",
                value:
                getFormattedDate(day, format: 'dd-MM-yyyy'),
                fontWight: FontWeight.w500,
              ),
              _commonItemView(
                title: "Target Points",
                value: item?.targetValue?.toString() ?? '0',
              ),
              _commonItemView(
                fontWight: FontWeight.w600,
                title: "Actual Points",
                colorText: Colors.black.withValues(alpha: 0.80),
                value: item?.actualValue?.toString() ?? '0',
              ),
              _commonItemView(
                title: "Remarks",
                value: item?.remarks ?? '-',
              ),
            ],
          ),
        );
      },
    );
  }

  List<DateTime> _getDaysInMonth(int year, int month) {
    final lastDay = DateTime(year, month + 1, 0);
    return List.generate(
      lastDay.day,
          (i) => DateTime(year, month, i + 1),
    );
  }
}

Widget _commonItemView({

  required String title,
  required String value,
  FontWeight? fontWight,
  Color? colorText,
}) {
  return Row(
    children: [
      Expanded(
        child: loadSubText(
          title: title,
          fontSize: 12,

          fontWight: FontWeight.w400,
        ),
      ),
      loadSubText(
        title: value,
        fontSize: 12,
        fontColor: colorText,
        fontWight: fontWight ?? FontWeight.w400,
      ),
    ],
  );
}
