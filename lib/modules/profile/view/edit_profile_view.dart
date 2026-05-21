import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/config/theme/app_theme.dart';
import 'package:flutter_supabase_auth/modules/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.setEditFormData();
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(child: _buildBody),
    );
  }

  //! Build AppBar
  AppBar _buildAppBar() {
    return AppBar(title: const Text('Edit Profile'));
  }

  //! Build Body
  Widget get _buildBody {
    return Obx(() {
      final data = controller.profile.value;
      return SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 194, 193, 193),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child:
                          data?.avatarUrl != null && data!.avatarUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: data.avatarUrl,
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: Icon(
                                  Icons.person,
                                  size: 75,
                                  color: Colors.white70,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 75,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 75,
                              color: Colors.white70,
                            ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: Obx(() {
                        return controller.isLoading.value
                            ? SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppTheme.primary,
                                ),
                              )
                            : IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  controller.pickAndUploadAvatar();
                                },
                              );
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
