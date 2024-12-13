import 'dart:ui';
import 'package:app/supabase/auth_service.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EC9B2),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Circular Background
                      Container(
                        width: 250,
                        height: 250,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8ABC8B),
                          shape: BoxShape.circle,
                        ),
                      ),
                      // Text Inside the Circle
                      const SizedBox(
                        width: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "FRES.CO",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFAFAD8),
                              ),
                            ),
                            SizedBox(height: 25),
                            Text(
                              "Sign up",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF17372A),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "To Continue",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
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
                const SizedBox(height: 30),
                // Glassy Effect Container for Entire Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
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
                              hintText: 'User name',
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
                              hintText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Sign-Up Button
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                await authService.signUp(
                                  emailController.text,
                                  passwordController.text,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Sign up successful! Please log in.'),
                                  ),
                                );
                                Navigator.pushNamed(context, '/log_in');
                              } catch (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $error')),
                                );
                              }
                            },
                            child: const Text('Sign up'),
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
                              'Already have an account? Log in',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                          ),
                          // Continue with Google Button
                          ElevatedButton.icon(
                            icon: Image.asset(
                              'assets/google.png',
                              width: 24,
                              height: 24,
                            ),
                            label: const Text('Continue with Google'),
                            onPressed: () async {
                              try {
                                await authService.logInWithGoogle();
                                Navigator.pushNamed(context, '/home');
                              } catch (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $error')),
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
                    'assets/tubo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
