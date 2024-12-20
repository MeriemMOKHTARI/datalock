import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:appwrite/appwrite.dart';
import 'package:datalock/config/config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../widgets/otp_field.dart';
import '../widgets/custom_button.dart';
import '../../services/auth_service.dart';

class OtpInput extends StatefulWidget {
  final Function(String userId, String phoneNumber, String result) onSubmit;
  final VoidCallback onBack;
  final Function(String otp) onVerify;
  final String phoneNumber;
  final String userId;

  const OtpInput({
    Key? key,
    required this.onBack,
    required this.onVerify,
    required this.phoneNumber,
    required this.userId,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _OtpInputState createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final List<TextEditingController> otpControllers =
      List.generate(4, (index) => TextEditingController());
  String remainingTime = '';
  String? ipAddress;
  String entry_id = ID.unique();
  final account = Config.getAccount();
  final databases = Config.getDatabases();
 

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
    startCountdown();
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

  void startCountdown() {
    int remainingSeconds = 120;
    Stream.periodic(Duration(seconds: 1), (i) => remainingSeconds - i)
        .take(remainingSeconds + 1)
        .listen(
      (seconds) {
        if (mounted) {
          setState(() {
            remainingTime =
                '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
          });
        }
      },
      onDone: () {
        if (mounted) {
          setState(() {
            remainingTime = '00:00';
          });
        }
      },
    );
  }

  Future<void> resendOTP() async {
    final authService = AuthService();
    print('Resending OTP to: ${widget.phoneNumber}');

    String result = await authService.sendSMS(
      widget.phoneNumber,
      getPlatform(),
      ipAddress ?? "255.255.255.255",
      entry_id,
      account,
      databases,
    );

    if (result == '200') {
      print('SMS resent successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP resent successfully')),
      );
      startCountdown();
    } else {
      print('Failed to resend SMS: $result');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to resend OTP. Please try again later.'),
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

  @override
  Widget build(BuildContext context) {
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
                  onPressed: widget.onBack,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'otp_subtitle'.tr(),
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
              'enter_otp'.tr() + '\n${widget.phoneNumber}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            OtpField(controllers: otpControllers),
            SizedBox(height: 24),
            CustomButton(
              onPressed: () async {
                // Bypass OTP verification
                final authService = AuthService();
                String result = await authService.VerifyOTP(
                  widget.phoneNumber,
                  otpControllers.map((controller) => controller.text).join(''),
                  account,
                  databases,
                );
                if (result == '200') {
                  await widget.onSubmit(widget.userId, widget.phoneNumber,result);
                } else if (result == '400') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('please provide a valid OTP')),
                  );
                } else if (result == '333') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('incorrect OTP')),
                  );
                } else if (result == 'ERR') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error')),
                  );
                } else {  
                 
                }
              },
              text: 'Continue'.tr(),
            ),
            SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'didnt_receive_code'.tr(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: remainingTime == '00:00' ? resendOTP : null,
                    child: Text(
                      'resend'.tr(),
                      style: TextStyle(
                        color: remainingTime == '00:00'
                            ? Color.fromARGB(255, 206, 122, 11)
                            : Colors.grey,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    remainingTime,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
