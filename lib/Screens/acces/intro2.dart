import 'package:flutter/material.dart';

class IntroductionScreen2 extends StatelessWidget {
  const IntroductionScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF94BFA5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo and Title
              Column(
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/lettuce.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'FRES.CO',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFAFAD8),
                    ),
                  ),
                ],
              ),
              // Background Image in the Middle
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    'assets/images/hydro.png',
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.4,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Description Text
              const Text(
                'Nuestra misión es llevar productos frescos y deliciosos directamente a tu mesa, perfectos para el almuerzo, la cena y todo lo demás.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // Navigation Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/intro3');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
