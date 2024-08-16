// controllers/reset_password_controller.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/reset_password_model.dart';


class ResetPasswordController {
  Future<http.Response> sendResetPasswordCode(ResetPasswordModel resetPasswordModel) async {
    final response = await http.post(
      Uri.parse('https://emmerge-backend.vercel.app/api/users/send-code'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(resetPasswordModel.toJson()),
    );

    return response;
  }
}
