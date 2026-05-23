import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/config/theme/app_theme.dart';
import 'package:flutter_supabase_auth/modules/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

class EditProfileView extends GetView<ProfileController> {
  EditProfileView({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    controller.setEditFormData();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(bottom: false, child: _buildBody),
      ),
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
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Center(
          child: Form(
            key: _formKey,
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
                            data?.avatarUrl != null &&
                                data!.avatarUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: data.avatarUrl,
                                width: 130,
                                height: 130,
                                cacheKey: data.avatarUrl,
                                key: ValueKey(data.avatarUrl),
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
                          return controller.isAvatarLoading.value
                              ? Center(
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(
                                      color: AppTheme.primary,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                )
                              : IconButton(
                                  onPressed:
                                      controller.showImagePickerBottomSheet,
                                  icon: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 45,
                                  ),
                                );
                        }),
                      ),
                    ),
                  ],
                ),
                _buildTextAlign('Full Name'),
                SizedBox(height: 8),
                _buildTextField(
                  icon: Icons.person_outlined,
                  controller: controller.fullNameController,
                ),
                const SizedBox(height: 16),

                _buildTextAlign('Email'),
                const SizedBox(height: 8),
                _buildTextField(
                  icon: Icons.email_outlined,
                  controller: controller.emailController,
                  enabled: false,
                ),
                const SizedBox(height: 16),

                _buildTextAlign('Phone'),
                const SizedBox(height: 8),
                _buildTextField(
                  icon: Icons.phone_outlined,
                  hintText: '012 345 6789',
                  controller: controller.phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                _buildTextAlign('Role'),
                const SizedBox(height: 8),
                _buildTextField(
                  icon: Icons.work_outline,
                  hintText: 'Enter your role',
                  controller: controller.roleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Role is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                _buildTextAlign('Address'),
                const SizedBox(height: 8),
                _buildTextField(
                  icon: Icons.home_outlined,
                  hintText: 'Enter your address',
                  controller: controller.addressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Address is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: controller.isUpdatingLoading.value
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              controller.updateProfile();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.isUpdatingLoading.value
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: AppTheme.primary,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            'Update Profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  //! Build TextFormField Widget
  Widget _buildTextField({
    required IconData icon,
    required TextEditingController controller,
    bool enabled = true,
    String hintText = '',
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      cursorColor: AppTheme.primary,
      cursorWidth: 2,
      style: TextStyle(
        color: enabled ? AppTheme.darkBg : Colors.grey,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: enabled ? Colors.grey : Colors.grey.shade400,
          fontSize: 16,
        ),
        prefixIcon: Icon(
          icon,
          size: 28,
          color: enabled ? AppTheme.darkBg : Colors.grey,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: enabled
                ? const Color.fromARGB(255, 219, 218, 218)
                : Colors.grey.shade400,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: enabled ? AppTheme.primary : Colors.grey.shade400,
            width: 1,
          ),
        ),
      ),
    );
  }

  //! Build TextAlign Widget
  Widget _buildTextAlign(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
