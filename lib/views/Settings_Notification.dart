import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool recommendations = false;
  bool pauseAll = false;
  bool followingAndFollowers = false;
  bool messages = false;
  bool postsLikesAndComments = false;
  bool emailNotifications = false;
  bool fromEmerge = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      recommendations = prefs.getBool('recommendations') ?? false;
      pauseAll = prefs.getBool('pauseAll') ?? false;
      followingAndFollowers = prefs.getBool('followingAndFollowers') ?? false;
      messages = prefs.getBool('messages') ?? false;
      postsLikesAndComments = prefs.getBool('postsLikesAndComments') ?? false;
      emailNotifications = prefs.getBool('emailNotifications') ?? false;
      fromEmerge = prefs.getBool('fromEmerge') ?? false;
    });
  }

  Future<void> _savePreference(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(color: Colors.black)),
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
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Recommendations'),
            subtitle: Text('Receive recommendations based on your activity'),
            value: recommendations,
            activeColor: Colors.purple,
            onChanged: (bool value) {
              setState(() {
                recommendations = value;
              });
              _savePreference('recommendations', value);
            },
          ),
          Divider(thickness: 1, height: 1, color: Colors.grey.shade300),
          ListTile(
            title: Text(
              'Push notifications',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          SwitchListTile(
            title: Text('Pause all'),
            subtitle: Text('Temporarily pause notifications'),
            value: pauseAll,
            activeColor: Colors.purple,
            onChanged: (bool value) {
              setState(() {
                pauseAll = value;
              });
              _savePreference('pauseAll', value);
            },
          ),
          SwitchListTile(
            title: Text('Following and Followers'),
            value: followingAndFollowers,
            activeColor: Colors.purple,
            onChanged: (bool value) {
              setState(() {
                followingAndFollowers = value;
              });
              _savePreference('followingAndFollowers', value);
            },
          ),
          SwitchListTile(
            title: Text('Messages'),
            value: messages,
            activeColor: Colors.purple,
            onChanged: (bool value) {
              setState(() {
                messages = value;
              });
              _savePreference('messages', value);
            },
          ),
          SwitchListTile(
            title: Text('Posts, likes and comments'),
            value: postsLikesAndComments,
            activeColor: Colors.purple,
            onChanged: (bool value) {
              setState(() {
                postsLikesAndComments = value;
              });
              _savePreference('postsLikesAndComments', value);
            },
          ),
          Divider(thickness: 1, height: 1, color: Colors.grey.shade300),
          ListTile(
            title: Text(
              'Other notification types',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          SwitchListTile(
            title: Text('Email notifications'),
            value: emailNotifications,
            activeColor: Colors.purple,
            onChanged: (bool value) {
              setState(() {
                emailNotifications = value;
              });
              _savePreference('emailNotifications', value);
            },
          ),
          SwitchListTile(
            title: Text('From Emerge'),
            value: fromEmerge,
            activeColor: Colors.purple,
            onChanged: (bool value) {
              setState(() {
                fromEmerge = value;
              });
              _savePreference('fromEmerge', value);
            },
          ),
        ],
      ),
    );
  }
}
