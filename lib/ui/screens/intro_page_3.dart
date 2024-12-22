import 'package:flutter/material.dart';
import '../../config/config.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF042628),
            Color(0xFF70B9BE),
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
                'assets/images/intro_page_3.png', // Replace with your actual image file name
                width: 250, // Adjust the width as needed
                height: 250, // Adjust the height as needed
                fit: BoxFit.contain,
              ),
              const Text(
              Config.onboardingTitle3,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
              const SizedBox(height: 20),
              const Text(
              Config.onboardingDesc3,
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

