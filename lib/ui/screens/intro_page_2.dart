import 'package:flutter/material.dart';
import '../../config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

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
                'assets/images/intro_page_2.png', // Replace with your actual image file name
                width: 250, // Adjust the width as needed
                height: 250, // Adjust the height as needed
                fit: BoxFit.contain,
              ),
                Text(
               'Fast_delivery'.tr(),
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
              const SizedBox(height: 20),
               Text(
              'Take_advantage_of_our_fast_and_efficient_delivery_service!'.tr(),
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

