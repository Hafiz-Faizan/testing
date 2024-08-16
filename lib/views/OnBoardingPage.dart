// views/onboarding_screen.dart
import 'package:testing/views/DashBoardScreen.dart';
import 'package:flutter/material.dart';
import 'package:testing/utils/constants.dart';
import 'package:testing/views/signup.dart';
import 'package:testing/views/login.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/onBoardingController.dart';


class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<String> imgList = [
    'assets/images/Frame_1.png',
    'assets/images/Frame_2.png',
    'assets/images/Frame 3.png',
  ];

  bool _isLoading = false; // Loading state
  final AuthController _authController = AuthController();

  void showToast(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.white),
          SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16.0),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'X',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = await _authController.signInWithGoogle();
      if (user != null) {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        int? userId = prefs.getInt('userId');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => DashboardScreen(userId: userId),
          ),
        );
      }
    } catch (e) {
      showToast('Error during Google Sign-In.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithApple() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = await _authController.signInWithApple();
      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => DashboardScreen(userId: int.parse(user.uid)),
          ),
        );
      }
    } catch (e) {
      showToast('Error during Apple Sign-In.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ImageSlideshow(
                  indicatorColor: Constants.primaryColor,
                  autoPlayInterval: 3000,
                  isLoop: true,
                  children: imgList.map((item) => Image.asset(item, fit: BoxFit.contain)).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.primaryColor,
                    foregroundColor: Constants.textColorOnPrimary,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => SignInScreen()));
                  },
                  child: Text('Sign in', style: TextStyle(fontSize: 18)),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300, height: 2)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.0),
                      child: Text("or Sign in with", style: TextStyle(color: Colors.grey.shade600)),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300, height: 2)),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(FontAwesomeIcons.google, Colors.red, onTap: _signInWithGoogle),
                    SizedBox(width: 16),
                    _buildSocialButton(FontAwesomeIcons.apple, Colors.black, onTap: _signInWithApple),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text("Haven't signed up yet?", style: TextStyle(color: Colors.black)),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => SignUpScreen()));
                },
                child: Text("Create an account", style: TextStyle(color: Constants.primaryColor)),
              ),
              SizedBox(height: 20),
            ],
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade300,
              ),
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.black26, size: 20),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => SignInScreen()));
                },
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Constants.primaryColor),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}
