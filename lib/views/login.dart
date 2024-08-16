// views/sign_in_screen.dart
import 'package:testing/views/resetPassword.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:testing/helper/customBackButton.dart';

import '../controllers/sigin_controller.dart';
import '../models/sigin_model.dart';
import 'DashBoardScreen.dart';
import 'Phone_VerificationPage.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'US');
  bool _obscureText = true;

  String phoneError = '';
  String emailError = '';
  String passwordError = '';

  bool isPhoneLoading = false;
  bool isEmailLoading = false;

  final SignInController _controller = SignInController();

  void showToast(String message) {
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

  void validatePhoneNumber() {
    if (phoneController.text.isEmpty) {
      setState(() {
        phoneError = "Please enter a valid phone number";
      });
      return;
    }

    setState(() {
      phoneError = '';
      isPhoneLoading = true;
    });

    String completePhoneNumber = '${number.dialCode}${phoneController.text}';

    _controller.validatePhoneNumber(
      completePhoneNumber,
          (verificationId) {
        setState(() {
          isPhoneLoading = false;
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VerificationScreen(
              verificationId: verificationId,
              phoneNumber: completePhoneNumber,
            ),
          ),
        );
      },
          (errorMessage) {
        setState(() {
          isPhoneLoading = false;
        });
        showToast(errorMessage);
      },
    );
  }

  void validateEmailAndPassword() {
    setState(() {
      String email = emailController.text;
      String password = passwordController.text;

      if (!email.contains('@')) {
        emailError = "Please enter a valid email address";
      } else {
        emailError = '';
      }

      if (password.isEmpty) {
        passwordError = "Please enter a valid password";
      } else {
        passwordError = '';
      }

      if (emailError.isEmpty && passwordError.isEmpty) {
        signInUser(email, password);
      }
    });
  }

  Future<void> signInUser(String email, String password) async {
    setState(() {
      isEmailLoading = true;
    });

    SignInModel signInModel = SignInModel(email: email, password: password);

    _controller.signInWithEmail(
      signInModel,
          (userId) {
        setState(() {
          isEmailLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen(userId: (userId))),
        );
      },
          (errorMessage) {
        setState(() {
          isEmailLoading = false;
        });
        showToast("Error: $errorMessage");
      },
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomBackButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Begin your Emerge journey!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'InstagramSans',
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Enter the phone number associated with your Emerge account',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: phoneError.isEmpty
                          ? Color.fromRGBO(112, 77, 226, 1)
                          : Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {
                              setState(() {
                                this.number = number;
                              });
                            },
                            initialValue: number,
                            selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.DROPDOWN,
                              showFlags: true,
                              setSelectorButtonAsPrefixIcon: false,
                            ),
                            ignoreBlank: false,
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle: TextStyle(color: Colors.black),
                            textFieldController: phoneController,
                            formatInput: false,
                            inputDecoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 0, bottom: 10),
                              border: InputBorder.none,
                              hintText: '212-456-7890',
                            ),
                            countrySelectorScrollControlled: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                if (phoneError.isNotEmpty)
                  Text(
                    phoneError,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: validatePhoneNumber,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(112, 77, 226, 1),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: isPhoneLoading
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      'Continue with phone number',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                        child: Divider(
                          color: Colors.grey,
                          height: 36,
                        ),
                      ),
                    ),
                    Text(
                      "Instead",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                        child: Divider(
                          color: Colors.grey,
                          height: 36,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text('Email'),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: emailError.isEmpty
                            ? Color.fromRGBO(112, 77, 226, 1)
                            : Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: emailError.isEmpty
                                ? Color.fromRGBO(112, 77, 226, 1)
                                : Colors.red),
                      ),
                      hintText: 'example@gmail.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 5),
                if (emailError.isNotEmpty)
                  Text(
                    emailError,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                SizedBox(height: 10),
                Text('Password'),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: passwordError.isEmpty
                            ? Color.fromRGBO(112, 77, 226, 1)
                            : Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: passwordError.isEmpty
                                ? Color.fromRGBO(112, 77, 226, 1)
                                : Colors.red),
                      ),
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureText,
                  ),
                ),
                SizedBox(height: 5),
                if (passwordError.isNotEmpty)
                  Text(
                    passwordError,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
                      );
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(112, 77, 226, 1),
                        fontFamily: 'InstagramSans',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: validateEmailAndPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(112, 77, 226, 1),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: isEmailLoading
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      'Sign in',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
