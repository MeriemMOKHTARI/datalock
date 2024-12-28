import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:datalock/config/config.dart';
import 'package:datalock/ui/screens/HomePage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../data/repositories/auth_repository.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../services/auth_service.dart';

class LoginInput extends StatefulWidget {
  final VoidCallback onBack;
  final AuthRepository authRepository;
  final Function(String, String, String) onOtpNavigate;

  const LoginInput({
    Key? key,
    required this.onBack,
    required this.authRepository,
    required this.onOtpNavigate,
  }) : super(key: key);

  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final account = Config.getAccount();
  final databases = Config.getDatabases();
  bool isPhoneValid = false;
  String? completePhoneNumber;
  String lastValidNumber = '';
  String? errorMessage;
  Key _phoneFieldKey = UniqueKey();
  String new_id = ID.unique();

  bool _isNumericOnly(String str) {
    return RegExp(r'^[0-9]+$').hasMatch(str);
  }

  String getPlatform() {
    if (kIsWeb) {
      return 'web';
    } else if (Platform.isAndroid) {
      return 'AND';
    } else if (Platform.isIOS) {
      return 'IOS';
    } else {
      return 'lin';
    }
  }

  void _showCountryAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Country_Not_Supported'.tr()),
          content: Text(
              'The_application_is_currently_only_available_in_Algeria.'.tr()),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  phoneController.clear();
                  _phoneFieldKey = UniqueKey();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vérification_des_coordonnées'.tr()),
          content: Text(
              'Votre_nom_et_prénom_ne_correspondent_pas_avec_votre_N°_de_téléphone,_continuez_quand_même_?'.tr()),
          actions: <Widget>[
            TextButton(
              child: Text('Non'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Oui'.tr()),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                final authService = AuthService();
                String result = await authService.sendSMS(
                  completePhoneNumber!,
                  getPlatform(),
                  "255.255.255.255",
                  new_id,
                  account,
                  databases,
                );
                print("SMS send result: $result");
                if (result == '200') {
                  // Navigate to OTP screen with name and prenom
                  widget.onOtpNavigate(
                    nameController.text,
                    prenomController.text,
                    completePhoneNumber!,
                  );
                } else if (result == '333') {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Blocked_User'.tr()),
                        content: Text('Your_account_has_been_blocked.'.tr()),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'.tr()),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Show an error message if SMS sending fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Failed_to_send_SMS._Please_try_again.'.tr())),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerificationDialog2() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vérification_des_coordonnées'.tr()),
          content: Text(
               'Votre_nom_et_prénom_ne_correspondent_pas_avec_votre_N°_de_téléphone,_continuez_quand_même_?'.tr()),
          actions: <Widget>[
            TextButton(
              child: Text('Non'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Oui'.tr()),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                final authService = AuthService();
                String result = await authService.sendSMS(
                  completePhoneNumber!,
                  getPlatform(),
                  "255.255.255.255",
                  new_id,
                  account,
                  databases,
                );
                print("SMS send result: $result");
                if (result == '200') {
                  // Navigate to OTP screen with name and prenom
                  widget.onOtpNavigate(
                    nameController.text,
                    prenomController.text,
                    completePhoneNumber!,
                  );
                } else if (result == '333') {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Blocked_User'.tr()),
                        content: Text('Your_account_has_been_blocked.'.tr()),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'.tr()),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Show an error message if SMS sending fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Failed to send SMS. Please try again.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
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
                    'Introduisez vos coordonnées'.tr(),
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
              'Veuillez indiquer vos coordonnées pour récupérer votre compte'
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
            const SizedBox(height: 16),
            CustomTextField(
              controller: prenomController,
              hintText: 'forename'.tr(),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: IntlPhoneField(
                key: _phoneFieldKey,
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: 'phone_number'.tr(),
                  counterText: '',
                  errorText: errorMessage,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                initialCountryCode: 'DZ',
                disableLengthCheck: true,
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                flagsButtonPadding: EdgeInsets.symmetric(horizontal: 8),
                onChanged: (phone) {
                  setState(() {
                    if (phone.number.isEmpty) {
                      errorMessage = null;
                      isPhoneValid = false;
                    } else if (!_isNumericOnly(phone.number)) {
                      errorMessage = 'Invalid_phone_number'.tr();
                      isPhoneValid = false;
                    } else if (phone.number.length == 9) {
                      errorMessage = null;
                      isPhoneValid = true;
                    } else if (phone.number.length > 9) {
                      phoneController.value = phoneController.value.copyWith(
                        text: lastValidNumber,
                        selection: TextSelection.collapsed(
                            offset: lastValidNumber.length),
                      );
                    } else {
                      errorMessage = null;
                      isPhoneValid = false;
                    }

                    if (phone.number.length <= 9) {
                      lastValidNumber = phone.number;
                      completePhoneNumber = phone.completeNumber;
                    }
                  });
                },
                onCountryChanged: (country) {
                  if (country.code != 'DZ') {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _showCountryAlert();
                    });
                    Future.microtask(() {
                      setState(() {
                        phoneController.clear();
                      });
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
           CustomButton(
              onPressed: () async {
                final name = nameController.text;
                final prenom = prenomController.text;

                if (name.isNotEmpty && prenom.isNotEmpty && isPhoneValid) {
                  final authService = AuthService();
                  try {
                    Map<String, String> result = await authService.verifyUser(
                      name,
                      prenom,
                      completePhoneNumber ?? '',
                      account,
                      databases,
                    );
                    print("testii: $result"); // Add this line for debugging

                    if (result['status'] == '200') {
                      String userID = result['userID'] ?? '';
                      print("UserID li jawtah: $userID"); // Add this line for debugging
                      String smsResult = await authService.sendSMS(
                        completePhoneNumber!,
                        getPlatform(),
                        "255.255.255.255",
                        userID,
                        account,
                        databases,
                      );
                      print("tlf: $completePhoneNumber! smsResult: $smsResult");

                      if (smsResult == '200') {
                        widget.onOtpNavigate(
                          nameController.text,
                          prenomController.text,
                          completePhoneNumber!,
                        );
                      } else if (smsResult == '333') {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Blocked_User'.tr()),
                            content: Text('Your_account_has_been_blocked.'.tr()),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed_to_send_SMS._Please_try_again.'.tr())),
                        );
                      }
                    } else if (result['status'] == '201') {
                      _showVerificationDialog();
                    } else if (result['status'] == '202') {
                      _showVerificationDialog2();
                    } else {
                      print("Unexpected result from verifyUser: $result");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('An_error_occurred._Please_try_again.'.tr())),
                      );
                    }
                  } catch (e) {
                    print("Error during verification or SMS sending: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('An_error_occurred._Please_try_again.'.tr())),
                    );
                  }
                }
              },
              text: 'Connexion'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}