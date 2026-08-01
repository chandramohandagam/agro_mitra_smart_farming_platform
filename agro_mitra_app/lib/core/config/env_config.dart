import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get backendUrl => dotenv.get('BACKEND_URL', fallback: 'https://agro-mitra-backend.onrender.com');
  static String get supabaseUrl => dotenv.get('SUPABASE_URL', fallback: '');
  static String get supabaseAnonKey => dotenv.get('SUPABASE_ANON_KEY', fallback: '');

  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
  }
}
