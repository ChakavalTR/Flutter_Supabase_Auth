import 'package:flutter_supabase_auth/config/routes/app_pages.dart';
import 'package:flutter_supabase_auth/modules/auth/views/sign_in_view.dart';
import 'package:flutter_supabase_auth/modules/profile/binding/profile_binding.dart';
import 'package:flutter_supabase_auth/modules/profile/view/profile_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

class AppRouting {
  static final route = RouteView.values.map((e) {
    switch (e) {
      case RouteView.signIn:
        return GetPage(
          name: "/",
          page: () => SignInView(),
          transition: Transition.noTransition,
        );
      case RouteView.profile:
        return GetPage(
          name: "/${e.name}",
          page: () => ProfileView(),
          binding: ProfileBinding(),
          transition: Transition.noTransition,
        );
    }
  }).toList();
}
