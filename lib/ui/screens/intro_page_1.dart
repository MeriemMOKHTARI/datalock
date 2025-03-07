import 'package:flutter/material.dart';
import '../../config/config.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
         begin: Alignment.topCenter,
         end: Alignment.bottomCenter,
  colors: [
    Color(0xFF042628),  // Couleur foncée
    Color(0xFF70B9BE),  // Couleur claire
  ],
),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Image.asset(
                'assets/images/intro_page_1.png', // Replace with your actual image file name
                width: 250, // Adjust the width as needed
                height: 250, // Adjust the height as needed
                fit: BoxFit.contain,
              ),
              const Text(
              Config.onboardingTitle1,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
              const SizedBox(height: 20),
              const Text(
              Config.onboardingDesc1,
              style: TextStyle(
                fontSize: 16,
                   color: Color(0xCCFFFFFF)
              ),
              textAlign: TextAlign.center,
            ),
            ],
          ),
        ),
      ),
    );
  }
}