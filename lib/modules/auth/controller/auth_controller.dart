import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/config/routes/app_pages.dart';
import 'package:flutter_supabase_auth/config/theme/app_theme.dart';
import 'package:flutter_supabase_auth/core/service/supabase_service.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  //* Variables Sections *
  var isPasswordVisible = false.obs;
  var isPasswordFilled = false.obs;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  var isPasswordValid = false.obs;
  final supabase = SupabaseService.client;
  var isLoading = false.obs;
  //------------------------------------------//

  //* Functions and Methods Section *
  //! Toggle Password Visibility
  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  //! Toggle Password Filled
  void togglePasswordFilled(String value) {
    isPasswordFilled.value = value.isNotEmpty;
  }

  //! Validate Password Strength
  void checkPassword(String value) {
    isPasswordFilled.value = value.isNotEmpty;
    isPasswordValid.value = value.length >= 8;
  }

  //! Clear Form Fields
  void clearForm() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    isPasswordFilled.value = false;
    isPasswordVisible.value = false;
    isPasswordValid.value = true;
  }

  //! Sign Up Method
  Future<void> signUp() async {
    try {
      isLoading.value = true;
      Get.dialog(
        Center(
          child: Container(
            width: 240,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.transparent),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  "assets/lotties/Sandy Loading.json",
                  width: 170,
                  height: 170,
                ),
                Text(
                  "Creating Account...",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
      await Future.delayed(Duration(seconds: 2));
      final fullName = fullNameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {"full_name": fullName},
      );
      final user = response.user;
      if (user != null) {
        await supabase.from("profiles").upsert({
          'id': user.id,
          'email': email,
          'full_name': fullName,
          'phone': '',
          'role': '',
          'address': '',
          'avatar_url': '',
        });
      }
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Future.delayed(Duration(milliseconds: 300), () {
        Get.snackbar(
          "Sign Up Successful",
          "Your account has been created successfully.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      });
      clearForm();
      RouteView.signIn.go(clearAll: true);
    } on AuthApiException catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      if (e.code == 'invalid_password') {
        Get.snackbar(
          'Password Too Weak',
          'Password must be at least 8 characters long.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (e.code == 'email_already_exists') {
        Get.snackbar(
          'Email Exists',
          'The email address is already in use by another account.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Sign Up Failed",
          e.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.snackbar(
        "Sign Up Failed",
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  //! Sign In Method
  Future<void> signIn() async {
    try {
      isLoading.value = true;
      await Future.delayed(Duration(seconds: 2));
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      await supabase.auth.signInWithPassword(email: email, password: password);
      Get.snackbar(
        "Sign In",
        "Welcome back! You have signed in successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      emailController.clear();
      passwordController.clear();
      RouteView.profile.go(clearAll: true);
    } on AuthApiException catch (e) {
      if (e.code == 'invalid_credentials') {
        Get.snackbar(
          'Login Failed',
          'Wrong email or password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Sign In Failed",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  //! Sign Out Method
  Future<void> signOut() async {
    final result = await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        backgroundColor: AppTheme.lightBg,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Logout",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "Are you sure you want to log out?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back(result: false);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(result: true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    if (result != true) return;
    try {
      isLoading.value = true;
      await supabase.auth.signOut();
      await Future.delayed(Duration(seconds: 1));
      Get.snackbar(
        'Logout',
        'You have been logged out successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      RouteView.signIn.go(clearAll: true);
    } catch (e) {
      Get.snackbar(
        "Sign Out Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  //! Check if User is Logged In Function
  bool get isLoggedIn {
    return supabase.auth.currentUser != null;
  }

  //! Forgot Password Method
  Future<void> forgotPassword() async {
    try {
      final email = emailController.text.trim();
      if (email.isEmpty) {
        Get.snackbar(
          'Email Required',
          'Please enter your email address to reset password.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: "http://supabaseauth.com",
      );
      Get.snackbar(
        'Reset Email Sent',
        'Please check your email to reset your password.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on AuthApiException catch (e) {
      Get.snackbar(
        'Reset Failed',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Reset Failed",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
