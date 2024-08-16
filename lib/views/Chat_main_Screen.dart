// import 'dart:convert';
// import 'package:testing/views/chat_search_Screen.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'chat_detail_screen.dart';

// class Chat {
//   final int userId;
//   final String username;
//   final String latestMessage;
//   final String timestamp;
//   final String imageUrl;

//   Chat({
//     required this.userId,
//     required this.username,
//     required this.latestMessage,
//     required this.timestamp,
//     required this.imageUrl,
//   });
// }

// class ChatScreen extends StatefulWidget {
//   final int currentUserId;

//   ChatScreen({required this.currentUserId});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   List<Chat> _chats = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchChatHistory();
//   }

//   Future<void> _fetchChatHistory() async {
//     try {
//       print('jjksdkjdjks');
//       final response = await http.get(
//         Uri.parse(
//             'http://192.168.0.108:4000/api/chat/chat-history/${widget.currentUserId}'),
//       );

//       if (response.statusCode == 200) {
//         print('succes');
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _chats = data.map((chat) {
//             return Chat(
//               userId: chat['userId'],
//               username: chat['username'] ?? 'Unknown',
//               latestMessage: chat['latestMessage'] ?? '',
//               timestamp: chat['messageTime'] ?? '',
//               imageUrl: 'assets/images/profile.png',
//             );
//           }).toList();
//         });
//       } else {
//         // Handle error, maybe show a dialog or a toast
//         print('Failed to load chat history');
//       }
//     } catch (e) {
//       // Handle exceptions (like network errors)
//       print('Error fetching chat history: $e');
//     }
//   }

//   void _openChatDetail(Chat chat) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => ChatDetailScreen(
//           currentUserId: widget.currentUserId,
//           otherUserId: chat.userId,
//           userName: chat.username,
//         ),
//       ),
//     );
//   }

//   void _openSearchScreen() {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) =>
//             ChatSearchScreen(currentUserId: widget.currentUserId),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Chats',
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           // Search Bar
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: GestureDetector(
//               onTap: _openSearchScreen,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 height: 48,
//                 child: Row(
//                   children: [
//                     Icon(Icons.search, color: Colors.grey),
//                     SizedBox(width: 8),
//                     Text('Search', style: TextStyle(color: Colors.grey)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: _chats.isEmpty
//                 ? Center(child: Text('No messages found'))
//                 : ListView.builder(
//                     itemCount: _chats.length,
//                     itemBuilder: (context, index) {
//                       final chat = _chats[index];
//                       return ListTile(
//                         leading: CircleAvatar(
//                           backgroundImage: AssetImage(chat.imageUrl),
//                         ),
//                         title: Text(chat.username),
//                         subtitle: Text(chat.latestMessage),
//                         onTap: () => _openChatDetail(chat),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
