// views/new_password_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import '../controllers/newPassword_controller.dart';
import '../models/newPassword_mode.dart';
import 'login.dart';
import 'package:testing/helper/customBackButton.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;

  NewPasswordScreen({required this.email});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  bool _isLoading = false;

  final ResetPasswordController _controller = ResetPasswordController();

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

  Future<void> _resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      ResetPasswordModel resetPasswordModel = ResetPasswordModel(
        email: widget.email,
        newPassword: _passwordController.text,
      );

      try {
        final response = await _controller.resetPassword(resetPasswordModel);

        if (response.statusCode == 200) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => SignInScreen(),
            ),
          );
        } else {
          final responseBody = jsonDecode(response.body);
          showToast(responseBody['message'] ?? 'An error occurred');
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                      CustomBackButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 80),
                      Text(
                        'New Password',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'InstagramSans',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 45),
                  Center(
                    child: Container(
                      width: 300,
                      child: Text(
                        'Your new password must be different from previously used passwords',
                        style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'InstagramSans'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Password',
                    style: TextStyle(fontFamily: 'InstagramSans'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
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
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Confirm Password',
                    style: TextStyle(fontFamily: 'InstagramSans'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _confirmPasswordController,
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
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(112, 77, 226, 1),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        'Save',
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
