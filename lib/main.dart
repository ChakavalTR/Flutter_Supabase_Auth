import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_supabase_auth/app.dart';
import 'package:flutter_supabase_auth/core/service/local_storage_service.dart';
import 'package:flutter_supabase_auth/core/service/supabase_service.dart';
import 'package:flutter_supabase_auth/config/env/env.dart';
import 'package:flutter_supabase_auth/modules/auth/controller/auth_controller.dart';
import 'package:get/get.dart';

Future<void> main() async {
  //! Flutter Binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  //! Load .env file
  await dotenv.load(fileName: ".env");

  //! Local Storage Initialization
  await LocalServiceStorage.instance.init();

  //! Supabase Initialization
  await SupabaseService.init(url: Env.url, anonKey: Env.anonKey);

  //! Controller Initialization
  Get.put(AuthController(), permanent: true);
  runApp(const App());
}
