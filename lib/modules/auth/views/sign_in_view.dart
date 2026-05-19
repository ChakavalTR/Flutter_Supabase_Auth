import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/config/theme/app_theme.dart';
import 'package:flutter_supabase_auth/modules/auth/views/sign_up_view.dart';
import 'package:flutter_supabase_auth/widgets/animation/animation_background_widget.dart';
import 'package:flutter_supabase_auth/widgets/textfield/textfield_glass_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/auth_controller.dart';
import 'package:get/get.dart';

class SignInView extends GetView<AuthController> {
  SignInView({super.key});
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 60),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 26),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: AppTheme.primary,
                            child: Icon(
                              Icons.person,
                              size: 70,
                              color: AppTheme.lightBg,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Welcome Back 👋🏻",
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Login to continue to your profile",
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
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              hintText: "example@gmail.com",
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
                                return 'Please enter your email!';
                              } else if (!GetUtils.isEmail(value)) {
                                return 'Please enter a valid email!';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 28),
                        Row(
                          children: [
                            Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                controller.forgotPassword();
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Obx(
                          () => TextFieldGlassWidget(
                            child: TextFormField(
                              controller: controller.passwordController,
                              style: TextStyle(color: Colors.white),
                              obscureText: !controller.isPasswordVisible.value,
                              onChanged: controller.togglePasswordFilled,
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
                                          color:
                                              controller.isPasswordVisible.value
                                              ? AppTheme.lightBg
                                              : Colors.white.withOpacity(0.5),
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
                                  return 'Please enter your password!';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 26),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () {
                                      if (formKey.currentState!.validate()) {
                                        controller.signIn();
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: controller.isLoading.value
                                  ? SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
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
                                  'assets/icons/apple_icon.png',
                                  height: 50,
                                  width: 50,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Continue with Apple',
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
                        SizedBox(height: 24),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: "Sign Up",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      formKey.currentState!.reset();
                                      controller.clearForm();
                                      Get.to(
                                        () => SignUpView(),
                                        transition: Transition.native,
                                      );
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
