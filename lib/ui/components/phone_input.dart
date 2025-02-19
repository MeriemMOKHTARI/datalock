import 'dart:convert';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:datalock/config/config.dart';
import 'package:datalock/ui/components/otp_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../data/repositories/auth_repository.dart';
import '../widgets/custom_button.dart';
import '../../services/auth_service.dart';

class PhoneInput extends flutter.StatefulWidget {
  final Function(String userId, String phoneNumber, String result, String entry_id) onSubmit;
  final VoidCallback onLoginTap;

  const PhoneInput({
    flutter.Key? key,
    required this.onSubmit,
    required this.onLoginTap,
    required AuthRepository authRepository,
  }) : super(key: key);

  @override
  _PhoneInputState createState() => _PhoneInputState();
}

class _PhoneInputState extends flutter.State<PhoneInput> {
  final TextEditingController phoneController = TextEditingController();
  bool isPhoneValid = false;
  bool showError = false;
  String? completePhoneNumber;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  String? ipAddress;
  bool isOtpScreen = false;

  String entry_id = ID.unique();
  final account = Config.getAccount();
  final databases = Config.getDatabases();
  String lastValidNumber = '';
  String? errorMessage;
  Key _phoneFieldKey = UniqueKey();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

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

  @override
  void initState() {
    super.initState();
    fetchAndSetIpAddress();
    PackageInfo.fromPlatform().then((value) {
      print(value);
    });
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> fetchAndSetIpAddress() async {
    ipAddress = await getUserIpAddress();
  }

  Future<String> getUserIpAddress() async {
    try {
      final url = Uri.parse('https://api.ipify.org?format=text');
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(url);
      final response = await request.close();
      final ip = await response.transform(utf8.decoder).first;
      return ip;
    } catch (e) {
      return 'Error getting IP address: $e';
    }
  }

  bool _validatePhoneNumber(String number) {
    return number.length == 9;
  }

  void _showCountryAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Country_Not_Supported'.tr()),
          content: Text('The_application_is_currently_only_available_in_Algeria.'.tr()),
          actions: <Widget>[
            TextButton(
              child: Text('OK'.tr()),
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

void _sendSMS() async {
  final authService = AuthService();

  try {
    if (completePhoneNumber == null || completePhoneNumber!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number.'.tr())),
      );
      return;
    }

    Map<String, String> verifyResult = await authService.verifyUserExistence(completePhoneNumber!);
    print("numero: " + completePhoneNumber!);
    print("userID: " + verifyResult['userID']!);

    switch (verifyResult['status']) {
      case '200':
        // User exists, show popup and redirect to login screen
        print('User already exists, redirecting to login screen');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Existing_Account'.tr()),
              content: Text('You_already_have_an_account._Please_log_in.'.tr()),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'.tr()),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    widget.onLoginTap(); // Redirect to login screen
                  },
                ),
              ],
            );
          },
        );
        break;
      case '333':
        // User doesn't exist, proceed with SMS sending
        String userID = verifyResult['userID']!;
        String result = await authService.sendSMS(
          completePhoneNumber!,
          "and",
           "255.255.255.255",
          userID,
          account,
          databases,
        );

        print(completePhoneNumber! + " " + "and" + " " + ( "255.255.255.255") + " " + userID);
        if (result == '200') {
          print('SMS sent successfully, navigating to OTP screen...');
          widget.onSubmit(userID, completePhoneNumber!, result, userID);
        } else if (result == '333') {
          print('User is blocked');
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Blocked_User'.tr()),
                content: Text('Your_account_has_been_blocked.'.tr()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send SMS. Please try again.'.tr())),
          );
        }
        break;
      case '400':
        // Missing required fields
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Missing required information. Please try again.'.tr())),
        );
        break;
      default:
        // Error occurred
        String errorMessage = verifyResult['message'] ?? 'An unknown error occurred.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$errorMessage Please try again.'.tr())),
        );
    }
  } catch (e) {
    print('Error in _sendSMS: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An unexpected error occurred. Please try again.'.tr())),
    );
  }
}







    

  void _showConfirmationDialog() {
    final String number = completePhoneNumber ?? '';
    final String questionMark = '?';
    final String plus = '+';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final String contentMessage = context.locale.languageCode == 'ar'
            ? 'Do_you_confirm_that_your_number_is_well_there'.tr() +
                ': ' +
                questionMark +
                number.substring(1) +
                plus
            : 'Do_you_confirm_that_your_number_is_well_there'.tr() +
                ': ' +
                plus +
                number.substring(1) +
                questionMark;

        return AlertDialog(
          title: Text('Number_Verification'.tr()),
          content: Text(contentMessage),
          actions: <Widget>[
            TextButton(
              child: Text('No'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
                _sendSMS();
              },
            ),
          ],
        );
      },
    );
  }

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
Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: _isFocused ? [
                  BoxShadow(
                    color: flutter.Color.fromARGB(255, 7, 83, 90).withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 0.5,
                    offset: Offset(0, 0),
                  ),
                ] : [],
              ),
              child: IntlPhoneField(
                focusNode: _focusNode, // AJOUTÉ
                key: _phoneFieldKey,
                controller: phoneController,
                decoration: flutter.InputDecoration(
                  hintText: 'phone_number'.tr(),
                  counterText: '',
                  errorText: errorMessage,
                  border: flutter.OutlineInputBorder(
                    borderRadius: flutter.BorderRadius.circular(12),
                    borderSide: flutter.BorderSide.none,
                  ),
                  enabledBorder: flutter.OutlineInputBorder(
                    borderRadius: flutter.BorderRadius.circular(12),
                    borderSide: flutter.BorderSide.none,
                  ),
                  focusedBorder: flutter.OutlineInputBorder(
                    borderRadius: flutter.BorderRadius.circular(12),
                    borderSide: flutter.BorderSide.none,
                  ),
                  contentPadding: flutter.EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                initialCountryCode: 'DZ',
                disableLengthCheck: true,
                dropdownDecoration: flutter.BoxDecoration(
                  borderRadius: flutter.BorderRadius.circular(12),
                ),
                flagsButtonPadding: flutter.EdgeInsets.symmetric(horizontal: 8),
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
            flutter.SizedBox(height: 24),
            CustomButton(
              onPressed: isPhoneValid ? _showConfirmationDialog : null,
              text: 'login'.tr(),
            ),
            flutter.SizedBox(height: 16),
            flutter.Center(
              child: flutter.GestureDetector(
                onTap: widget.onLoginTap,
                child: flutter.RichText(
                  text: flutter.TextSpan(
                    style: flutter.TextStyle(
                      color: flutter.Colors.grey[600],
                      fontSize: 14,
                    ),
                    children: [
                      flutter.TextSpan(text: 'Déja inscrit ?'.tr() + ' '),
                      flutter.TextSpan(
                        text: 'connectez-vous'.tr(),
                        style: flutter.TextStyle(
                          decoration: flutter.TextDecoration.underline,
                          color: flutter.Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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

