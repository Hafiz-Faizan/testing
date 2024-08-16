import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('YOUR AGREEMENT'),
            SizedBox(height: 8),
            _buildSectionContent(
              'By using this Site, you agree to be bound by, and to comply with, these Terms and Conditions. '
                  'If you do not agree to these Terms and Conditions, please do not use this site.\n\n'
                  'PLEASE NOTE: We reserve the right, at our sole discretion, to change, modify or otherwise alter these Terms and Conditions at any time. '
                  'Unless otherwise indicated, amendments will become effective immediately. Please review these Terms and Conditions periodically. '
                  'Your continued use of the Site following the posting of changes and/or modifications will constitute your acceptance of the revised Terms and Conditions '
                  'and the reasonableness of these standards for notice of changes. For your information, this page was last updated as of the date at the top of these terms and conditions.',
            ),
            SizedBox(height: 16),
            _buildSectionTitle('PRIVACY'),
            SizedBox(height: 8),
            _buildSectionContent(
              'Please review our Privacy Policy, which also governs your visit to this Site, to understand our practices.',
            ),
            SizedBox(height: 16),
            _buildSectionTitle('LINKED SITES'),
            SizedBox(height: 8),
            _buildSectionContent(
              'This Site may contain links to other independent third-party Web sites ("Linked Sites"), provided solely as a convenience to our visitors.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[700],
      ),
    );
  }
}
