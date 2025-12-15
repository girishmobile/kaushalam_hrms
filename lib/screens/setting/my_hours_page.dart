import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../provider/emp_provider.dart';
import '../../utility/secure_storage.dart';

class MyHoursPage extends StatefulWidget {
  const MyHoursPage({super.key});

  @override
  State<MyHoursPage> createState() => _MyHoursPageState();
}

class _MyHoursPageState extends State<MyHoursPage> {
  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  Future<void> init() async {
    try {
      final profile = Provider.of<EmpProvider>(context, listen: false);
      UserModel? user = await SecureStorage.getUser();
      debugPrint('User ID: ${user?.id}');
      await profile.getMYHours(id: user?.id ?? 0);
    } catch (e) {
      debugPrint('Error initializing MyWorkScreen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Consumer<EmpProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(child: showProgressIndicator());
                }

                if (provider.myWorkModel == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 50,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Error loading data',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () async {
                            UserModel? user = await SecureStorage.getUser();
                            await provider.getMYHours(id: user?.id ?? 0);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // Calculate billable and non-billable hours
                double totalBillableHours = 0;
                double totalNonBillableHours = 0;
                double totalBillableEffort = 0;
                double totalNonBillableEffort = 0;

                for (var project in provider.myWorkModel?.data ?? []) {
                  if (project.tasks != null) {
                    for (var task in project.tasks!) {
                      if (task.timelogs != null) {
                        for (var log in task.timelogs!) {
                          if (log.billingType == "Billable") {
                            totalBillableHours += log.hours ?? 0;
                            if (task.effortAllocation?.totalEffort != null) {
                              totalBillableEffort +=
                                  task.effortAllocation!.totalEffort!;
                            }
                          } else if (log.billingType == "NonBillable") {
                            totalNonBillableHours += log.hours ?? 0;
                            if (task.effortAllocation?.totalEffort != null) {
                              totalNonBillableEffort +=
                                  task.effortAllocation!.totalEffort!;
                            }
                          }
                        }
                      }
                    }
                  }
                }

                return appRefreshIndicator(
                  onRefresh: () async {
                    UserModel? user = await SecureStorage.getUser();
                    await provider.getMYHours(id: user?.id ?? 0);
                  },
                  child: SafeArea(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 56),
                            commonView(
                              colorIcon: Colors.green,
                              spentValue:
                                  "${totalBillableHours.toStringAsFixed(2)} hr",
                              allocationHours:
                                  "${totalBillableEffort.toStringAsFixed(0)} hr",
                            ),
                            SizedBox(height: 15),
                            commonView(
                              image: 'icBan',
                              colorIcon: Colors.red,
                              color: Colors.amber,
                              title: "Non-Billable",
                              spentValue:
                                  "${totalNonBillableHours.toStringAsFixed(2)} hr",
                              allocationHours:
                                  "${totalNonBillableEffort.toStringAsFixed(0)} hr",
                            ),
                            SizedBox(height: 15),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                loadTitleText(
                                  title:
                                      "Projects - ${provider.myWorkModel?.data?.length ?? 0}",
                                  fontSize: 16,
                                  fontWight: FontWeight.w600,
                                ),
                              ],
                            ),
                            Expanded(
                              child: provider.isLoading
                                  ? Center(child: showProgressIndicator())
                                  : provider.myWorkModel?.data == null
                                  ? const Center(
                                      child: Text(
                                        'Error loading data. Please try again.',
                                      ),
                                    )
                                  : provider.myWorkModel?.data?.isEmpty == true
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.work_off,
                                            size: 50,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            'No work data available',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemCount:
                                          provider.myWorkModel?.data?.length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        final project =
                                            provider.myWorkModel?.data?[index];
                                        if (project == null) {
                                          return const SizedBox.shrink();
                                        }

                                        return appViewEffect(
                                          padding: EdgeInsets.zero,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 0,
                                            vertical: 10,
                                          ),

                                          /*  decoration: commonBoxDecoration(
                                      borderColor: Colors.grey,
                                     // color: color.withValues(alpha: 0.05),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 10,
                                    ),*/
                                          child: Theme(
                                            data: Theme.of(context).copyWith(
                                              dividerColor: Colors.transparent,
                                            ),
                                            child: ExpansionTile(
                                              title: loadSubText(
                                                fontColor: Colors.black54,

                                                fontWight: FontWeight.w600,
                                                title:
                                                    project.title ??
                                                    'Untitled Project',
                                              ),
                                              subtitle: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                    ),
                                                child: Row(
                                                  spacing: 10,
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          commonBoxDecoration(
                                                            /*   color: color.withValues(
                                                    alpha: 0.2,
                                                  ),*/
                                                            borderColor:
                                                                Colors.grey,
                                                          ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 3,
                                                          ),
                                                      child: loadSubText(
                                                        fontWight:
                                                            FontWeight.w500,
                                                        title:
                                                            'Tasks: ${project.tasks?.length ?? 0}',
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration:
                                                          commonBoxDecoration(
                                                            /*  color: color.withValues(
                                                    alpha: 0.2,
                                                  ),*/
                                                            borderColor:
                                                                Colors.grey,
                                                          ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 3,
                                                          ),
                                                      child: loadSubText(
                                                        fontWight:
                                                            FontWeight.w500,
                                                        title:
                                                            'Total Hours: ${project.totalHours?.toStringAsFixed(1) ?? "0.0"}',
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //leading: const Icon(Icons.folder),
                                              children: [
                                                if (project.tasks != null &&
                                                    project.tasks!.isNotEmpty)
                                                  ...project.tasks!.map(
                                                    (task) => appViewEffect(
                                                      /*decoration:
                                                commonBoxDecoration(
                                                  borderColor:
                                                  Colors.grey.withValues(alpha: 0.5),
                                                  color: Colors.white,
                                                ),*/
                                                      padding: EdgeInsets.zero,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 10,
                                                          ),

                                                      child: ExpansionTile(
                                                        trailing:
                                                            const SizedBox.shrink(), // hides the arrow
                                                        title: loadSubText(
                                                          title:
                                                              task.title ??
                                                              'Untitled Task',
                                                          fontWight:
                                                              FontWeight.w600,
                                                          fontSize: 12,
                                                        ),
                                                        subtitle: Column(
                                                          spacing: 5,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,

                                                          children: [
                                                            loadSubText(
                                                              title:
                                                                  'Status: ${task.status ?? "Unknown"}',
                                                              fontSize: 11,
                                                            ),

                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: loadSubText(
                                                                    fontSize:
                                                                        11,
                                                                    title:
                                                                        'Start: ${_formatDate(task.dates?.start)}',
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: loadSubText(
                                                                    fontSize:
                                                                        11,
                                                                    title:
                                                                        'Due: ${_formatDate(task.dates?.start)}',
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                else
                                                  const Padding(
                                                    padding: EdgeInsets.all(16),
                                                    child: Text(
                                                      'No tasks available',
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                        provider.isLoading
                            ? showProgressIndicator()
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          appNavigationBar(
            title: "MY HOURS",
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget commonView({
    Color? color,
    Color? colorIcon,
    String? title,
    String? image,
    String? spentValue,
    String? allocationHours,
  }) {
    return appViewEffect(
      /*decoration: commonBoxDecoration(
        borderColor: Colors.grey,
       */
      /* color:
        color?.withValues(alpha: 0.1) ??
            Colors.green.withValues(alpha: 0.1),*/
      /*
      ),*/
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Column(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Row(
              spacing: 10,
              children: [
                //commonAssetImage(image??'',width: 30,height: 30,color: colorIcon),
                loadTitleText(
                  title: title ?? "Billable",
                  fontWight: FontWeight.w700,
                  fontSize: 14,
                ),
              ],
            ),
          ),
          Divider(height: 0.5, color: Colors.grey, thickness: 0.5),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Column(
              spacing: 8,
              children: [
                Row(
                  children: [
                    loadSubText(
                      title: "Total Time Spent: ",
                      fontWight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    loadSubText(title: spentValue ?? "128.02 hr", fontSize: 12),
                  ],
                ),
                Row(
                  children: [
                    loadSubText(
                      title: "Total Allocation Effort: ",
                      fontWight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    loadSubText(
                      title: allocationHours ?? "123 hr",
                      fontSize: 12,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
