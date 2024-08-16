// controllers/signup_controller.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_Signup_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpController {
  Future<http.Response> signUp(UserModel user) async {
    final response = await http.post(
      Uri.parse('https://emmerge-backend.vercel.app/api/users/create-user'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      final userId = responseData['userId'];

      // Store userId in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', userId);
    }

    return response;
  }
}
