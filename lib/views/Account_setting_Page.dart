import 'package:testing/views/Settings_About_Account.dart';
import 'package:testing/views/Settings_Account_Privacy.dart';
import 'package:testing/views/Settings_Delete_Account.dart';
import 'package:testing/views/Settings_Language_Screen.dart';
import 'package:testing/views/Settings_Notification.dart';
import 'package:testing/views/Settings_PrivacyPolicy.dart';
import 'package:flutter/material.dart';
import '../controllers/account_controller.dart';
import '../models/account_model.dart';
import 'OnBoardingPage.dart';
import 'Settings_change_password.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsController _controller = SettingsController();

  final UserModel userModel = UserModel(
    name: 'Syed Waqhat Noman',
    profileImagePath: 'assets/images/EMERGE LOGO EPS 1 copy.png',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(userModel.profileImagePath),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userModel.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle edit profile
                        },
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildDivider(),

            // Personal Info Section
            SettingsSection(
              title: 'Personal Info',
              tiles: [
                SettingsTile(
                  icon: Icons.person,
                  title: 'Profile',
                  onTap: () {
                    // Handle profile tap
                  },
                ),
                SettingsTile(
                  icon: Icons.lock,
                  title: 'Password',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SettingsChangePassword(),
                      ),
                    );
                  },
                ),
                SettingsTile(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NotificationsScreen(),
                      ),
                    );
                  },
                ),
                SettingsTile(
                  icon: Icons.privacy_tip,
                  title: 'Account Privacy',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AccountPrivacyScreen(),
                      ),
                    );
                  },
                ),
                SettingsTile(
                  icon: Icons.block,
                  title: 'Blocked Accounts',
                  onTap: () {

                  },
                ),
              ],
            ),
            _buildDivider(),

            // More Section
            SettingsSection(
              title: 'More',
              tiles: [
                SettingsTile(
                  icon: Icons.language,
                  title: 'Language',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LanguageSelectionScreen(),
                      ),
                    );
                  },
                ),
                SettingsTile(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {
                    // Handle help & support tap
                  },
                ),
                SettingsTile(
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PrivacyPolicyScreen(),
                      ),
                    );
                  },
                ),
                SettingsTile(
                  icon: Icons.question_answer,
                  title: 'Ask Questions',
                  onTap: () {
                    // Handle ask questions tap
                  },
                ),
                SettingsTile(
                  icon: Icons.info_outline,
                  title: 'About your account',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AboutYourAccountScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            _buildDivider(),

            // Account Section
            SettingsSection(
              title: 'Account',
              tiles: [
                SettingsTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    _showLogoutBottomSheet(context);
                  },
                  iconColor: Colors.green,
                ),
                SettingsTile(
                  icon: Icons.delete_outline,
                  title: 'Delete Account',
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DeleteAccountScreen(),
                        ),
                    );
                  },
                  iconColor: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.logout,
                size: 50,
                color: Colors.green,
              ),
              SizedBox(height: 10),
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Are you sure you want to logout from the app?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _controller.logout(() {
                        Navigator.pop(context); // Close the bottom sheet
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => OnboardingScreen(),
                          ),
                              (route) => false,
                        ); // Navigate to onboarding screen
                      });
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 10,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<SettingsTile> tiles;

  SettingsSection({required this.title, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Column(
            children: tiles,
          ),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color iconColor;

  SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
