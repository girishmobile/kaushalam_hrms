import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/string_constant.dart';
import 'package:neeknots_admin/core/constants/validations.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/provider/login_provider.dart';
import 'package:neeknots_admin/utility/top_snack_bar.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formLoginKey = GlobalKey<FormState>();

    return AppScaffold(
      child: Consumer<LoginProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            loadAssetImage(name: applogo, height: 128),
                            const SizedBox(height: 32),
                            Align(
                              alignment: Alignment.center,
                              child: appGradientText(
                                text: "WELCOME BACK!",
                                style: TextStyle(
                                  fontSize: 18,
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
                                  // Logo
                                  appOrangeTextField(
                                    hintText: "Employee email",
                                    icon: Icons.email_outlined,
                                    textController: provider.emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: validateEmail,
                                  ),
                                  const SizedBox(height: 16),
                                  appOrangeTextField(
                                    hintText: "Password",
                                    icon: Icons.lock_outline,
                                    keyboardType: TextInputType.visiblePassword,
                                    textController: provider.passwordController,
                                    isPassword: true,
                                    obscure: provider.obscurePassword,
                                    onTogglePassword: () =>
                                        provider.togglePassword(),
                                    validator: validatePassword,
                                  ),
                                  const SizedBox(height: 16),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () => {
                                        Navigator.pushNamed(
                                          context,
                                          RouteName.forgotPasswordPage,
                                        ),
                                      },
                                      child: Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  // Login Button
                                  gradientButton(
                                    title: "LOGIN",
                                    onPressed: () async {
                                      hideKeyboard(context);

                                      if (formLoginKey.currentState!
                                          .validate()) {
                                        Map<String, dynamic> body = {
                                          "email": provider.emailController.text
                                              .trim(),
                                          "password": provider
                                              .passwordController
                                              .text
                                              .trim(),
                                          "isLogin": "1",
                                          "uuid": Utils.generateUUID(),
                                        };
                                        await provider.loginApi(body: body);
                                        if (!context.mounted) return;
                                        if (provider.loginSuccess) {
                                          showSnackBar(
                                            context,
                                            message: "Login Sccussful",
                                            bgColor: Colors.green,
                                          );
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            RouteName.dashboardScreen,
                                            (route) => false,
                                          );
                                        } else {
                                          showSnackBar(
                                            context,
                                            message:
                                                provider.errorMessage ??
                                                "Invalid credentials",
                                            bgColor: Colors.redAccent,
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "© 2025 Kaushalam Inc",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              provider.isLoading ? showProgressIndicator() : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}
