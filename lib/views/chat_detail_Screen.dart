import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatDetailScreen extends StatelessWidget {
  final int currentUserId;
  final int otherUserId;
  final String userName;

  ChatDetailScreen({
    required this.currentUserId,
    required this.otherUserId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/images/profile.png'), // Placeholder image, replace with the actual user's profile image
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName),
                // Displaying user's online status (Placeholder functionality)
                Text('Active now',
                    style: TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ],
        ),
      ),
      body: ChatDetailBody(
        currentUserId: currentUserId,
        otherUserId: otherUserId,
      ),
    );
  }
}

class ChatDetailBody extends StatefulWidget {
  final int currentUserId;
  final int otherUserId;

  ChatDetailBody({
    required this.currentUserId,
    required this.otherUserId,
  });

  @override
  _ChatDetailBodyState createState() => _ChatDetailBodyState();
}

class _ChatDetailBodyState extends State<ChatDetailBody> {
  List<Map<String, dynamic>> _messages = [];
  late IO.Socket socket;
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecording = false;
  String? _recordingPath;

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _fetchMessageHistory();
    _setupSocketConnection();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _initRecorder();
    _initPlayer();

    // Listen to changes in the text field to update the send/mic icon
    _messageController.addListener(() {
      setState(() {
        _isTyping = _messageController.text.isNotEmpty;
      });
    });
  }

  Future<void> _initRecorder() async {
    await _recorder!.openRecorder();
    _recorder!.setSubscriptionDuration(const Duration(milliseconds: 10));
  }

  Future<void> _initPlayer() async {
    await _player!.openPlayer();
  }

  Future<void> _fetchMessageHistory() async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.0.108:4000/api/chat/message-history/${widget.currentUserId}/${widget.otherUserId}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _messages = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      // Handle error
    }
  }

  void _setupSocketConnection() {
    socket = IO.io('http://192.168.0.108:4000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
    socket.onConnect((_) {
      print('Connected to socket server');
      socket.emit('register', widget.currentUserId);
    });

    socket.on('chat_message', (data) {
      setState(() {
        _messages.add({
          'message': data['message'],
          'mediaUrl': data['mediaUrl'],
          'timestamp': data['timestamp'],
          'senderId': data['senderId'],
          'receiverId': widget.currentUserId,
        });
      });
    });

    socket.onDisconnect((_) {
      print('Disconnected from socket server');
    });

    socket.onConnectError((data) {
      print('Connect error: $data');
    });

    socket.onError((data) {
      print('Socket error: $data');
    });
  }

  Future<void> _sendMessage() async {
    String? mediaUrl;
    if (_selectedImage != null) {
      mediaUrl = await _uploadMedia(_selectedImage!.path);
      _selectedImage = null; // Reset after sending
    } else if (_recordingPath != null) {
      mediaUrl = await _uploadMedia(_recordingPath!);
      _recordingPath = null; // Reset after sending
    }

    final messageText = _messageController.text.trim();
    socket.emit('private_message', {
      'senderId': widget.currentUserId,
      'receiverId': widget.otherUserId,
      'message': messageText.isEmpty ? null : messageText,
      'mediaUrl': mediaUrl,
    });

    setState(() {
      _messages.add({
        'message': messageText,
        'mediaUrl': mediaUrl,
        'timestamp': DateTime.now().toString(),
        'senderId': widget.currentUserId,
        'receiverId': widget.otherUserId,
      });
      _messageController.clear();
    });
  }

  Future<String?> _uploadMedia(String filePath) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.0.108:4000/api/chat/upload-media'),
    );
    request.fields['senderId'] = widget.currentUserId.toString();
    request.fields['receiverId'] = widget.otherUserId.toString();
    request.fields['message'] = ''; // Empty message for images and audio

    request.files.add(
      await http.MultipartFile.fromPath('media', filePath),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      return jsonResponse['mediaUrl'];
    } else {
      // Handle error
      return null;
    }
  }

  Future<void> _startRecording() async {
    // Request microphone permission
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) {
        // Permission not granted, handle appropriately
        print("Microphone permission not granted");
        return;
      }
    }

    Directory tempDir = await getTemporaryDirectory();
    _recordingPath = '${tempDir.path}/flutter_sound.aac';

    await _recorder!.startRecorder(
      toFile: _recordingPath,
    );
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    if (_recorder!.isRecording) {
      await _recorder!.stopRecorder();
      setState(() {
        _isRecording = false;
      });
      _sendMessage(); // Send the voice message after stopping the recording
    }
  }

  Future<void> _playVoiceMessage(String url) async {
    await _player!.startPlayer(
      fromURI: url,
    );
  }

  Future<void> _stopPlaying() async {
    await _player!.stopPlayer();
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
      _sendMessage(); // Automatically send the image after picking
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
      _sendMessage(); // Automatically send the image after picking
    }
  }

  @override
  void dispose() {
    socket.dispose();
    _recorder!.closeRecorder();
    _player!.closePlayer();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              final isCurrentUser = message['senderId'] == widget.currentUserId;

              return ListTile(
                title: Align(
                  alignment: isCurrentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: isCurrentUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (message['mediaUrl'] != null &&
                          message['mediaUrl'].isNotEmpty)
                        if (message['mediaUrl'].endsWith('.aac'))
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.play_arrow, size: 30),
                                  onPressed: () =>
                                      _playVoiceMessage(message['mediaUrl']),
                                ),
                                IconButton(
                                  icon: Icon(Icons.stop, size: 30),
                                  onPressed: _stopPlaying,
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.6,
                              maxHeight: 150,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                message['mediaUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      if (message['message'] != null &&
                          message['message'].isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isCurrentUser
                                ? Colors.purple
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            message['message'] ?? '',
                            style: TextStyle(
                                color: isCurrentUser
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                    ],
                  ),
                ),
                subtitle: Align(
                  alignment: isCurrentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                    message['timestamp'],
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.purple, size: 30),
                onPressed: _pickImageFromCamera,
              ),
              IconButton(
                icon: Icon(Icons.image, color: Colors.purple, size: 30),
                onPressed: _pickImageFromGallery,
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 60, // Adjust the width of the button
                height: 60, // Adjust the height of the button
                child: _isTyping
                    ? IconButton(
                        icon: Icon(Icons.send, color: Colors.purple),
                        onPressed: _sendMessage,
                      )
                    : GestureDetector(
                        onLongPress: _startRecording,
                        onLongPressUp: _stopRecording,
                        child: Icon(Icons.mic, color: Colors.purple),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
