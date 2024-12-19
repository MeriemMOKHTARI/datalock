import 'dart:io';

import 'package:datalock/config/config.dart';
import 'package:datalock/ui/screens/HomePage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../services/auth_service.dart';

class NameInput extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSubmit;
  final String userId;
  final String phoneNumber;
  final AuthRepository authRepository;

  const NameInput({
    Key? key,
    required this.onBack,
    required this.onSubmit,
    required this.userId,
    required this.phoneNumber,
    required this.authRepository,
  }) : super(key: key);

  @override
  _NameInputState createState() => _NameInputState();
}

class _NameInputState extends State<NameInput> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final FlutterSecureStorage storage = FlutterSecureStorage();
  final account = Config.getAccount();
  final databases = Config.getDatabases();
  final functions = Config.getFunctions();
  String getPlatform() {
    if (kIsWeb) {
      return 'web';
    } else if (Platform.isAndroid) {
      return 'AND';
    } else if (Platform.isIOS) {
      return 'IOS';
    } else {
      return 'lin'; // For other platforms if needed  }
    }
  }

  Future<void> saveUserSession(String phoneNumber, String userId) async {
    try {
      await storage.write(key: 'phone_number', value: phoneNumber);
      await storage.write(key: 'user_id', value: userId);
    } catch (e) {
      print('Error saving user session: $e');
    }
  }

  @override
  void dispose() {
    // Libérez les ressources des contrôleurs
    nameController.dispose();
    prenomController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void handleNameSubmit(String name, String prenom, String email) async {
    UserModel user = UserModel(
      id: widget.userId,
      phoneNumber: widget.phoneNumber,
      name: name,
      prenom: prenom,
      email: email,
    );

    try {
      // Appeler une méthode pour enregistrer les informations utilisateur si nécessaire
      widget.onSubmit();
    } catch (e) {
      print('Error submitting user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: widget.onBack,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'complete_your_registration'.tr(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Please complete the information to complete your registration.'
                  .tr(),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: nameController,
              hintText: 'name'.tr(),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: prenomController,
              hintText: 'forename'.tr(),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: emailController,
              hintText: 'email'.tr(),
            ),
            const SizedBox(height: 24),
            CustomButton(
              onPressed: () async {
                final email = emailController.text;
                final name = nameController.text;
                final prenom = prenomController.text;

                final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if ((email.isEmpty || !emailRegExp.hasMatch(email)) ||
                    name.isEmpty ||
                    prenom.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Please enter valid information in all fields.'.tr()),
                    ),
                  );
                } else {
                  final authService = AuthService();
                  String result = await authService.saveUserInfos(
                      widget.phoneNumber,
                      getPlatform(),
                      "255.255.255.255",
                      widget.userId,
                      name,
                      prenom,
                      email,
                      account,
                      databases);

                  // Handle the result
                  if (result == '400') {
                    print('please provide all informations');
                  } else if (result == '200') {
                    print('infos saved successfully');
                    await saveUserSession(widget.phoneNumber, widget.userId);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );//meriem
                  } 
                  handleNameSubmit(name, prenom, email);
                }
              },
              text: 'Connection'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
