import 'package:testing/helper/customBackButton.dart';
import 'package:testing/views/DashBoardScreen.dart';
import 'package:testing/views/newPasswordScreen.dart'; // Update to your actual path
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class VerificationScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  VerificationScreen({required this.verificationId, required this.phoneNumber});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> codeControllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  final _formKey = GlobalKey<FormState>();
  bool _codeIsValid = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      codeControllers[i].addListener(() => _handleCodeInput(i));
    }
  }

  void _handleCodeInput(int index) {
    if (codeControllers[index].text.length == 1 && index < 5) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    } else if (codeControllers[index].text.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
  }

  void verifyCode() async {
    final code = codeControllers.map((controller) => controller.text).join();
    setState(() {
      _isLoading = true;
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: code,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      await _createOrRetrieveUser(widget.phoneNumber);
    } catch (e) {
      setState(() {
        _codeIsValid = false;
        _isLoading = false;
      });
      print('Verification failed: ${e.toString()}');
    }
  }

  Future<void> _createOrRetrieveUser(String phoneNumber) async {
    final response = await http.post(
      Uri.parse('https://emmerge-backend.vercel.app/api/users/phone'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone_number': phoneNumber,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      final userId = jsonResponse['userId'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', userId);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => DashboardScreen(userId: userId),
      ));
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Failed to create or retrieve user: ${response.body}');
    }
  }

  @override
  void dispose() {
    for (var controller in codeControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
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
                        'Verification',
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
                        'We have just sent you a 6-digit code to your phone number.',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontFamily: 'InstagramSans'),
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
                      return SizedBox(
                        width: 40,
                        child: TextFormField(
                          controller: codeControllers[index],
                          focusNode: focusNodes[index],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: _codeIsValid
                                    ? Color.fromRGBO(112, 77, 226, 1)
                                    : Colors.red,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: _codeIsValid
                                    ? Color.fromRGBO(112, 77, 226, 1)
                                    : Colors.red,
                              ),
                            ),
                            counterText: '',
                          ),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context)
                                  .requestFocus(focusNodes[index + 1]);
                            }
                          },
                          onFieldSubmitted: (value) {
                            if (index < 5) {
                              FocusScope.of(context)
                                  .requestFocus(focusNodes[index + 1]);
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ' ';
                            }
                            return null;
                          },
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 10),
                  if (!_codeIsValid)
                    Center(
                      child: Text(
                        'Verification code is invalid',
                        style: TextStyle(
                            color: Colors.red, fontFamily: 'InstagramSans'),
                      ),
                    ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : verifyCode,
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
                      onPressed: _isLoading
                          ? null
                          : () {
                        // Resend the code action
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
