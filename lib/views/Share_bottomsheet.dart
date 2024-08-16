import 'package:flutter/material.dart';

class ShareBottomSheet extends StatelessWidget {
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
            // Add your share options here
            // Let's add some placeholder widgets
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
              ),
              itemCount: 12, // Replace with actual count
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/user.png'),
                    ),
                    SizedBox(height: 4),
                    Text('Name'),
                  ],
                );
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.link),
                Icon(Icons.share),
                Icon(Icons.download),
                Icon(Icons.copy),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
