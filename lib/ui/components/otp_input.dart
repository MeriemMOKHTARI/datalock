import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../widgets/otp_field.dart';
import '../widgets/custom_button.dart';

class OtpInput extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onVerify;
  final String phoneNumber;
  final String userId;
  final AuthRepository authRepository;

  const OtpInput({
    Key? key,
    required this.onBack,
    required this.onVerify,
    required this.phoneNumber,
    required this.userId,
    required this.authRepository,
  }) : super(key: key);

  @override
  _OtpInputState createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final List<TextEditingController> otpControllers =
      List.generate(4, (index) => TextEditingController());
  String remainingTime = '';



  @override
  void initState() {
    super.initState();
    // sendOTP();
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





  @override
  Widget build(BuildContext context) {
    String otp = otpControllers.map((e) => e.text).join('');

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
              // onPressed: () => verifyOTP(otp),
              //PASSER DIRECTTT
              onPressed:widget.onVerify,
             
              text: 'verify'.tr(),
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
                    onPressed: (){},
                    // sendOTP,
                    child: Text(
                     'resend'.tr(),
                      style: TextStyle(
                        color: Color.fromARGB(255, 206, 122, 11),
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