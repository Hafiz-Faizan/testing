import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chat_detail_screen.dart';

class User {
  final int userId;
  final String username;
  final String fullName;
  final String imageUrl;

  User({
    required this.userId,
    required this.username,
    required this.fullName,
    required this.imageUrl,
  });
}

class ChatSearchScreen extends StatefulWidget {
  final int currentUserId;

  ChatSearchScreen({required this.currentUserId});

  @override
  _ChatSearchScreenState createState() => _ChatSearchScreenState();
}

class _ChatSearchScreenState extends State<ChatSearchScreen> {
  List<User> _users = [];
  List<User> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    print('search');
    final response = await http.get(
      Uri.parse('http://192.168.0.108:4000/api/chat/all-users'),
    );

    if (response.statusCode == 200) {
      print('succces search');
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _users = data
            .map((user) => User(
                  userId: user['id'] ?? 0,
                  username:
                      user['username'] ?? 'Unknown', // Handle null username
                  fullName: user['fullName'] ??
                      user['username'] ??
                      'Unknown', // Handle null fullName
                  imageUrl: user['imageUrl'] ??
                      'assets/images/user_placeholder.png', // Handle null imageUrl
                ))
            .toList();
        _filteredUsers = _users; // Initially, show all users
      });
    } else {
      // Handle error
      print("Error fetching users: ${response.statusCode}");
    }
  }

  void _searchUsers(String query) {
    setState(() {
      _filteredUsers = _users.where((user) {
        final searchText = query.toLowerCase();
        final username = user.username.toLowerCase();
        final fullName = user.fullName.toLowerCase();
        return username.startsWith(searchText) ||
            fullName.startsWith(searchText);
      }).toList();
    });
  }

  void _openChatDetail(User user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(
          currentUserId: widget.currentUserId,
          otherUserId: user.userId,
          userName: user.fullName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: 'Search',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _searchUsers,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(user.imageUrl),
                  ),
                  title: Text(user.username),
                  subtitle: Text(user.fullName),
                  onTap: () => _openChatDetail(user),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
