import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommentsBottomSheet extends StatelessWidget {
  final String postId;

  CommentsBottomSheet({required this.postId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Comments',
              style: TextStyle(
                fontFamily: 'Instagram Sans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            // Add your comments widget here
            // For now, let's add a few placeholders
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/user.png'),
              ),
              title: Text(
                'Username',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('This is a comment'),
              trailing: SvgPicture.asset('assets/images/heart.svg'),
            ),
            // Add more ListTiles as per your design
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
