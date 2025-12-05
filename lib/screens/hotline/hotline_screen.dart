import 'package:flutter/material.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/colors.dart';

import 'package:provider/provider.dart';


import '../../api/api_config.dart';
import '../../common/app_scaffold.dart';
import '../../core/constants/context_extension.dart';
import '../../models/hotline_count_model.dart';
import '../../models/hotline_list_model.dart';
import '../../provider/hotline_provider.dart';
import 'user_details_by_id_view.dart';

class HotlineScreen extends StatefulWidget {
  const HotlineScreen({super.key});

  @override
  State<HotlineScreen> createState() => _HotlineScreenState();
}

class _HotlineScreenState extends State<HotlineScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await init();
    });
  }

  Future<void> init() async {
    final provider = Provider.of<HotlineProvider>(context, listen: false);
    await provider.resetHotlineData();
    await Future.wait([
      provider.getLeaveCountData(),
      provider.getAllDepartment(),
      provider.getAllDesignation(),
    ]);
    await provider.getAllHotline(status: provider.title);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HotlineProvider>();
    var size = MediaQuery.sizeOf(context);

    final departmentNames = provider.departments
        .map((e) => e.name ?? '')
        .toList();
    final selectedDeptName = provider.selectedDepartment?.name;

    final designationNames = provider.designationList
        .map((e) => e.name ?? '')
        .toList();
    final selectedDesignationName = provider.selectDesignation?.name;
    return AppScaffold(


     /* appBar: commonAppBar(
        title: "Hotline",
        context: context,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showCommonBottomSheet(
                content: Consumer<HotlineProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 15,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: commonText(
                                text: "Filter Hotline",
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              width: 35,
                              height: 35,
                              decoration: commonBoxDecoration(
                                shape: BoxShape.circle,

                                color: colorProduct,
                              ),
                              child: Center(
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(
                                    size: 14,
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonText(
                              text: "Department",
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(height: 8),

                            CommonDropdown(
                              items: departmentNames,
                              initialValue: selectedDeptName,
                              hint: "Select Department",
                              onChanged: (value) {
                                if (value != null) {
                                  final selected = provider.departments
                                      .firstWhere((d) => d.name == value);
                                  provider.selectDepartment(selected);

                                  //        provider.getAllHotline(depId: selected.id);
                                }
                              },
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonText(
                              text: "Designation",
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(height: 8),
                            CommonDropdown(
                              items: designationNames.toSet().toList(),
                              // remove duplicates
                              initialValue:
                                  designationNames.contains(
                                    selectedDesignationName,
                                  )
                                  ? selectedDesignationName
                                  : null,
                              hint: "Select Department",
                              onChanged: (value) {
                                if (value != null) {
                                  final selected = provider.designationList
                                      .firstWhere((d) => d.name == value);
                                  provider.selectDesignationData(selected);
                                  provider.getAllHotline(desId: selected.id);
                                }
                              },
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonText(
                              text: "Search Employee",
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(height: 8),
                            commonTextField(
                              hintText: "Search Employee",
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.search),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                      ],
                    );
                  },
                ),
                context: context,
              );
            },
            icon: commonAssetImage(
              icFitter,
              color: Colors.white,
              width: 24,
              height: 24,
            ),
          ),
          SizedBox(width: 8),
        ],
      ),*/
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    loadTitleText(
                      title: "HotLine",
                      fontWight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    SizedBox(height: 5),
                    GridView.builder(
                      shrinkWrap: true,

                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: 0,
                        right: 0,
                        bottom: 16,
                      ),
                      itemCount: provider.hotlineCount.length,

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // 2 columns
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 2.6,
                          ),
                      itemBuilder: (context, index) {
                        final item = provider.hotlineCount[index];
                        final color =
                            provider.colors[index %
                                provider
                                    .colors
                                    .length]; // pick color cyclically*/
                        final isSelected = provider.selectedHotlineIndex == index;
                        return buildItemView(
                          item: item,
                          isSelected: isSelected,
                          onTap: () async {
                            /// Update selection in provider
                            provider.selectHotline(index);
                            provider.setHeaderTitle(item.title);

                            /// Call your API with selected value

                            if (item.title == "on_wfh") {
                              await provider.getAllHotline(status: "wfh");
                            } else if (item.title == "on_break") {
                              await provider.getAllHotline(status: "on-break");
                            } else if (item.title == "on_leave") {
                              await provider.getAllHotline(status: "on-leave");
                            } else if (item.title == "online") {
                              await provider.getAllHotline(status: item.title);
                            } else if (item.title == "offline") {
                              await provider.getAllHotline(status: item.title);
                            } else {
                              await provider.getAllHotline();
                            }
                          },
                          color: color,

                          context: context,
                        );
                      },
                    ),

                    loadTitleText(
                      // text:provider.title.toString().toTitleCase()?? "All Employees",
                      title:
                          'Employees - ${provider.title.toString().toTitleCase()}',
                      fontWight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    SizedBox(height: 5),

                    provider.hotlineListModel?.data?.data?.isNotEmpty == true
                        ? ListView.builder(
                            shrinkWrap: true,
                           
                            physics: BouncingScrollPhysics(),
                            itemCount:
                                provider.hotlineListModel?.data?.data?.length,
                            itemBuilder: (context, index) {
                              var data =
                                  provider.hotlineListModel?.data?.data?[index];

                              return InkWell(
                                onTap: () {
                                  showCommonBottomSheet(
                                    context: context,
                                    content: SizedBox(
                                      height: size.height * 0.8,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: loadSubText(
                                                  title: "",
                                                  fontWight: FontWeight.w700,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Container(
                                                width: 35,
                                                height: 35,
                                                decoration: commonBoxDecoration(
                                                  shape: BoxShape.circle,

                                                  color: color3,
                                                ),
                                                child: Center(
                                                  child: IconButton(
                                                    padding: EdgeInsets.zero,
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    icon: Icon(
                                                      size: 14,
                                                      Icons.close,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          Expanded(
                                            child: UserDetailsByIdView(
                                              id: '${data?.id ?? 0}',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },

                                child: appViewEffect(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 15,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 8,
                                  ),

                               /*   decoration: commonBoxDecoration(
                                    color: color.withValues(alpha: 0.04),
                                    borderColor: color3,
                                    borderRadius: 8,
                                  ),*/

                                  child: Row(
                                    spacing: 10,
                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      appCircleImage(
                                        borderColor: color3,
                                        imageUrl:   "${ApiConfig.imageBaseUrl}${ data?.profileImage}",
                                        radius: 18,

                                      ),

                                      Expanded(
                                        child: Column(
                                          spacing: 1,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            loadSubText(
                                              title:
                                                  '${data?.firstname} ${data?.lastname}',
                                              fontSize: 14,
                                              fontWight: FontWeight.w600,
                                           //   fontColor: color,
                                              textAlign: TextAlign.center,
                                            ),

                                            loadSubText(
                                              title: '${data?.designation}',
                                              fontSize: 11,
                                              fontWight: FontWeight.w400,
                                             // fontColor: color3,
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      appViewEffect(

                                        borderColor: data?.workStatus.toString().toLowerCase()=="online"?Colors.green:data?.workStatus.toString().toLowerCase()=="on-break"?Colors.amber:Colors.grey,
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          child: loadSubText(title: '${data?.workStatus.toString().toCapitalize()}',fontSize: 10,fontColor:data?.workStatus.toString().toLowerCase()=="online"?Colors.green:data?.workStatus.toString().toLowerCase()=="on-break"?Colors.amber:Colors.grey))
                                    ],
                                  ),
                                ),
                                // child: _buildEmployee(data: data),
                              );
                            },
                          )
                        : SizedBox(
                            width: size.width,
                            height: size.height * 0.6,
                            child: provider.isLoading
                                ? SizedBox.shrink()
                                : Center(child: loadSubText(title: "No data found")),
                          ),
                  ],
                ),
              ),

              provider.isLoading ? showProgressIndicator() : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployee({HotLineData? data}) {
    return Stack(
      children: [
       /* CachedImageWidget(
          imageUrl: data?.profileImage,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover, // <-- Ensures image fills the height nicely
        ),*/
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white.withValues(alpha: 0.5),
            width: double.infinity,
            padding: const EdgeInsets.all(4),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                loadSubText(
                  title: '${data?.firstname} ${data?.lastname}',
                  fontSize: 14,
                  fontWight: FontWeight.w500,
                  fontColor: color3,
                  textAlign: TextAlign.center,
                ),
                loadSubText(
                  title: '${data?.designation}',
                  fontSize: 11,
                  fontWight: FontWeight.w400,
                  fontColor: color3,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHotLineItem() {
    return Container(height: 60, width: double.infinity, color: Colors.amber);
  }

  Widget buildItemView({
    required HotlineCountModel item,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onTap,

      child: Container(
        decoration: commonBoxDecoration(
          borderRadius: 8,
          borderColor: isSelected ? color : color3,
          color: isSelected
              ? color.withValues(alpha: 0.2)
              : color.withValues(alpha: 0.04),
          //  borderColor: colorBorder,
          //  color: color.withValues(alpha: 0.04),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            loadSubText(
              title: item.title.toString().toTitleCase(),
              fontSize: 14,
              fontWight: FontWeight.w500,
           //   fontColor: color3,
            ),
            const SizedBox(width: 6),
            loadSubText(
              /*  leftText: '',
              rightText: '',*/
              title: '${item.count}',
              // duration: Duration(seconds: 2),
              /*style: commonTextStyle(
                fontSize: 16,
                color: color,
                fontWeight: FontWeight.w600,
              ),*/
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
