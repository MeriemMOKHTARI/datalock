import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import './intro_page_1.dart';
import './intro_page_2.dart';
import './intro_page_3.dart';
import './authentication_screen.dart';
import 'package:appwrite/appwrite.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!onLastPage)
                  GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: const Text('skip')
                  )
                else
                  const SizedBox(width: 50),

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

                onLastPage
                  ? GestureDetector(
                      onTap: () {
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
                      },
                      child: const Text('done')
                    )
                  : GestureDetector(
                      onTap: () {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.easeIn
                        );
                      },
                      child: const Text('next')
                    ),
              ],
            )
          ),
        ],
      )
    );
  }
}

