import 'package:flutter/material.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/provider/app_provider.dart';
import 'package:neeknots_admin/screens/employee_screen.dart';
import 'package:neeknots_admin/screens/manager_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initApp();
    });
  }

  Future<void> initApp() async {
    await Provider.of<AppProvider>(
      context,
      listen: false,
    ).loadAppDataFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            Column(
              spacing: 8,
              children: [
                if (provider.isRole != "employee") topBar(context),
                provider.isManager
                    ? Expanded(child: ManagerScreen())
                    : Expanded(
                        child: EmployeeScreen(
                          employeeId: provider.employeeId ?? '',
                        ),
                      ),
              ],
            ),

            // if (provider.isRole != "employee") topBar(context),
          ],
        );
      },
    );
  }

  Widget topBar(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return Container(
      padding: EdgeInsets.only(top: 8),
      margin: const EdgeInsets.symmetric(horizontal: 48),
      child: appViewEffect(
        padding: const EdgeInsets.symmetric(vertical: 12),
        borderRadius: 45,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          spacing: 32,
          children: [
            _buildBottomIcon(
              context,
              whoIs: !provider.isManager,
              icon: Icons.person_outline,
              title: "SELF",
              onTap: () =>
                  context.read<AppProvider>().setIsManagerOrSelf(false),
            ),
            _buildBottomIcon(
              context,
              whoIs: provider.isManager,
              icon: Icons.people_outline,
              title: "MANAGER",
              onTap: () => context.read<AppProvider>().setIsManagerOrSelf(true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomIcon(
    BuildContext context, {
    required bool whoIs,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    double? size = 20,
  }) {
    final isSelected = whoIs;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Row(
          spacing: 4,
          children: [
            appCircleIcon(
              icon: icon,
              iconSize: size, // ✅ selected = gradient, unselected = grey
              gradient: isSelected ? appGradient() : appOffGradient(),
            ),
            appGradientText(
              text: title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
              gradient: isSelected ? appGradient() : appOffGradient(),
            ),
          ],
        ),
      ),
    );
  }
}
