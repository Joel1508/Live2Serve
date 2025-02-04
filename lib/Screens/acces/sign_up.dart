import 'dart:ui';
import 'package:FRES.CO/supabase/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final AuthService authService = AuthService();

  Future<void> signUp(BuildContext context) async {
    try {
      // First check if user already exists
      final user = await authService.signUp(
        emailController.text,
        passwordController.text,
      );

      // Get the current user after successful sign up
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser != null) {
        // Check if profile already exists
        final existingProfile = await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', currentUser.id)
            .single();

        if (existingProfile == null) {
          // Only create profile if it doesn't exist
          await Supabase.instance.client.from('profiles').insert({
            'id': currentUser.id,
            'username': usernameController.text,
            'notifications_enabled': true,
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign up successful! Please log in.')),
        );
        Navigator.pushNamed(context, '/log_in');
      }
    } on PostgrestException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Database Error: ${e.message}')),
      );
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Auth Error: ${e.message}')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF9EC9B2),
        body: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Section with Logo and Text
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8ABC8B),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(
                            width: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "FRES.CO",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFAFAD8),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "Registrarse",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF17372A),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Para continuar",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFAFAD8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Column(
                            children: [
                              // Username Field
                              TextField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  hintText: 'Nombre Usuario',
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Email Field
                              TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  hintText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Password Field
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: 'Contraseña',
                                  prefixIcon: Icon(Icons.lock),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Sign-Up Button
                              ElevatedButton(
                                onPressed: () => signUp(context),
                                child: const Text('Registrarse'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF9EC9B2),
                                  foregroundColor: Color(0xFFF17372A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Already Have an Account Text
                              TextButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/log_in'),
                                child: const Text(
                                  '¿Ya tienes una cuenta? Inicia sesión',
                                  style: TextStyle(fontSize: 16),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              // Continue with Google Button
                              ElevatedButton.icon(
                                icon: Image.asset(
                                  'assets/images/google.png',
                                  width: 24,
                                  height: 24,
                                ),
                                label: const Text('Continua con Google'),
                                onPressed: () async {
                                  try {
                                    await authService.logInWithGoogle();
                                    // Change this line from '/home' to '/home_screen'
                                    Navigator.pushNamed(
                                        context, '/home_screen');
                                  } catch (error) {
                                    // Add more specific error handling
                                    String errorMessage =
                                        'Error during Google sign-in';
                                    if (error
                                        .toString()
                                        .contains('validation_failed')) {
                                      errorMessage =
                                          'Google sign-in is not properly configured. Please contact support.';
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(errorMessage)),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFCEDDCA),
                                  foregroundColor: Color(0xFFF17372A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Decorative Image
                    SizedBox(
                      width: 300,
                      height: 150,
                      child: Image.asset(
                        'assets/images/tubo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
