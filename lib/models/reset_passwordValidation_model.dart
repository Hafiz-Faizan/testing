// models/reset_password_model.dart
class ResetPasswordModel {
  final String email;
  final String code;

  ResetPasswordModel({required this.email, required this.code});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'code': code,
    };
  }
}
