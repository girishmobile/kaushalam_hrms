import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/string_constant.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

import '../../core/constants/validations.dart';
import '../../models/user_model.dart';
import '../../provider/login_provider.dart';
import '../../utility/secure_storage.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return AppScaffold(
      child: Consumer<LoginProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              Form(
                key: formKey,
                child: ListView(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: appTopPadding(context),
                    bottom: appBottomPadding(context),
                  ),
                  children: [
                    loadAssetImage(name: applogo, height: 128),
                    const SizedBox(height: 32),
                    loadSubText(title: "Current Password"),
                    SizedBox(height: 8),
                    appOrangeTextField(
                      hintText: "Enter your current password",

                      icon: Icons.lock_outline,
                      keyboardType: TextInputType.visiblePassword,
                      textController: provider.tetCurrentPassword,
                      isPassword: true,
                      obscure: provider.obscureCurrentPassword,
                      onTogglePassword: () => provider.toggleCurrentPassword(),
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 16),
                    loadSubText(title: "New Password"),
                    SizedBox(height: 8),
                    appOrangeTextField(
                      hintText: "Enter your new password",

                      icon: Icons.lock_outline,
                      keyboardType: TextInputType.visiblePassword,
                      textController: provider.tetNewPassword,
                      isPassword: true,
                      obscure: provider.obscureNewPassword,
                      onTogglePassword: () => provider.toggleNewPassword(),
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 16),
                    loadSubText(title: "Confirm Password"),
                    SizedBox(height: 8),
                    /*appOrangeTextField(
                      hintText: "Enter your confirm pasword",
                      icon: Icons.lock_outline,
                    ),*/
                    appOrangeTextField(
                      hintText: "Enter your confirm password",

                      icon: Icons.lock_outline,
                      keyboardType: TextInputType.visiblePassword,
                      textController: provider.tetConfirmPassword,
                      isPassword: true,
                      obscure: provider.obscureConfirmPassword,
                      onTogglePassword: () => provider.togglePassword(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Confirm password is required";
                        } else if (value != provider.tetNewPassword.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Login Button
                    gradientButton(
                      title: "UPDATE",
                      onPressed: () async {
                        UserModel? user = await SecureStorage.getUser();

                        hideKeyboard(context);
                        if (formKey.currentState?.validate() ?? false) {
                          Map<String, dynamic> body = {
                            "id": user?.id,
                            "password": provider.tetCurrentPassword.text.trim(),
                            "new_password": provider.tetNewPassword.text.trim(),
                            "confirm_new_password": provider
                                .tetConfirmPassword
                                .text
                                .trim(),
                          };

                          await provider.updatePassword(
                            body: body,
                            context: context,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              appNavigationBar(
                title: "CHANGE PASSWORD",
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              provider.isLoading?showProgressIndicator():SizedBox.shrink()
            ],
          );
        },
      ),
    );
  }
}
