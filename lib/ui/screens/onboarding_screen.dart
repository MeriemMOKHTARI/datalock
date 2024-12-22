import 'package:datalock/ui/components/phone_input.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import './intro_page_1.dart';
import './intro_page_2.dart';
import './intro_page_3.dart';
import './authentication_screen.dart';
import 'package:appwrite/appwrite.dart';
import '../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  void initState() {
    super.initState();
    _checkFirstSeen();
  }

  Future<void> _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);

    if (seen) {
      // Si déjà vu, aller directement à AuthenticationScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AuthenticationScreen(
            account: Account(Client()),
            databases: Databases(Client()),
            functions: Functions(Client()),
          ),
        ),
      );
    }
  }

  Future<void> _markAsSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', true);
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Pages de l'onboarding
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),

          // Bouton Skip en haut à droite
          if (!onLastPage)
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: () {
                  _controller.jumpToPage(2);
                },
                child: Text(
                  'Skip'.tr(),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

          // Indicateur de page et bouton Next/Done au centre en bas
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Page indicator
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(
                    activeDotColor: const Color.fromARGB(255, 2, 33, 46),
                    dotColor: Colors.grey.shade300,
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                ),
                const SizedBox(height: 20),
                // Bouton Next/Done
                CustomButton(
                  onPressed: () {
                    if (onLastPage) {
                      _markAsSeen();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthenticationScreen(
                            account: Account(Client()),
                            databases: Databases(Client()),
                            functions: Functions(Client()),
                          ),
                        ),
                      );
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  text: onLastPage ? 'Done'.tr() : 'Next'.tr(),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}

