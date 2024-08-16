
import 'package:testing/views/Settings_ForgetPasswordScreen.dart';
import 'package:flutter/material.dart';

class SettingsChangePassword extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<SettingsChangePassword> {
  final TextEditingController currentPasswordController =
  TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPasswordInputField(
              label: 'Current Password',
              controller: currentPasswordController,
              isPasswordVisible: isCurrentPasswordVisible,
              togglePasswordVisibility: () {
                setState(() {
                  isCurrentPasswordVisible = !isCurrentPasswordVisible;
                });
              },
            ),
            SizedBox(height: 16),
            _buildPasswordInputField(
              label: 'New Password',
              controller: newPasswordController,
              isPasswordVisible: isNewPasswordVisible,
              togglePasswordVisibility: () {
                setState(() {
                  isNewPasswordVisible = !isNewPasswordVisible;
                });
              },
            ),
            SizedBox(height: 16),
            _buildPasswordInputField(
              label: 'Confirm Password',
              controller: confirmPasswordController,
              isPasswordVisible: isConfirmPasswordVisible,
              togglePasswordVisibility: () {
                setState(() {
                  isConfirmPasswordVisible = !isConfirmPasswordVisible;
                });
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Forgot password logic
                },
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: Color(0xFF6A4EFF),
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => SettingsForgetpasswordscreen(),
                        ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Button color
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordInputField({
    required String label,
    required TextEditingController controller,
    required bool isPasswordVisible,
    required VoidCallback togglePasswordVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: togglePasswordVisibility,
        ),
      ),
    );
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
