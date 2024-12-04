import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';

class NameInput extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController prenomController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: onBack,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'complete_your_registration'.tr(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Please complete the information to complete your registration.'.tr(),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            SizedBox(height: 24),
            CustomTextField(
              controller: nameController,
              hintText: 'name'.tr(),
            ),
            SizedBox(height: 8),
            CustomTextField(
              controller: prenomController,
              hintText: 'forename'.tr(),
            ),
            SizedBox(height: 8),
            CustomTextField(
              controller: emailController,
              hintText: 'email'.tr(),
            ),
            SizedBox(height: 24),
            CustomButton(
              onPressed: () => handleNameSubmit(nameController.text, emailController.text),
              text: 'Connection'.tr(),
            ),
          ],
        ),
      ),
    );
  }

  void handleNameSubmit(String name, String email) async {
    UserModel user = UserModel(
      id: userId,
      phoneNumber: phoneNumber,
      name: name,
      email: email,
    );

    try {
      // await authRepository.saveUserInfo(user);
      onSubmit();
    } catch (e) {
      // Gérer l'erreur
    }
  }
}

