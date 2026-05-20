import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/config/theme/app_theme.dart';
import 'package:flutter_supabase_auth/modules/auth/controller/auth_controller.dart';
import 'package:get/get.dart';
import '../controller/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  //! AuthController Initialization
  AuthController get authController => Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar, body: _buildBody);
  }

  //! Build Appbar
  AppBar get _buildAppBar {
    return AppBar(
      title: const Text("Profile View"),
      actions: [
        Obx(() {
          return IconButton(
            onPressed: authController.isLoading.value
                ? null
                : () => authController.signOut(),
            icon: authController.isLoading.value
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppTheme.primary,
                    ),
                  )
                : const Icon(Icons.logout),
          );
        }),
      ],
    );
  }

  //! Build Body
  Widget get _buildBody {
    return const Center(child: Text("Profile View"));
  }
}
