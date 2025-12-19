import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/provider/emp_detail_provider.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class EmployeeDetailPage extends StatelessWidget {
  final String employeeId;

  const EmployeeDetailPage({required this.employeeId, super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Map<String, dynamic> body = {"employee_id": employeeId};
      context.read<EmpDetailProvider>().getEmployeeProfile(body: body);
    });

    return AppScaffold(

      appTitle: "Employee Details" ,
      child: Consumer<EmpDetailProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              ListView(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 0,
                ),
                children: [
                  appProfileImage(
                    onTap: () {
                      print('---assassa');
                      openProfileDialog(
                        context: context,
                        imageUrl: '${ setImagePath(
                          provider.employeeModel?.profileImage,
                        )}',
                        name: provider.employeeModel?.firstname ?? '',
                      );
                    },

                    text: provider.employeeModel?.firstname ?? '',
                    isEdit: false,
                    context: context,
                    imageUrl: setImagePath(
                      provider.employeeModel?.profileImage,
                    ),
                    radius: 60,
                  ),
                  SizedBox(height: 16),
                  loadTitleText(
                    title:
                        "${provider.employeeModel?.firstname ?? ''} ${provider.employeeModel?.lastname ?? ''}",
                    textAlign: TextAlign.center,
                  ),
                  loadSubText(
                    title: provider.employeeModel?.designation?.name ?? '',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
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
                ],
              ),
             /* appNavigationBar(
                title: "Employee Details",
                onTap: () {
                  Navigator.pop(context);
                },
              ),*/
              provider.isLoading ? showProgressIndicator() : SizedBox.shrink(),
            ],
          );
        },
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

  Widget _buildPersonalInfo({required EmpDetailProvider provider}) {
    return appViewEffect(
      child: Column(
        spacing: 8,
        children: [
          _builBasicRowInfo(
            label: "Full Name",
            titleText: provider.employeeModel?.firstname != null
                ? "${provider.employeeModel?.firstname} ${provider.employeeModel?.lastname}"
                : '',
          ),
          _builBasicRowInfo(
            label: "Employee ID",
            titleText: provider.employeeModel?.employeeId != null
                ? "${provider.employeeModel?.employeeId}"
                : '',
          ),
          _builBasicRowInfo(
            label: "Per Email",
            titleText: provider.employeeModel?.email ?? '-',
          ),
          _builBasicRowInfo(
            label: "Com Email",
            titleText: provider.employeeModel?.companyEmail ?? '-',
          ),
          _builBasicRowInfo(
            label: "Gender",
            titleText: provider.employeeModel?.gender?.valueText ?? '',
          ),
          _builBasicRowInfo(
            label: "Birthday",
            titleText: convertDate(
              provider.employeeModel?.dateOfBirth?.date,
              format: "dd-MMM-yyyy",
            ),
          ),
          _builBasicRowInfo(
            label: "Blood Group",
            titleText: provider.employeeModel?.bloodGroup ?? '-',
          ),
          _builBasicRowInfo(
            label: "Marital Status",
            titleText: (provider.employeeModel?.maritalStatus ?? false)
                ? "Married"
                : "Single",
          ),
          _builBasicRowInfo(
            label: "Status",
            titleText: (provider.employeeModel?.userExitStatus ?? false)
                ? "Active"
                : "Inactive",
          ),

          _builBasicRowInfo(
            label: "External System Access",
            titleText: (provider.employeeModel?.allowedLogin ?? false)
                ? "Yes"
                : "No",
          ),
        ],
      ),
    );
  }

  Widget _buildCompnayInfo({required EmpDetailProvider provider}) {
    final durationText = getWorkDurationFromString(
      provider.employeeModel?.joiningDate?.date,
    );

    return appViewEffect(
      child: Column(
        spacing: 8,
        children: [
          _builBasicRowInfo(
            label: "Department",
            titleText: provider.employeeModel?.department?.name ?? '-',
          ),
          _builBasicRowInfo(
            label: "Designation",
            titleText: provider.employeeModel?.designation?.name ?? '-',
          ),
          _builBasicRowInfo(
            label: "Batch",
            titleText: provider.employeeModel?.location?.name ?? '-',
          ),
          _builBasicRowInfo(
            label: "Reports To",
            titleText: [
              provider.employeeModel?.reportTo?.firstname ?? "-",
              provider.employeeModel?.reportTo?.lastname ?? "",
            ].where((e) => e.isNotEmpty).join(" ").trim(),
          ),
          _builBasicRowInfo(
            label: "Joining Date",
            titleText: convertDate(
              provider.employeeModel?.joiningDate?.date,
              format: "dd-MMM-yyyy",
            ),
          ),
          _builBasicRowInfo(
            label: "Probation End Date",
            titleText: convertDate(
              provider.employeeModel?.probationEndDate?.date,
              format: "dd-MMM-yyyy",
            ),
          ),
          _builBasicRowInfo(label: "Work Duration", titleText: durationText),
        ],
      ),
    );
  }

  Widget _buildContactInfo({required EmpDetailProvider provider}) {
    return appViewEffect(
      child: Column(
        spacing: 8,
        children: [
          _builBasicRowInfo(
            label: "Mobile Phone",
            titleText: provider.employeeModel?.contactNo ?? '-',
          ),
          _builBasicRowInfo(
            label: "Emergency Contact",
            titleText: provider.employeeModel?.emergencyContactNo ?? '-',
          ),
          _builBasicRowInfo(
            label: "Emergency Person",
            titleText: provider.employeeModel?.emergencyContactPerson ?? '-',
          ),
          _builBasicRowInfo(
            label: "Current Address",
            titleText: provider.employeeModel?.address ?? '-',
          ),
          _builBasicRowInfo(
            label: "Permanent Address",
            titleText: provider.employeeModel?.perAddress ?? '-',
          ),
        ],
      ),
    );
  }

  Widget _buildDocuments({required EmpDetailProvider provider}) {
    return appViewEffect(
      child: Column(
        spacing: 8,
        children: [
          _builBasicRowInfo(
            label: "Driving License",
            titleText: maskShow(
              provider.employeeModel?.drivingLicenseNumber ?? '-',
            ),
          ),
          _builBasicRowInfo(
            label: "PAN Number",
            titleText: maskShow(provider.employeeModel?.panNumber ?? '-'),
          ),
          _builBasicRowInfo(
            label: "Aadhar Number",
            titleText: maskShow(provider.employeeModel?.aadharNumber ?? '-'),
          ),
          _builBasicRowInfo(
            label: "Voter ID Number",
            titleText: maskShow(provider.employeeModel?.voterIdNumber ?? '-'),
          ),
          _builBasicRowInfo(
            label: "UAN Number",
            titleText: maskShow(provider.employeeModel?.uanNumber ?? '-'),
          ),
          _builBasicRowInfo(
            label: "PF Number",
            titleText: maskShow(provider.employeeModel?.pfNumber ?? '-'),
          ),
          _builBasicRowInfo(
            label: "ESIC Number",
            titleText: maskShow(provider.employeeModel?.esicNumber ?? '-'),
          ),
        ],
      ),
    );
  }

  Widget _buildSocial({required EmpDetailProvider provider}) {
    return appViewEffect(
      child: Column(
        spacing: 8,
        children: [
          _builBasicRowInfo(
            label: "Slack username",
            titleText: provider.employeeModel?.slackUsername ?? '-',
          ),
          _builBasicRowInfo(
            label: "Facebook username",
            titleText: provider.employeeModel?.facebookUsername ?? '-',
          ),
          _builBasicRowInfo(
            label: "Twitter username",
            titleText: provider.employeeModel?.twitterUsername ?? '-',
          ),
          _builBasicRowInfo(
            label: "LinkedIn username",
            titleText: provider.employeeModel?.linkdinUsername ?? '-',
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
