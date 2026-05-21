import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/config/theme/app_theme.dart';
import 'package:flutter_supabase_auth/widgets/animation/animation_background_widget.dart';
import 'package:flutter_supabase_auth/widgets/textfield/textfield_glass_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/auth_controller.dart';
import 'package:get/get.dart';

class SignUpView extends GetView<AuthController> {
  SignUpView({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(body: _buildBody),
    );
  }

  //! Build Body
  Widget get _buildBody {
    return Stack(
      children: [
        Positioned.fill(child: AnimationBackgroundWidget()),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withOpacity(0.25)),
          ),
        ),
        SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Text(
                            "Create an Account ✨",
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Join us and start your journey today",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: Colors.grey.withOpacity(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Full name",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        TextFieldGlassWidget(
                          child: TextFormField(
                            controller: controller.fullNameController,
                            cursorColor: AppTheme.primary,
                            cursorWidth: 2,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              hintText: "Enter your full name",
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                              ),
                              border: InputBorder.none,
                              errorStyle: const TextStyle(
                                color: Colors.redAccent, // change to any color
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your full name!";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        TextFieldGlassWidget(
                          child: TextFormField(
                            controller: controller.emailController,
                            cursorColor: AppTheme.primary,
                            cursorWidth: 2,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              hintText: "Enter your email",
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                              ),
                              border: InputBorder.none,
                              errorStyle: const TextStyle(
                                color: Colors.redAccent, // change to any color
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email!";
                              } else if (!GetUtils.isEmail(value)) {
                                return "Please enter a valid email!";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Obx(
                          () => TextFieldGlassWidget(
                            child: TextFormField(
                              controller: controller.passwordController,
                              cursorColor: AppTheme.primary,
                              cursorWidth: 2,
                              style: TextStyle(color: Colors.white),
                              obscureText: !controller.isPasswordVisible.value,
                              onChanged: controller.checkPassword,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                suffixIcon: controller.isPasswordFilled.value
                                    ? IconButton(
                                        onPressed:
                                            controller.togglePasswordVisibility,
                                        icon: Icon(
                                          controller.isPasswordVisible.value
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: Colors.white.withOpacity(0.5),
                                        ),
                                      )
                                    : null,
                                hintText: "Enter your password",
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                                errorStyle: const TextStyle(
                                  color:
                                      Colors.redAccent, // change to any color
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your password!";
                                } else if (value.length < 8) {
                                  return "Password must be at least 8 characters!";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Obx(
                          () => controller.isPasswordValid.value
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.only(left: 14),
                                  child: Row(
                                    spacing: 5,
                                    children: [
                                      Icon(
                                        Icons.verified_user_outlined,
                                        color: Colors.greenAccent.withOpacity(
                                          0.8,
                                        ),
                                        size: 21,
                                      ),
                                      Text(
                                        "Password must be at least 8 characters",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Confirm Password",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Obx(
                          () => TextFieldGlassWidget(
                            child: TextFormField(
                              controller: controller.confirmPasswordController,
                              cursorColor: AppTheme.primary,
                              cursorWidth: 2,
                              style: TextStyle(color: Colors.white),
                              obscureText: !controller.isPasswordVisible.value,
                              onChanged: controller.togglePasswordFilled,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please confirm your password!";
                                } else if (value !=
                                    controller.passwordController.text) {
                                  return "Passwords do not match!";
                                } else if (value.length < 8) {
                                  return "Password must be at least 8 characters!";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                suffixIcon: controller.isPasswordFilled.value
                                    ? IconButton(
                                        onPressed:
                                            controller.togglePasswordVisibility,
                                        icon: Icon(
                                          controller.isPasswordVisible.value
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: Colors.white.withOpacity(0.5),
                                        ),
                                      )
                                    : null,
                                hintText: "Enter your password",
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                                errorStyle: const TextStyle(
                                  color:
                                      Colors.redAccent, // change to any color
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                controller.signUp();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey[300],
                              ),
                            ),
                            Text(
                              '    or    ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[300],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.lightBg,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/google_icon.png',
                                  height: 40,
                                  width: 50,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Continue with Google',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.darkBg,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: "Sign In",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      formKey.currentState!.reset();
                                      controller.clearForm();
                                      Get.back();
                                      Transition.native;
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
