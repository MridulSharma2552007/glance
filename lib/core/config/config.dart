import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get backendUrl =>
      dotenv.env['BACKEND_BASE_URL'] ?? 'https://glance-neon.vercel.app';

      static String get supabaseUrl=> dotenv.env['SUPABASE_URL']??'';
      static String get supabaseKey=>dotenv.env['SUPABASE_KEY']??'';
      static String get googleServerClientId => dotenv.env['GOOGLE_SERVER_CLIENT_ID'] ?? '';
}