import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

class Config {
  static Map<String, dynamic>? _config;

  static Future<void> loadConfig() async {
    final configString = await rootBundle.loadString('config.json');
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  // Appwrite Configuration
  static String get appwriteEndpoint => _config?['appwriteEndpoint'] as String;
  static String get appwriteProjectId => _config?['appwriteProjectId'] as String;
  static String get SEND_SMS_FUNCTION_ID => _config?['sendSmsFunctionId'] as String;

  // Database Configuration
  static String get mainDatabaseId => _config?['mainDatabaseId'] as String;
  static Map<String, String> get collections => 
      Map<String, String>.from(_config?['collections'] as Map);

  // Appwrite Services
  static Client getClient() {
    return Client()
        .setEndpoint(appwriteEndpoint)
        .setProject(appwriteProjectId)
        .setSelfSigned(status: true);
  }

  static Functions getFunctions() {
    return Functions(getClient());
  }

  static Account getAccount() {
    return Account(getClient());
  }

  static Databases getDatabases() {
    return Databases(getClient());
  }

  // Theme Configuration
  static final themeData = ThemeData(
  
    primaryColor: const Color(0xFF70B9BE),
    scaffoldBackgroundColor: const Color.fromARGB(255, 5, 4, 32),
    fontFamily: 'SofiaPro', 
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontFamily: 'SofiaPro'),
      bodyMedium: TextStyle(fontFamily: 'SofiaPro'),
      titleLarge: TextStyle(fontFamily: 'SofiaPro', fontWeight: FontWeight.bold),
    ),
  );

  // Logo Configuration
  static const String appName = 'Datalock';

  // Logo Widget
  static Widget buildLogo() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(child: Text('LOGO'))
        ),
        const SizedBox(height: 13),
        Text(
          appName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  static const String onboardingTitle1 = "Bienvenue";
static const String onboardingDesc1 = "Ravi de vous rencontrer. Nous sommes heureux de vous accueillir, alors commençons !";
 static const String onboardingBg1 = "assets/images/onboard1.png";

static const String onboardingDesc2 = "Commandez facilement depuis tous vos endroits préférés";
 static const String onboardingBg2 = "assets/images/onboard1.png";

 static const String onboardingTitle3 = "Offres de livraison ";
static const String onboardingDesc3 = "Nous proposerons bientôt un code promo et une \n livraison gratuite !";
 static const String onboardingBg3 = "assets/images/onboard2.png";
}




