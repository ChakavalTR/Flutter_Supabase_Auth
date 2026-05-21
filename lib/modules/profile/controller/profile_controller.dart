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
  final Rxn<ProfileModel> profile = Rxn<ProfileModel>();
  final fullNameController = TextEditingController();
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
          .single();
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
    phoneController.text = data?.phone ?? '';
    roleController.text = data?.role ?? '';
    addressController.text = data?.address ?? '';
  }

  //! Update Profile
  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
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
      isLoading.value = false;
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
      isLoading.value = true;
      final filePath = '${user.id}/avatar.jpg';
      final file = File(pickedImage.path);
      await supabase.storage
          .from('avatars')
          .upload(filePath, file, fileOptions: FileOptions(upsert: true));
      final imageUrl = supabase.storage.from('avatars').getPublicUrl(filePath);
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
      isLoading.value = false;
    }
  }
}
