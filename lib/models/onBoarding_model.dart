// models/user_model.dart
class UserModel {
  final String email;
  final String username;
  final String googleId;
  final String appleId;

  UserModel({required this.email, required this.username, this.googleId = '', this.appleId = ''});

  Map<String, dynamic> toJsonGoogle() {
    return {
      'email': email,
      'username': username,
      'google_id': googleId,
    };
  }

  Map<String, dynamic> toJsonApple() {
    return {
      'email': email,
      'username': username,
      'apple_id': appleId,
    };
  }
}
