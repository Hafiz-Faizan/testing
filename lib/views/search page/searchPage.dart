import 'package:testing/views/DashBoardScreen.dart';
import 'package:testing/views/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SearchPage extends StatelessWidget {
  final int userId;

  SearchPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for people, posts, tags...',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Search Page for user: $userId'),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 1, // Index of the search tab
        onItemTapped: (index) {
          // Handle navigation based on the index
          if (index == 0) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashboardScreen(userId: userId),)); // Navigate to Dashboard
          } else if (index == 2) {
            // Navigate to chat page
          } else if (index == 3) {
            // Navigate to profile page
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: FloatingActionButton(
          onPressed: () {
            // Handle FAB action (e.g., navigate to add post screen)
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF704DE2),
          shape: CircleBorder(),
          elevation: 5.0,
        ),
      ),
    );
  }
}
