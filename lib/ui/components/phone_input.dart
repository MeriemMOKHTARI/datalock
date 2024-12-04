import 'dart:convert';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:datalock/config/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/repositories/auth_repository.dart';
import '../widgets/custom_button.dart';
import '../../services/auth_service.dart';


class PhoneInput extends flutter.StatefulWidget {
  final Function(String userId, String phoneNumber) onSubmit;


  const PhoneInput({
    flutter.Key? key,
    required this.onSubmit,
    require, required AuthRepository authRepository,
  }) : super(key: key);

  @override
  _PhoneInputState createState() => _PhoneInputState();
}

class _PhoneInputState extends flutter.State<PhoneInput> {
  final TextEditingController phoneController = TextEditingController();
  bool isPhoneValid = false;
  String? completePhoneNumber;
      String? ipAddress ;
      String entry_id=ID.unique();
      final account = Config.getAccount();
  final databases = Config.getDatabases();

    String getPlatform() {  if (kIsWeb) {
    return 'web';  } else if (Platform.isAndroid) {
    return 'AND';  } else if (Platform.isIOS) {
    return 'IOS';  } else {
    return 'lin'; // For other platforms if needed  }
}

}

  @override
  void initState() {
    super.initState();
    fetchAndSetIpAddress();
  }


Future<void> fetchAndSetIpAddress() async {
  ipAddress = await getUserIpAddress();}

Future<String> getUserIpAddress() async {  try {
    final url = Uri.parse('https://api.ipify.org?format=text');    final httpClient = HttpClient();
    final request = await httpClient.getUrl(url);    final response = await request.close();
    final ip = await response.transform(utf8.decoder).first;    return ip;
  } catch (e) {    return 'Error getting IP address: $e';
  }}

// void handlePhoneSubmit(PhoneNumber phoneNumber) {
//     // Directly call onSubmit with dummy userId and the entered phone number
//     widget.onSubmit('dummy_user_id', phoneNumber.completeNumber);
//   }
  @override
  flutter.Widget build(flutter.BuildContext context) {
    return flutter.SingleChildScrollView(
      child: flutter.Container(
        padding: flutter.EdgeInsets.all(24),
        child: flutter.Column(
          crossAxisAlignment: flutter.CrossAxisAlignment.start,
          children: [
            flutter.Text(
              'login_title'.tr(),
              style: flutter.TextStyle(
                fontSize: 24,
                fontWeight: flutter.FontWeight.bold,
              ),
            ),
            flutter.SizedBox(height: 8),
            flutter.Text(
              'login_subtitle'.tr(),
              style: flutter.TextStyle(
                color: flutter.Colors.grey[600],
                fontSize: 16,
              ),
            ),
            flutter.SizedBox(height: 16),
            flutter.Container(
              decoration: flutter.BoxDecoration(
                color: flutter.Colors.grey[100],
                borderRadius: flutter.BorderRadius.circular(12),
              ),
              child: IntlPhoneField(
                controller: phoneController,
                decoration: flutter.InputDecoration(
                  hintText: 'phone_number'.tr(),
                  counterText: '',
                  border: flutter.OutlineInputBorder(
                    borderRadius: flutter.BorderRadius.circular(12),
                    borderSide: flutter.BorderSide.none,
                  ),
                  contentPadding: flutter.EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  filled: true,
                  fillColor: flutter.Colors.grey[100],
                ),
                initialCountryCode: 'DZ',
                disableLengthCheck: false,
                dropdownDecoration: flutter.BoxDecoration(
                  borderRadius: flutter.BorderRadius.circular(12),
                ),
                flagsButtonPadding: flutter.EdgeInsets.symmetric(horizontal: 8),
                onChanged: (phone) {
                  setState(() {
                    isPhoneValid = phone.number.length >= 9;
                    completePhoneNumber = phone.completeNumber;
                  });
                },
              ),
            ),
            flutter.SizedBox(height: 24),
            CustomButton(
            onPressed: isPhoneValid
    ? () async {
        final authService = AuthService();
        print(completePhoneNumber! +    getPlatform() + ipAddress! + entry_id );
        // Call sendSMS and store the result in a variable
        String result = await authService.sendSMS(
          completePhoneNumber!,
          getPlatform(),
          "255.255.255.255",
          entry_id,
          account,
          databases,
        );

        // Handle the result
        if (result == '200') {
          print('SMS sent successfully, navigating to OTP screen...');
          widget.onSubmit(entry_id, completePhoneNumber!);
        } else if (result == '333') {
          // Handle blocked user
          print('User is blocked');
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Blocked User'),
                content: Text('Your account has been blocked.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (result == '401') {
          
          print('Failed to send SMS');
          
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Failed to send SMS. Please try again later.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    : null,


              text: 'login'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneNumber {
  final String number;
  final String completeNumber;
  final String isoCode;

  PhoneNumber({
    required this.number,
    required this.completeNumber,
    required this.isoCode,
  });
}

