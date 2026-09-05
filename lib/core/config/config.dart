import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get backendUrl =>
      dotenv.env['BACKEND_BASE_URL'] ?? 'https://glance-neon.vercel.app';
}