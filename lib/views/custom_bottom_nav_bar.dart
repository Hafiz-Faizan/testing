import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomBottomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: Container(
        height: 50.0, // Adjusted height to make more room for the FAB
        padding: EdgeInsets.symmetric(horizontal: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(
              iconPath: 'assets/images/Home.png',
              index: 0,
            ),
            _buildNavItem(
              iconPath: 'assets/images/SearchOutline.png',
              index: 1,
            ),
            SizedBox(width: 40), // Space for the FAB
            _buildNavItem(
              iconPath: 'assets/images/chat.png',
              index: 2,
            ),
            _buildNavItem(
              iconPath: 'assets/images/profile.png',
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required int index,
  }) {
    return IconButton(
      icon: Image.asset(
        iconPath,
        color: selectedIndex == index ? Color(0xFF704DE2) : Colors.grey,
        height: 24.0, // Ensure icons have a reasonable size
        width: 24.0,
      ),
      onPressed: () => onItemTapped(index),
    );
  }
}
