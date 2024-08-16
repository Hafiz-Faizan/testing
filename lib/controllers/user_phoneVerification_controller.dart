// controllers/verification_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_phoneVerification_model.dart';

class VerificationController {
  Future<void> verifyCode({
    required String verificationId,
    required List<String> code,
    required String phoneNumber,
    required Function(UserModel user) onSuccess,
    required Function(String message) onError,
  }) async {
    final verificationCode = code.join();
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: verificationCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      _createOrRetrieveUser(phoneNumber, onSuccess, onError);
    } catch (e) {
      onError('Verification failed: ${e.toString()}');
    }
  }

  Future<void> _createOrRetrieveUser(
    String phoneNumber,
    Function(UserModel user) onSuccess,
    Function(String message) onError,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://emmerge-backend.vercel.app/api/users/phone'), // Replace with your API endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phone_number': phoneNumber,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final user = UserModel.fromJson(jsonResponse);
        print('nnsjkdjk');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId',
            int.parse(user.userId)); // Convert to int if storing as an integer
        onSuccess(user);
      } else {
        onError('Failed to create or retrieve user: ${response.body}');
      }
    } catch (e) {
      onError('An error occurred: ${e.toString()}');
    }
  }

  Future<void> resendCode({
    required String phoneNumber,
    required Function(String newVerificationId) onCodeSent,
    required Function(String message) onError,
  }) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      onError('An error occurred. Please try again.');
    }
  }
}
