import 'dart:async';
import 'dart:developer';

import 'package:actitivy_point_calculator/View/Custom%20Bottom%20NavigationBar/custom_bottom_nabar_screen.dart';
import 'package:actitivy_point_calculator/View/Home%20Screen/home_screen.dart';
import 'package:actitivy_point_calculator/View/Profile%20Selection%20Screen/profile_sclection_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Call method to check login status
  }

  // Method to check user login status
  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check both user and admin login statuses
    bool isUserLoggedIn = prefs.getBool('isLoggedIn') ?? false;
   
    log(isUserLoggedIn.toString());
    // Wait for 4 seconds, then navigate based on login status
    Timer(Duration(seconds: 2), () {
      if (isUserLoggedIn) {
        // Navigate to Admin HomeScreen
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => CustomBottomNabarScreen()));
      } else {
        // Navigate to Profile Selection Screen
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => ProfileSclectionScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 200),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Activity Point',
                      textStyle: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      speed: Duration(milliseconds: 100),
                    ),
                  ],
                  isRepeatingAnimation: true,
                  totalRepeatCount: 1,
                  pause: Duration(milliseconds: 500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
