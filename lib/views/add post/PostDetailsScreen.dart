import 'package:flutter/material.dart';
import 'dart:io';

class PostDetailsScreen extends StatelessWidget {
  final List<File> images;

  PostDetailsScreen({required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Post"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  height: 200,
                  child: images.length > 1
                      ? PageView(
                          children: images.map((image) {
                            return Image.file(image);
                          }).toList(),
                        )
                      : Image.file(images[0]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Write a caption",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text("Location"),
                  onTap: () {
                    // Add location selection functionality
                  },
                ),
                ListTile(
                  leading: Icon(Icons.tag),
                  title: Text("Tag people"),
                  onTap: () {
                    // Add tag people functionality
                  },
                ),
                SwitchListTile(
                  title: Text("Turn off commenting"),
                  value: false,
                  onChanged: (value) {
                    // Handle switch toggle
                  },
                ),
                SwitchListTile(
                  title: Text("Hide like count"),
                  value: false,
                  onChanged: (value) {
                    // Handle switch toggle
                  },
                ),
                ListTile(
                  leading: Icon(Icons.group),
                  title: Text("Audience"),
                  subtitle: Text("Everyone"),
                  onTap: () {
                    // Handle audience selection
                  },
                ),
                SwitchListTile(
                  title: Text("Only share to subscribers"),
                  value: false,
                  onChanged: (value) {
                    // Handle switch toggle
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle post sharing
              },
              child: Text("Share"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), backgroundColor: Color(0xFF704DE2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
