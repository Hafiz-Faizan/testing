// models/reset_password_model.dart
class ResetPasswordModel {
  final String email;

  ResetPasswordModel({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
