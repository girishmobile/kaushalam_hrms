import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/provider/profile_provider.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

import '../api/api_config.dart';

class ProfileScreen extends StatefulWidget {
  final String employeeId;
  final bool isCurrentUser;

  const ProfileScreen({
    super.key,
    required this.employeeId,
    required this.isCurrentUser,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ProfileProvider>(
        context,
        listen: false,
      ).loadProfileFromCache();
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Map<String, dynamic> body = {"employee_id": widget.employeeId};
      context.read<ProfileProvider>().getUserProfile(
        body: body,
        isCurrentUser: widget.isCurrentUser,
      );
    });
    return AppScaffold(
      child: appRefreshIndicator(
        onRefresh: () async {
          init();
        },
        child: Consumer<ProfileProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                ListView(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: appTopPadding(context),
                    bottom: appBottomPadding(context),
                  ),
                  children: [
                    Consumer<ProfileProvider>(
                      builder: (_, profileProvider, _) {
                        return appProfileImage(
                          text: profileProvider.profileModel?.firstname ?? '',
                          context: context,
                          imageUrl: widget.isCurrentUser
                              ? "${ApiConfig.imageBaseUrl}${profileProvider.profileImage}"
                              : "${ApiConfig.imageBaseUrl}${profileProvider.imageUrl}",
                          radius: 60,
                          isEdit: widget.isCurrentUser,
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    loadTitleText(
                      title:
                          "${provider.profileModel?.firstname ?? ''} ${provider.profileModel?.lastname ?? ''}",
                      textAlign: TextAlign.center,
                    ),
                    loadSubText(
                      title: provider.profileModel?.designation?.name ?? '',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
                    _builRowTitle(
                      icon: Icons.person_outline_outlined,
                      label: "Basic Information",
                    ),
                    SizedBox(height: 12),
                    _buildPersonalInfo(provider: provider),
                    SizedBox(height: 24),
                    _builRowTitle(
                      icon: Icons.account_balance_outlined,
                      label: "Company Relations",
                    ),
                    SizedBox(height: 12),
                    _buildCompnayInfo(provider: provider),
                    SizedBox(height: 24),
                    _builRowTitle(
                      icon: Icons.call_outlined,
                      label: "Contact Information",
                    ),
                    SizedBox(height: 12),
                    _buildContactInfo(provider: provider),
                    SizedBox(height: 24),
                    _builRowTitle(icon: Icons.book_outlined, label: "Document"),
                    SizedBox(height: 12),
                    _buildDocuments(provider: provider),
                    SizedBox(height: 24),
                    _builRowTitle(
                      icon: Icons.share_outlined,
                      label: "Social Network",
                    ),
                    SizedBox(height: 12),
                    _buildSocial(provider: provider),
                    SizedBox(height: 24),
                    gradientButton(title: "LOGOUT", onPressed: () {}),
                  ],
                ),
                appNavigationBar(
                  title: "PROFILE",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                provider.isLoading
                    ? showProgressIndicator()
                    : SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _builRowTitle({required IconData icon, required String label}) {
    return Row(
      spacing: 4,
      children: [
        appCircleIcon(icon: icon, gradient: appGradient()),
        appGradientText(
          text: label,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          gradient: appGradient(),
        ),
      ],
    );
  }

  Widget _buildPersonalInfo({required ProfileProvider provider}) {
    return appViewEffect(
      child: Column(
        spacing: 8,
        children: [
          _builBasicRowInfo(
            label: "Full Name",
            titleText: provider.profileModel?.firstname != null
                ? "${provider.profileModel?.firstname} ${provider.profileModel?.lastname}"
                : '',
          ),
          _builBasicRowInfo(
            label: "Employee ID",
            titleText: provider.profileModel?.employeeId != null
                ? "${provider.profileModel?.employeeId}"
                : '',
          ),
          _builBasicRowInfo(
            label: "Per Email",
            titleText: provider.profileModel?.email ?? '-',
          ),
          _builBasicRowInfo(
            label: "Com Email",
            titleText: provider.profileModel?.companyEmail ?? '-',
          ),
          _builBasicRowInfo(
            label: "Gender",
            titleText: provider.profileModel?.gender?.valueText ?? '',
          ),
          _builBasicRowInfo(
            label: "Birthday",
            titleText: convertDate(
              provider.profileModel?.dateOfBirth?.date,
              format: "dd-MMM-yyyy",
            ),
          ),
          _builBasicRowInfo(
            label: "Blood Group",
            titleText: provider.profileModel?.bloodGroup ?? '-',
          ),
          _builBasicRowInfo(
            label: "Marital Status",
            titleText: (provider.profileModel?.maritalStatus ?? false)
                ? "Married"
                : "Single",
          ),
          _builBasicRowInfo(
            label: "Status",
            titleText: (provider.profileModel?.userExitStatus ?? false)
                ? "Active"
                : "Inactive",
          ),

          _builBasicRowInfo(
            label: "External System Access",
            titleText: (provider.profileModel?.allowedLogin ?? false)
                ? "Yes"
                : "No",
          ),
        ],
      ),
    );
  }

  Widget _buildCompnayInfo({required ProfileProvider provider}) {
    final durationText = getWorkDurationFromString(
      provider.profileModel?.joiningDate?.date,
    );

    return appViewEffect(
      child: Column(
        spacing: 8,
        children: [
          _builBasicRowInfo(
            label: "Department",
            titleText: provider.profileModel?.department?.name ?? '-',
          ),
          _builBasicRowInfo(
            label: "Designation",
            titleText: provider.profileModel?.designation?.name ?? '-',
          ),
          _builBasicRowInfo(
            label: "Batch",
            titleText: provider.profileModel?.location?.name ?? '-',
          ),
          _builBasicRowInfo(
            label: "Reports To",
            titleText: [
              provider.profileModel?.reportTo?.firstname ?? "-",
              provider.profileModel?.reportTo?.lastname ?? "",
            ].where((e) => e.isNotEmpty).join(" ").trim(),
          ),
          _builBasicRowInfo(
            label: "Joining Date",
            titleText: convertDate(
              provider.profileModel?.joiningDate?.date,
              format: "dd-MMM-yyyy",
            ),
          ),
          _builBasicRowInfo(
            label: "Probation End Date",
            titleText: convertDate(
              provider.profileModel?.probationEndDate?.date,
              format: "dd-MMM-yyyy",
            ),
          ),
          _builBasicRowInfo(label: "Work Duration", titleText: durationText),
        ],
      ),
    );
  }

  Widget _buildContactInfo({required ProfileProvider provider}) {
    return appViewEffect(
      child: Column(
        spacing: 8,
        children: [
          _builBasicRowInfo(
            label: "Mobile Phone",
            titleText: provider.profileModel?.contactNo ?? '-',
          ),
          _builBasicRowInfo(
            label: "Emergency Contact",
            titleText: provider.profileModel?.emergencyContactNo ?? '-',
          ),
          _builBasicRowInfo(
            label: "Emergency Person",
            titleText: provider.profileModel?.emergencyContactPerson ?? '-',
          ),
          _builBasicRowInfo(
            label: "Current Address",
            titleText: provider.profileModel?.address ?? '-',
          ),
          _builBasicRowInfo(
            label: "Permanent Address",
            titleText: provider.profileModel?.perAddress ?? '-',
          ),
        ],
      ),
    );
  }

  Widget _buildDocuments({required ProfileProvider provider}) {
    return appViewEffect(
      child: Column(
        spacing: 8,
        children: [
          _builBasicRowInfo(
            label: "Driving License",
            titleText: provider.profileModel?.drivingLicenseNumber ?? '-',
          ),
          _builBasicRowInfo(
            label: "PAN Number",
            titleText: provider.profileModel?.panNumber ?? '-',
          ),
          _builBasicRowInfo(
            label: "Aadhar Number",
            titleText: provider.profileModel?.aadharNumber ?? '-',
          ),
          _builBasicRowInfo(
            label: "Voter ID Number",
            titleText: provider.profileModel?.voterIdNumber ?? '-',
          ),
          _builBasicRowInfo(
            label: "UAN Number",
            titleText: provider.profileModel?.uanNumber ?? '-',
          ),
          _builBasicRowInfo(
            label: "PF Number",
            titleText: provider.profileModel?.pfNumber ?? '-',
          ),
          _builBasicRowInfo(
            label: "ESIC Number",
            titleText: provider.profileModel?.esicNumber ?? '-',
          ),
        ],
      ),
    );
  }

  Widget _buildSocial({required ProfileProvider provider}) {
    return appViewEffect(
      child: Column(
        spacing: 8,
        children: [
          _builBasicRowInfo(
            label: "Slack username",
            titleText: provider.profileModel?.slackUsername ?? '-',
          ),
          _builBasicRowInfo(
            label: "Facebook username",
            titleText: provider.profileModel?.facebookUsername ?? '-',
          ),
          _builBasicRowInfo(
            label: "Twitter username",
            titleText: provider.profileModel?.twitterUsername ?? '-',
          ),
          _builBasicRowInfo(
            label: "LinkedIn username",
            titleText: provider.profileModel?.linkdinUsername ?? '-',
          ),
        ],
      ),
    );
  }

  Widget _builBasicRowInfo({required String label, required String titleText}) {
    return appViewEffect(
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          loadTitleText(title: label, fontWight: FontWeight.w500, fontSize: 12),
          Expanded(
            child: loadSubText(
              title: titleText,
              textAlign: TextAlign.end,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
