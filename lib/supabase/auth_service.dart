import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  // Sign Up
  Future<void> signUp(String email, String password) async {
    try {
      final response =
          await supabase.auth.signUp(email: email, password: password);
      if (response.user == null) {
        throw Exception('Sign-up failed');
      }
    } catch (e) {
      throw Exception('Error during sign-up: ${e.toString()}');
    }
  }

  // Log In
  Future<void> logIn(String email, String password) async {
    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Check if the session or user is null
      if (response.session == null || response.user == null) {
        throw Exception(
            'Authentication failed. Please check your credentials.');
      }

      // Save email after successful login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_email', email);
    } catch (e) {
      throw Exception('Log in failed: $e');
    }
  }

  // Retrieve saved email
  Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('saved_email');
  }

  // Clear saved email
  Future<void> clearSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_email');
  }

  // Log In with Google
  Future<void> logInWithGoogle() async {
    try {
      final response =
          await supabase.auth.signInWithOAuth(OAuthProvider.google);
      print("OAuth response: $response");
    } catch (e) {
      throw Exception('Google Sign-In failed: ${e.toString()}');
    }
  }

  // Log Out
  Future<void> logOut() async {
    try {
      await supabase.auth.signOut();
      // Clear saved email on logout
      await clearSavedEmail();
    } catch (e) {
      throw Exception('Error during logout: ${e.toString()}');
    }
  }

  // Get Current User
  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }
}
