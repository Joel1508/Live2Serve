import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    // optional: for natural jump
    /*
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/intro1');
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF94BFA5),
      body: SafeArea(
        child: Stack(
          children: [
            // Center content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.asset(
                      'assets/images/lettuce.png',
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Welcome text
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style:
                          TextStyle(fontFamily: 'Roboto', color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Welcome\n',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'to ',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextSpan(
                          text: 'FRES.CO',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFAFAD8),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Buttons at the bottom
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home_screen');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      backgroundColor: Color(0xFFFDEDCDC),
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                          color: Color(0xFFF12372A),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  // Continue button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/intro1');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      backgroundColor: Color(0xFFFDEDCDC),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                          color: Color(0xFFF12372A),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Welcome(),
    ));
