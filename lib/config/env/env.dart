import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get url {
    return dotenv.env['URL'] ?? '';
  }

  static String get anonKey {
    return dotenv.env['ANON_KEY'] ?? '';
  }
}
