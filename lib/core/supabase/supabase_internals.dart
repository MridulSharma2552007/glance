import 'package:flutter/material.dart';
import 'package:glance/core/config/config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseInternals{
    final supabase = Supabase.instance.client;
  
  
Future<bool> googleSignIn() async {
  try {
    final serverClientId = Env.googleServerClientId;

    if (serverClientId.isEmpty) {
      throw 'GOOGLE_SERVER_CLIENT_ID is missing.';
    }

    await GoogleSignIn.instance.initialize(
      serverClientId: serverClientId,
    );

    final account = await GoogleSignIn.instance.authenticate();

    final googleAuth = account.authentication;
    final idToken = googleAuth.idToken;

    final String? accessToken = null;

    if (idToken == null) {
      throw 'No ID Token found.';
    }

    debugPrint('🔑 Google idToken: present (len ${idToken.length}) ✅');

    final res = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    debugPrint(
      '🧾 Supabase response: '
      'session=${res.session != null ? 'present ✅' : 'missing ❌'}',
    );

    if (res.session != null) {
      debugPrint('🎉 Auth successful ✅');

      return true; // 👈 SUCCESS
    }

    return false; // 👈 FAILED
  } catch (e) {
    debugPrint('❌ Google Sign-In failed: $e');
    return false; // 👈 FAILED
  }
}
}