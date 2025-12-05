import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/constants/image_utils.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/provider/profile_provider.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:provider/provider.dart';

import '../../provider/profile_provider.dart';
import '../constants/date_utils.dart';
import '../constants/string_utils.dart';
import 'cached_image_widget.dart';

class UserDetailsByIdView extends StatefulWidget {
  const UserDetailsByIdView({super.key, this.id});

  final String? id;
  @override
  State<UserDetailsByIdView> createState() => _UserDetailsByIdViewState();
}

class _UserDetailsByIdViewState extends State<UserDetailsByIdView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  Future<void> init() async {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    Map<String, dynamic> body = {"employee_id": widget.id};
    await profile.getUserProfile(body: body);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(

      builder: (context, provider, child) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    /*  CachedImageWidget(
                        height: 120,
                        width: 120,
                        borderRadius: 100,

                        fit: BoxFit.cover,
                        imageUrl:
                            provider.userDetailsBYIDModel?.profileImage ?? '',
                      ),*/
                      SizedBox(height: 10),
                      loadTitleText(
                        title:
                            '${provider.profileModel?.firstname} ${provider.profileModel?.lastname}',
                        fontSize: 16,
                        fontWight: FontWeight.w700,
                      ),
                      loadSubText(
                        title: '${provider.profileModel?.companyEmail}',
                        fontSize: 12,
                        fontWight: FontWeight.w400,
                      ),
                      SizedBox(height: 20),

                      provider.profileModel?.about==null?SizedBox.shrink():bioInfoWidget(provider: provider),
                      SizedBox(height: 10),
                      basicInfoWidget(provider: provider),
                      SizedBox(height: 10),
                      //showContactInfoWidget(provider: provider),
                      SizedBox(height: 40),
                    ],
                  ),
                ],
              ),
            ),
            provider.isLoading ? showProgressIndicator() : SizedBox.shrink(),
          ],
        );
      },
    );
  }

  Widget basicInfoWidget({required ProfileProvider provider}) {
    var data = provider.profileModel;

    return commonBoxView(
      contentView: Column(
        spacing: 12,

        children: [
          commonRowLeftRightView(
            title: 'Employee ID',
            customView: loadSubText(
              title: data?.employeeId ?? "-",
              textAlign: TextAlign.right,
              fontSize: 12,
              fontWight: FontWeight.w600,
            ),
          ),

          commonRowLeftRightView(
            title: 'DOB',
            value: formatDate(
              data?.dateOfBirth?.date ?? '',
              format: "dd-MM-yyyy",
            ),
          ),
          commonRowLeftRightView(
            title: 'Status',
            customView: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: commonBoxDecoration(
                    borderRadius: 5,
                    borderColor: data?.userExitStatus == true
                        ? Colors.green
                        : Colors.red,
                    borderWidth: 0.5,

                    color: data?.userExitStatus == true
                        ? Colors.green.withValues(alpha: 0.10)
                        : Colors.red.withValues(alpha: 0.10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                  child: loadSubText(
                    title: data?.userExitStatus == true ? "Active" : "Inactive",
                    textAlign: TextAlign.right,
                    fontColor: data?.userExitStatus == true
                        ? Colors.green
                        : Colors.red,
                    fontSize: 10,
                    fontWight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          commonRowLeftRightView(
            title: 'External System Access',
            value: data?.userExitStatus == true ? "Yes" : "NO",
          ),

          commonRowLeftRightView(
            title: 'Work duration',
            value: data?.companyEmail ?? "-",
          ),

          commonRowLeftRightView(
            title: 'Company Email',
            value: data?.companyEmail ?? "-",
          ),
          commonRowLeftRightView(
            title: 'Emergency Contact',
            value: data?.emergencyContactNo ?? '',
          ),
        ],
      ),
      title: 'Basic Information',
    );
  }

  Widget bioInfoWidget({required ProfileProvider provider}) {
    var data = provider.profileModel;

    return commonBoxView(
      contentView: Column(
        children: [
          Html(
            data: data?.about ?? '',
            style: {
              "html": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
              "body": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
              "p": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
              "span": Style(
                fontSize: FontSize(12),
                fontFamily: fontRoboto,
                color: Colors.black,
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
              "div": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
            },
          ),
        ],
      ),
      title: 'Bio Information',
    );
  }

/*  Widget showContactInfoWidget({required ProfileProvider provider}) {
    var data = provider.userContactViewModel;

    return commonBoxView(
      contentView: Column(
        spacing: 8,

        children: [
          commContactView(
            image: icCall,

            customView: commonText(
              text: data?.data?.contactNo ?? "-",
              textAlign: TextAlign.left,
              fontSize: 12,

            ),
          ),

          commContactView(image: icEmail, value: data?.data?.email ?? "-"),
          commContactView(
            image: icLinkedin,
            value: data?.data?.linkdinUsername ?? "-",
          ),

          commContactView(
            image: icTwitter,
            value: data?.data?.twitterUsername ?? "-",
          ),
          commContactView(
            image: icFacebook,
            value: data?.data?.facebookUsername ?? "-",
          ),
        ],
      ),
      title: 'Show Contact Info',
    );
  }*/

  Widget commContactView({
    required String image,
    String? value,
    Widget? customView,
  }) {
    return Row(
      spacing: 10,
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: commonBoxDecoration(
            shape: BoxShape.circle,
            // /  color: colorProduct.withValues(alpha: 0.2)
          ),
          child: Center(
            child: commonAssetImage(
              image,
              width: 15,
              height: 15,
              color: color3,
            ),
          ),
        ),
        Expanded(
          child:
              customView ??
              loadSubText(
                title: value ?? '',
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                fontWight: FontWeight.w400,
                fontSize: 12,
              ),
        ),
      ],
    );
  }
}
