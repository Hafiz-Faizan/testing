// models/user_Signup_model.dart
class UserModel {
  final String phoneNumber;
  var userId; // Ensure this is correctly defined

  UserModel({required this.phoneNumber, required this.userId});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phoneNumber: json['phone_number'],
      userId: json['userId'], // Ensure it's a string
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'userId': userId,
    };
  }

  // Getter for userId (if needed)
  String get getUserId => userId;
}
