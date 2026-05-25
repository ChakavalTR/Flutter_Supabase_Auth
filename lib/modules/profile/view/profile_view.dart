import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/config/theme/app_theme.dart';
import 'package:flutter_supabase_auth/modules/auth/controller/auth_controller.dart';
import 'package:flutter_supabase_auth/modules/profile/model/profile_model.dart';
import 'package:flutter_supabase_auth/modules/profile/view/edit_profile_view.dart';
import 'package:flutter_supabase_auth/modules/profile/view/full_screen_preview_view.dart';
import 'package:flutter_supabase_auth/widgets/shimmer/profile_shimmer_widget.dart';
import 'package:get/get.dart';
import '../controller/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  //! AuthController Initialization
  AuthController get authController => Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(top: false, bottom: false, child: _buildBody),
    );
  }

  //! Build Body
  Widget get _buildBody {
    return Obx(() {
      final data = controller.profile.value;
      if (controller.isLoading.value) {
        return const ProfileShimmerWidget();
      }
      return SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(data),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data?.fullName ?? '',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5),
                Icon(Icons.verified, color: AppTheme.primary, size: 22),
              ],
            ),
            SizedBox(height: 3),
            Text(
              data?.email ?? '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 80,
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(
                    () => EditProfileView(),
                    transition: Transition.native,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(134, 182, 182, 182),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildDataTile(
              icon: Icons.person,
              color: AppTheme.primary.withOpacity(0.8),
              title: 'Fullname',
              value: data?.fullName.isEmpty == true
                  ? 'Not Provided Yet'
                  : data?.fullName ?? '',
            ),
            _buildDataTile(
              icon: Icons.phone,
              color: Colors.green.withOpacity(0.8),
              title: 'Phone',
              value: data?.phone.isEmpty == true
                  ? 'Not Provided Yet'
                  : data?.phone ?? '',
            ),
            _buildDataTile(
              icon: Icons.workspace_premium,
              color: Colors.orange.withOpacity(0.8),
              title: 'Role',
              value: data?.role.isEmpty == true
                  ? 'Not Provided Yet'
                  : data?.role ?? '',
            ),
            _buildDataTile(
              icon: Icons.location_on,
              color: Colors.blue.withOpacity(0.8),
              title: 'Address',
              value: data?.address.isEmpty == true
                  ? 'Not Provided Yet'
                  : data?.address ?? '',
            ),
            SizedBox(height: 10),
            Text(
              'Last update: ${controller.formatLastUpdated(data?.updateAt)}',
              style: TextStyle(
                color: AppTheme.darkBg,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 70),
            Text('Version 1.1.0', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    });
  }

  //! Build Header Widget
  Widget _buildHeader(ProfileModel? data) {
    return SizedBox(
      height: 260,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00C6A7), AppTheme.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60),
              ),
            ),
            child: Align(
              alignment: const Alignment(0, -0.2),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    const Text(
                      'My Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Obx(() {
                      return IconButton(
                        padding: EdgeInsets.only(left: 10),
                        onPressed: authController.isLoading.value
                            ? null
                            : () => authController.signOut(),
                        icon: authController.isLoading.value
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: 28,
                              ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 120,
            child: GestureDetector(
              onTap: data?.avatarUrl != null && data!.avatarUrl.isNotEmpty
                  ? () {
                      Get.to(
                        () => FullScreenPreviewView(imageUrl: data.avatarUrl),
                        transition: Transition.fadeIn,
                      );
                    }
                  : null,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 194, 193, 193),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: data?.avatarUrl != null && data!.avatarUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: data.avatarUrl,
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                          key: ValueKey(data.avatarUrl),
                        )
                      : const Icon(
                          Icons.person,
                          size: 75,
                          color: Colors.white70,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //! Build Data Tile Widget
  Widget _buildDataTile({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 7),
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: AppTheme.lightBg,
        borderRadius: BorderRadius.circular(10),
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.lightBg, size: 40),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
