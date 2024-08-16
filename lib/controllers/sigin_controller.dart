// controllers/sign_in_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sigin_model.dart';


class SignInController {
  Future<void> signInWithEmail(
      SignInModel signInModel,
      Function onSuccess,
      Function(String) onError,
      ) async {
    try {
      final url = Uri.parse('https://emmerge-backend.vercel.app/api/users/signin');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(signInModel.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final userId = responseData['userId'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', userId);

        onSuccess(userId);
      } else {
        final responseData = jsonDecode(response.body);
        final errorMessage = responseData['message'];
        onError(errorMessage);
      }
    } catch (e) {
      onError('An error occurred. Please try again.');
    }
  }

  Future<void> validatePhoneNumber(
      String phoneNumber,
      Function(String verificationId) onSuccess,
      Function(String) onError,
      ) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError('Enter the correct Phone Number');
        },
        codeSent: (String verificationId, int? resendToken) {
          onSuccess(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      onError('An error occurred. Please try again.');
    }
  }
}
