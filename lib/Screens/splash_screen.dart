import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'login_screen.dart';

class SplashAnimated extends StatelessWidget {
  const SplashAnimated({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: 200,
      backgroundColor: Colors.white,
      pageTransitionType: PageTransitionType.topToBottom,
      splashTransition: SplashTransition.rotationTransition,
      splash: const CircleAvatar(
        radius: 165,
        backgroundImage: AssetImage("assets/images/splash_screen.png"),
      ),
      nextScreen: const LoginScreen(),
      duration: 5000,
      animationDuration: const Duration(seconds: 5),
    );
  }
}
