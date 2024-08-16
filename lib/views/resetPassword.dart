// views/reset_password_screen.dart

import 'package:testing/helper/customBackButton.dart';
import 'package:testing/views/ResetPasswordValidation.dart';
import 'package:flutter/material.dart';
import '../controllers/reset_password_controller.dart';
import '../models/reset_password_model.dart';


class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEmailEmpty = true;

  final ResetPasswordController _controller = ResetPasswordController();

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      setState(() {
        _isEmailEmpty = _emailController.text.isEmpty;
      });
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  Future<void> _sendResetPasswordCode() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      ResetPasswordModel resetPasswordModel = ResetPasswordModel(email: _emailController.text);

      try {
        final response = await _controller.sendResetPasswordCode(resetPasswordModel);

        if (response.statusCode == 200) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ResetPasswordValidation(email: resetPasswordModel.email),
            ),
          );
        } else {
          showToast('Failed to send verification code');
        }
      } catch (e) {
        showToast('An error occurred');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
                        'Reset Password',
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
                        "Enter your email and we'll send you a code to reset your password.",
                        style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'InstagramSans'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 22),
                  Text(
                    'Email',
                    style: TextStyle(fontFamily: 'InstagramSans'),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "example@gmail.com",
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
                    validator: _validateEmail,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isEmailEmpty ? null : _sendResetPasswordCode,
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
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'InstagramSans',
                        ),
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
