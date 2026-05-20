import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/config/routes/app_pages.dart';
import 'package:flutter_supabase_auth/config/routes/app_routes.dart';
import 'package:flutter_supabase_auth/config/theme/app_theme.dart';
import 'package:flutter_supabase_auth/modules/auth/binding/auth_binding.dart';
import 'package:flutter_supabase_auth/modules/auth/controller/auth_controller.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      //!ThemeData
      theme: AppTheme.lightTheme,

      //! Routing
      getPages: AppRouting.route,
      initialRoute: Get.find<AuthController>().isLoggedIn
          ? RouteView.profile.name
          : RouteView.signIn.name,
      initialBinding: AuthBinding(),
    );
  }
}
