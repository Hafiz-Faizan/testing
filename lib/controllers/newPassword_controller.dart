// controllers/reset_password_controller.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/newPassword_mode.dart';

class ResetPasswordController {
  Future<http.Response> resetPassword(ResetPasswordModel resetPasswordModel) async {
    final response = await http.post(
      Uri.parse('https://emmerge-backend.vercel.app/api/users/forget-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(resetPasswordModel.toJson()),
    );

    return response;
  }
}
