import 'dart:io';
import 'package:datalock/ui/screens/permissions_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as flutter_widgets;  // Add this import
import 'package:appwrite/appwrite.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/phone_input.dart';
import '../components/otp_input.dart';
import '../components/name_input.dart';
import '../components/login_input.dart';
import '../../config/config.dart';
import '../../data/data_sources/auth_data_source.dart';
import '../../data/repositories/auth_repository.dart';
import '../../services/auth_service.dart';
import 'terms_and_conditions.dart';
import 'privacy_policy.dart';

class AuthenticationScreen extends StatefulWidget {
  final Account account;
  final Databases databases;
  final Functions functions;

  const AuthenticationScreen({
    Key? key,
    required this.account,
    required this.databases,
    required this.functions,
  }) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  late AuthRepository _authRepository;
  late AuthService _authService;
  String? _userId;
  String? _phoneNumber;
  String? _platform;
  String? _ipadress;
  String? _name;
  String? _prenom;
  String? _entry_id;
  bool _isNewUser = true;  // New flag to track if it's a new user

  bool isNameScreen = false;
  bool isOtpScreen = false;
  bool isLoginScreen = false;

  @override
  void initState() {
    super.initState();
    final authDataSource = AuthDataSource(widget.account, widget.databases, widget.functions);
    _authRepository = AuthRepository(authDataSource);
    _authService = AuthService();
  }

  String getPlatform() {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'AND';
    if (Platform.isIOS) return 'IOS';
    return 'lin';
  }

    void _changeLanguage(String languageCode) async {
    await context.setLocale(flutter_widgets.Locale(languageCode));  // Use flutter_widgets.Locale
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', languageCode);
  }
  void _navigateToOtp(String name, String prenom, String phoneNumber) {
    setState(() {
      _name = name;
      _prenom = prenom;
      _phoneNumber = phoneNumber;
      isLoginScreen = false;
      isOtpScreen = true;
      _isNewUser = false;  // Set to false when navigating from login
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => PermissionsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: screenHeight,
              width: screenWidth,
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    right: 10,
                    child: PopupMenuButton<String>(
                      onSelected: _changeLanguage,
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem<String>(
                            value: 'en',
                            child: Text('English'),
                          ),
                          PopupMenuItem<String>(
                            value: 'fr',
                            child: Text('Français'),
                          ),
                          PopupMenuItem<String>(
                            value: 'ar',
                            child: Text('العربية'),
                          ),
                          PopupMenuItem<String>(
                            value: 'es',
                            child: Text('Español'),
                          ),
                        ];
                      },
                      child: Icon(Icons.more_vert, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.10,
                    left: 0,
                    right: 0,
                    child: Config.buildLogo(),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: screenHeight * 0.6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: isLoginScreen
                          ? LoginInput(
                              onBack: () => setState(() {
                                isLoginScreen = false;
                              }),
                              authRepository: _authRepository,
                              onOtpNavigate: _navigateToOtp,
                            )
                          : isOtpScreen
                              ? OtpInput(
                                  onBack: () => setState(() {
                                    isOtpScreen = false;
                                    isLoginScreen = true;
                                  }),
                                  onVerify: (String otp) async {
                                    // Implement OTP verification logic
                                  },
                                  phoneNumber: _phoneNumber ?? '',
                                  userId: _userId ?? '',
                                  name: _name,
                                  prenom: _prenom,
                                  entry_id: _entry_id ?? '',
                                  onSubmit: (String userId, String phoneNumber, String result, String? name, String? prenom) async {
                                    if (result == '200') {
                                      if (_isNewUser) {
                                        setState(() {
                                          _userId = userId;
                                          _phoneNumber = phoneNumber;
                                          _name = name;
                                          _prenom = prenom;
                                          isNameScreen = true;
                                          isOtpScreen = false;
                                        });
                                      } else {
                                        // For existing users, verify again
                                        Map<String, String> verifyResult = await _authService.verifyUser(
                                          name ?? '',
                                          prenom ?? '',
                                          phoneNumber,
                                          widget.account,
                                          widget.databases,
                                        );
                                        if (verifyResult['status'] == '200') {
                                          _navigateToHome();
                                        } else {
                                          setState(() {
                                            _userId = userId;
                                            _phoneNumber = phoneNumber;
                                            _name = name;
                                            _prenom = prenom;
                                            isNameScreen = true;
                                            isOtpScreen = false;
                                          });
                                        }
                                      }
                                    }
                                  },
                                )
                              : isNameScreen
                                  ? NameInput(
                                      onBack: () => setState(() {
                                        isNameScreen = false;
                                        isOtpScreen = true;
                                      }),
                                      onSubmit: () {
                                        // Handle name submit
                                        _navigateToHome();
                                      },
                                      userId: _userId ?? '',
                                      phoneNumber: _phoneNumber ?? '',
                                      authRepository: _authRepository,
                                      name: _name,
                                      prenom: _prenom,
                                      entry_id: _entry_id ?? '',
                                    )
                                  : Column(
                                    children: [
                                      PhoneInput(
                                          onSubmit: (String userId, String phoneNumber, String result, String entry_id) {
                                            print('Phone input result: $result');
                                            if (result == '200') {
                                              setState(() {
                                                _phoneNumber = phoneNumber;
                                                _platform = getPlatform();
                                                _ipadress = '255.255.255.255';
                                                _userId = userId;
                                                _entry_id = entry_id;
                                                isOtpScreen = true;
                                                _isNewUser = true;  // Set to true for new sign-ups
                                              });
                                            }
                                          },
                                          onLoginTap: () {
                                            setState(() {
                                              isLoginScreen = true;
                                            });
                                          },
                                          authRepository: _authRepository,
                                        ),
                                        Padding(
  padding: const EdgeInsets.symmetric(
      horizontal: 16.0, vertical: 8.0),
  child: RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      text: tr("En_vous_connectant_vous_acceptez_les"),
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
      children: [
        TextSpan(
          text: tr("conditions_générales_d_utilisations"),
          style: TextStyle(
            color: Colors.grey[600],
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TermsAndConditionsScreen(),
                ),
              );
            },
        ),
        TextSpan(
          text: tr("et_la"),
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        TextSpan(
          text: "politique_de_confidentialité".tr(),
          style: TextStyle(
            color: Colors.grey[600],
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacyPolicyScreen(),
                ),
              );
            },
        ),
        TextSpan(
          text: ".",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    ),
  ),
)

                                    ],
                                  ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
