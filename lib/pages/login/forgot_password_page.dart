import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/string_constant.dart';
import 'package:neeknots_admin/core/constants/validations.dart';
import 'package:neeknots_admin/provider/login_provider.dart';
import 'package:neeknots_admin/utility/image_utils.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formLoginKey = GlobalKey<FormState>();
    return AppScaffold(
      appTitle: "FORGOT PASSWORD",
      child: Consumer<LoginProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Center(
                  child: Column(
                    children: [
                      loadAssetImage(name: applogo, height: 128),
                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: appGradientText(
                          text: "Enter your email to reset password",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          gradient: appGradient(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Form(
                        key: formLoginKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            appOrangeTextField(
                              hintText: "Employee email",
                              icon: commonPrefixIcon(image: icEmail),
                              textController: provider.emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: validateEmail,
                            ),
                            const SizedBox(height: 32),
                            gradientButton(
                              title: "SEND RESET LINK",
                              onPressed: () async {
                                hideKeyboard(context);

                                if (formLoginKey.currentState!.validate()) {
                                  Map<String, dynamic> body = {
                                    "email": provider.emailController.text
                                        .trim(),
                                  };
                                  await provider.forgotpassword(body: body);
                                  if (!context.mounted) return;
                                  if (provider.loginSuccess) {
                                    showSnackBar(
                                      context,
                                      message:
                                          "Password reset link has been sent to your email address",
                                      bgColor: Colors.green,
                                    );
                                    Future.delayed(
                                      const Duration(seconds: 2),
                                      () {
                                        if (!context.mounted) return;
                                        Navigator.pop(context);
                                      },
                                    );
                                  } else {
                                    showSnackBar(
                                      context,
                                      message:
                                          provider.errorMessage ??
                                          "User not found with this email address",
                                      bgColor: Colors.redAccent,
                                    );
                                  }
                                }
                              },
                            ),
                            const SizedBox(height: 8),
                            loadSubText(title: "Please confirm email address"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              provider.isLoading ? showProgressIndicator() : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}
