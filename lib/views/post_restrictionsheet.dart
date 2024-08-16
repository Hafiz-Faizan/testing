import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OptionsBottomSheet extends StatelessWidget {
  final int postId;

  OptionsBottomSheet({required this.postId});
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    SvgPicture.asset('assets/images/Saved.svg'),
                    SizedBox(height: 8),
                    Text('Save'),
                  ],
                ),
                Column(
                  children: [
                    SvgPicture.asset('assets/images/qr-code.svg'),
                    SizedBox(height: 8),
                    Text('QR Code'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(),
            ListTile(
              leading: SvgPicture.asset('assets/images/eye-off.svg'),
              title: Text('Not Interested'),
              onTap: () {
                // Handle Not Interested action
              },
            ),
            ListTile(
              leading: SvgPicture.asset('assets/images/user.svg'),
              title: Text('About this account'),
              onTap: () {
                // Handle About this account action
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/images/alert-octagon.svg',
                color: Colors.red,
              ),
              title: Text(
                'Report',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                // Handle Report action
              },
            ),
            Divider(),
            ListTile(
              leading: SvgPicture.asset('assets/images/sliders.svg'),
              title: Text('Manage preferences'),
              onTap: () {
                // Handle Manage preferences action
              },
            ),
          ],
        ),
      ),
    );
  }
}
