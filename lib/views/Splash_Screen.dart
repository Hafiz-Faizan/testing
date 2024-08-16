
import 'package:testing/utils/Constants.dart';
import 'package:testing/views/DashBoardScreen.dart';
import 'package:testing/views/OnBoardingPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    //Delay for splash screen effect
    await Future.delayed(Duration(seconds: 3));

    // Check if userId exists in SharedPreferences
    if (userId != null) {
      // If userId is found, navigate to DashboardScreen with userId as a prop
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => DashboardScreen(userId: userId)),
      );
    } else {
     // If no userId, navigate to SignInScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => OnboardingScreen()),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform(
                  transform: Matrix4.identity()..rotateZ(-0.05), // Slight tilt effect
                  alignment: FractionalOffset.center,
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text(
                              'connect',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'BrushScriptMT',
                                fontSize: screenWidth * 0.2, // Responsive font size
                                fontWeight: FontWeight.w600,
                                color: Constants.primaryColor,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                    color: Constants.primaryColor.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: screenWidth * 0.05), // Shift "beyond" to the right
                              child: Text(
                                'beyond',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'BrushScriptMT',
                                  fontSize: screenWidth * 0.2, // Responsive font size
                                  fontWeight: FontWeight.w600,
                                  color: Constants.secondaryColor,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 2.0,
                                      color: Constants.secondaryColor.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
          Positioned(
            bottom: 30, // Position the logo at the bottom
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset('assets/images/EMERGE LOGO EPS 1.png', width: 100, height: 100), // Adjust size if needed
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
