import 'package:flutter/material.dart';
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
        IconButton(
          onPressed: () {
            authController.signOut();
          },
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

  //! Build Body
  Widget get _buildBody {
    return const Center(child: Text("Profile View"));
  }
}
