import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPrivacyScreen extends StatefulWidget {
  @override
  _AccountPrivacyScreenState createState() => _AccountPrivacyScreenState();
}

class _AccountPrivacyScreenState extends State<AccountPrivacyScreen> {
  bool isPrivateAccount = false;

  @override
  void initState() {
    super.initState();
    _loadPrivateAccountSetting();
  }

  Future<void> _loadPrivateAccountSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isPrivateAccount = prefs.getBool('isPrivateAccount') ?? false;
    });
  }

  Future<void> _savePrivateAccountSetting(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPrivateAccount', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account privacy',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text(
                'Private account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: isPrivateAccount,
              activeColor: Colors.purple,
              onChanged: (bool value) {
                setState(() {
                  isPrivateAccount = value;
                });
                _savePrivateAccountSetting(value);
              },
            ),
            SizedBox(height: 8),
            Text(
              'When your account is public, your profile and posts can be seen by anyone, on or off Emerge, if they don\'t have an Emerge account.\n\n'
                  'When your account is private, only the followers that you approve can see what you share.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
