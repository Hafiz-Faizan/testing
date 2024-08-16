// models/user_Signup_model.dart
class UserModel {
  final String username;
  final String email;
  final String password;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      password: json['password'],
    );
  }
}
