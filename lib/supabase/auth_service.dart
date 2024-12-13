import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> signUp(String email, String password) async {
    try {
      final response =
          await supabase.auth.signUp(email: email, password: password);
      if (response.user == null) {
        throw Exception('Sign-up failed');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<void> logIn(String email, String password) async {
    try {
      final response = await supabase.auth
          .signInWithPassword(email: email, password: password);
      if (response.session == null) {
        throw Exception('Login failed');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      final response =
          await supabase.auth.signInWithOAuth(Provider.google as OAuthProvider);
      print("OAuth response: ${response.toString()}");
    } catch (e) {
      throw Exception('Google Sign-In failed: ${e.toString()}');
    }
  }
}

class Provider {
  static const google = 'google';
}
