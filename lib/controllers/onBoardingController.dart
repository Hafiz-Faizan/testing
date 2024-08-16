// controllers/auth_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../models/onBoarding_model.dart';


class AuthController {
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final UserModel userModel = UserModel(
          email: user.email ?? 'No email',
          username: user.displayName ?? 'No username',
          googleId: user.uid,
        );

        final response = await _sendUserDetailsToBackend(userModel.toJsonGoogle(), 'google');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.body);
          var userId = data['userId'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('userId', userId);

          

          return user;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error during Google Sign-In: $e');
    }
  }

  Future<User?> signInWithApple() async {
    try {
      final AuthorizationCredentialAppleID appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthCredential credential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final UserModel userModel = UserModel(
          email: user.email ?? 'No email',
          username: user.displayName ?? 'No username',
          appleId: user.uid,
        );

        final response = await _sendUserDetailsToBackend(userModel.toJsonApple(), 'apple');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.body);
          var userId = data['userId'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('userId', userId);

          return user;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error during Apple Sign-In: $e');
    }
  }

  Future<http.Response> _sendUserDetailsToBackend(Map<String, dynamic> userDetails, String platform) {
    return http.post(
      Uri.parse('https://emmerge-backend.vercel.app/api/users/$platform'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userDetails),
    );
  }
}
