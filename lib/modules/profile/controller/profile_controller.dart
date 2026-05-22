import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/core/service/supabase_service.dart';
import 'package:flutter_supabase_auth/modules/profile/model/profile_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  //* Variables Sections *
  final supabase = SupabaseService.client;
  var isLoading = false.obs;
  var isAvatarLoading = false.obs;
  var isUpdatingLoading = false.obs;

  final Rxn<ProfileModel> profile = Rxn<ProfileModel>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final roleController = TextEditingController();
  final addressController = TextEditingController();
  //------------------------------------------//

  //! Lifecycle Section *
  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    roleController.dispose();
    addressController.dispose();
    super.onClose();
  }
  //------------------------------------------//

  //* Functions and Methods Section *

  //! Get Profile
  Future<void> getProfile() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      final user = supabase.auth.currentUser;
      if (user == null || user.id.isEmpty) return;
      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      if (data == null) {
        await supabase.from('profiles').insert({
          'id': user.id,
          'email': user.email ?? '',
          'full_name': user.userMetadata?['full_name'] ?? '',
          'phone': '',
          'role': '',
          'address': '',
          'avatar_url': '',
        });
        await getProfile();
        return;
      }
      profile.value = ProfileModel.fromMap(data);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  //! Set Edit Form Data
  void setEditFormData() {
    final data = profile.value;
    fullNameController.text = data?.fullName ?? '';
    emailController.text = data?.email ?? '';
    phoneController.text = data?.phone ?? '';
    roleController.text = data?.role ?? '';
    addressController.text = data?.address ?? '';
  }

  //! Update Profile
  Future<void> updateProfile() async {
    try {
      isUpdatingLoading.value = true;
      final user = supabase.auth.currentUser;
      if (user == null || user.id.isEmpty) return;
      await supabase
          .from('profiles')
          .update({
            'full_name': fullNameController.text,
            'phone': phoneController.text,
            'role': roleController.text,
            'address': addressController.text,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', user.id);
      await getProfile();
      Get.back();
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Update Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isUpdatingLoading.value = false;
    }
  }

  //! Pick and Upload Avatar
  Future<void> pickAndUploadAvatar() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null || user.id.isEmpty) return;
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (pickedImage == null) return;
      isAvatarLoading.value = true;
      final filePath = 'avatar_${user.id}.jpg';
      final file = File(pickedImage.path);
      await supabase.storage.from('avatars').remove([filePath]);
      await supabase.storage
          .from('avatars')
          .upload(
            filePath,
            file,
            fileOptions: FileOptions(upsert: true, cacheControl: '0'),
          );
      final imageUrl =
          '${supabase.storage.from('avatars').getPublicUrl(filePath)}?v=${DateTime.now().millisecondsSinceEpoch}';
      await supabase
          .from('profiles')
          .update({
            'avatar_url': imageUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', user.id);
      await getProfile();
      Get.snackbar(
        'Success',
        'Avatar uploaded successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Avatar Upload Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isAvatarLoading.value = false;
    }
  }
}
