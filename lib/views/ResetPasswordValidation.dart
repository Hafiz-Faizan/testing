// views/reset_password_validation.dart
import 'package:testing/helper/customBackButton.dart';
import 'package:flutter/material.dart';

import '../controllers/reset_passwordValidation_contorller.dart';
import '../models/reset_passwordValidation_model.dart';
import 'newPasswordScreen.dart';

class ResetPasswordValidation extends StatefulWidget {
  final String email;

  ResetPasswordValidation({required this.email});

  @override
  _ResetPasswordValidationState createState() => _ResetPasswordValidationState();
}

class _ResetPasswordValidationState extends State<ResetPasswordValidation> {
  final List<TextEditingController> codeControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  final _formKey = GlobalKey<FormState>();
  bool _codeIsValid = true;
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

  Future<void> _verifyCode() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      String code = codeControllers.map((controller) => controller.text).join();

      try {
        ResetPasswordModel resetPasswordModel = ResetPasswordModel(
          email: widget.email,
          code: code,
        );

        final response = await _controller.verifyCode(resetPasswordModel);

        if (response.statusCode == 200) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => NewPasswordScreen(email: widget.email),
            ),
          );
        } else {
          setState(() {
            _codeIsValid = false;
          });
        }
      } catch (e) {
        setState(() {
          _codeIsValid = false;
        });
        showToast('Error during verification');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _moveToNextField({required String value, required int index}) {
    if (value.length == 1) {
      if (index < 5) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      } else {
        focusNodes[index].unfocus();
      }
    } else if (value.isEmpty) {
      if (index > 0) {
        FocusScope.of(context).requestFocus(focusNodes[index - 1]);
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
                        'We have just sent you a 6-digit code to ${widget.email}',
                        style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'InstagramSans'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Enter the code',
                    style: TextStyle(fontFamily: 'InstagramSans'),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: TextFormField(
                            controller: codeControllers[index],
                            focusNode: focusNodes[index],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: _codeIsValid ? Color.fromRGBO(112, 77, 226, 1) : Colors.red,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: _codeIsValid ? Color.fromRGBO(112, 77, 226, 1) : Colors.red,
                                ),
                              ),
                              counterText: '',
                            ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            onChanged: (value) {
                              _moveToNextField(value: value, index: index);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ' ';
                              }
                              return null;
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 10),
                  if (!_codeIsValid)
                    Center(
                      child: Text(
                        'Verification code is invalid',
                        style: TextStyle(color: Colors.red, fontFamily: 'InstagramSans'),
                      ),
                    ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _verifyCode,
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
                  SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Resend the code action
                        // emailAuth.sendOtp(recipientMail: widget.email);
                      },
                      child: Text(
                        'Resend Code',
                        style: TextStyle(
                          color: Color.fromRGBO(112, 77, 226, 1),
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
