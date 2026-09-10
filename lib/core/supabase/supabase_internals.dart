import 'package:flutter/material.dart';
import 'package:glance/core/config/config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseInternals{
    final supabase = Supabase.instance.client;
  
  
   Future<void> _googleSignIn() async {
  // Ensure the platform sign-in is initialized before calling authenticate.
  final serverClientId = Env.googleServerClientId;
  if (serverClientId.isEmpty) {
    throw 'GOOGLE_SERVER_CLIENT_ID is missing. Add it to your .env and pubspec assets.';
  }
  await GoogleSignIn.instance.initialize(serverClientId: serverClientId);

  final account = await GoogleSignIn.instance.authenticate();

  final googleAuth = account.authentication;
  final idToken = googleAuth.idToken;
  // Do not request an empty scopes list on Android (causes SDK error).
  // Access token is optional for Supabase; pass null when not available.
  final String? accessToken = null;

  if (idToken == null) {
    throw 'No ID Token found.';
  }
  debugPrint('🔑 Google idToken: present (len ${idToken.length}) ✅');

  // Attempt Supabase sign-in and print clear emoji-marked results.
  final res = await supabase.auth.signInWithIdToken(
    provider: OAuthProvider.google,
    idToken: idToken,
    accessToken: accessToken,
  );

  debugPrint('🧾 Supabase response: session=${res.session != null ? 'present ✅' : 'missing ❌'}');
  if (res.session != null) {
    debugPrint('🎉 Auth successful — accessToken: ${res.session?.accessToken ?? 'n/a'}');
    return;
  }

  throw 'Supabase did not return a session.';
}
  
}