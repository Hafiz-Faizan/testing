// views/signup_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import '../controllers/user_Signup_controller.dart';
import '../models/user_Signup_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'DashBoardScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  bool _rememberMe = false;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  final SignUpController _signUpController = SignUpController();

  Future<void> signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserModel user = UserModel(
          username: fullNameController.text,
          email: emailController.text,
          password: passwordController.text,
        );

        final response = await _signUpController.signUp(user);

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          final userId = responseData['userId'];

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen(userId: userId)),
          );

          Fluttertoast.showToast(
            msg: "Account created successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else if (response.statusCode == 200) {
          showToast("User Already exist kindly Sign-In");
        } else {
          showToast('Sign-up failed. Please try again.');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        showToast('An error occurred');
      }
    }
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // You can include the custom back button widget here
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 80),
                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'InstagramSans',
                        ),
                      ),
                    ],
                  ),
                  // Continue with the rest of the UI code...
                  // Full name, email, password, confirm password fields, etc.
                  SizedBox(height: 35),
                  Center(
                    child: Container(
                      width: 300,
                      child: Text(
                        'Please fill in the information below to create an account. It\'s a snap!',
                        style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'InstagramSans'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Full name', style: TextStyle(fontFamily: 'InstagramSans')),
                  TextFormField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color.fromRGBO(112, 77, 226, 1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color.fromRGBO(112, 77, 226, 1)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Email', style: TextStyle(fontFamily: 'InstagramSans')),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color.fromRGBO(112, 77, 226, 1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color.fromRGBO(112, 77, 226, 1)),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Password', style: TextStyle(fontFamily: 'InstagramSans')),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color.fromRGBO(112, 77, 226, 1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color.fromRGBO(112, 77, 226, 1)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureTextPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureTextPassword = !_obscureTextPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureTextPassword,
                    validator: (value) {
                      if (value == null || value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Confirm Password', style: TextStyle(fontFamily: 'InstagramSans')),
                  TextFormField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color.fromRGBO(112, 77, 226, 1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color.fromRGBO(112, 77, 226, 1)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureTextConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureTextConfirmPassword,
                    validator: (value) {
                      if (value == null || value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (bool? value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      Text('Remember me', style: TextStyle(fontFamily: 'InstagramSans')),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (bool? value) {
                          setState(() {
                            _agreeToTerms = value ?? false;
                          });
                        },
                      ),
                      Flexible(
                        child: Text('I agree to all the Terms and Privacy policy', style: TextStyle(fontFamily: 'InstagramSans')),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(112, 77, 226, 1),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : Text(
                        'Next',
                        style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'InstagramSans'),
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
