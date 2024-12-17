import 'package:app/supabase/auth_service.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService authService = AuthService();
  final LocalAuthentication auth =
      LocalAuthentication(); // Local authentication instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EC9B2),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Circular Background
                    Container(
                      width: 300,
                      height: 300,
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
                            "Log In",
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
                        // Log In Button
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await authService.logIn(
                                emailController.text,
                                passwordController.text,
                              );

                              // Trigger biometric authentication if login successful
                              bool isAuthenticated =
                                  await _authenticateWithBiometrics();

                              if (isAuthenticated) {
                                Navigator.pushNamed(
                                  context,
                                  '/home_screen',
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Authentication failed.')),
                                );
                              }
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $error')),
                              );
                            }
                          },
                          child: const Text('Log in'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF8ABC8B),
                            foregroundColor: Colors.white,
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
                        const SizedBox(height: 10),
                        // "Create an Account" and "Forgot Password?"
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/sign_up'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    Navigator.pushNamed(context, '/sign_up'),
                                child: const Text(
                                  'Create an account',
                                  style: TextStyle(
                                    color: Color(0xFFF17372A),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 50),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/recover_password');
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Color(0xFFF17372A),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: 300,
                height: 150,
                child: Image.asset(
                  'assets/images/tubo.png',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to authenticate using biometrics (Face ID or Fingerprint)
  Future<bool> _authenticateWithBiometrics() async {
    try {
      bool isAvailable = await auth.canCheckBiometrics;
      if (!isAvailable) {
        return false;
      }

      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        return false;
      }

      // Checking if Face ID or Fingerprint is available
      if (availableBiometrics.contains(BiometricType.face)) {
        print('Face ID is available');
      }
      if (availableBiometrics.contains(BiometricType.fingerprint)) {
        print('Fingerprint is available');
      }

      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access your account',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      return authenticated;
    } catch (e) {
      return false;
    }
  }
}
