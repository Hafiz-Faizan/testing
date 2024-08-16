import 'package:testing/views/add%20post/PostDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class SelectPictureScreen extends StatefulWidget {
  final File? selectedImage;

  SelectPictureScreen({this.selectedImage});

  @override
  _SelectPictureScreenState createState() => _SelectPictureScreenState();
}

class _SelectPictureScreenState extends State<SelectPictureScreen> {
  List<File> _selectedImages = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.selectedImage != null) {
      _selectedImages.add(widget.selectedImage!);
    }
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((file) => File(file.path)).toList());
      });
    }
  }

  void _navigateToPostDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailsScreen(images: _selectedImages),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Post"),
        actions: [
          TextButton(
            onPressed: _navigateToPostDetails,
            child: Text("Next", style: TextStyle(color: Colors.blue)),
          )
        ],
      ),
      body: Column(
        children: [
          if (_selectedImages.isNotEmpty)
            Container(
              height: 200,
              child: Image.file(_selectedImages[0]),
            ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Image.file(_selectedImages[index]);
              },
            ),
          ),
          ElevatedButton.icon(
            onPressed: _pickImages,
            icon: Icon(Icons.add_photo_alternate),
            label: Text("Select from Gallery"),
          ),
        ],
      ),
    );
  }
}
