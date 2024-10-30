// lib/bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:project1/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: black1,
      showSelectedLabels: false, //선택된 라벨 사라짐
      showUnselectedLabels: false,//선택안된 라벨 사라짐
      currentIndex: currentIndex,
      unselectedItemColor: neonskyblue1,
      selectedItemColor: neonskyblue1,
      onTap: onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(FeatherIcons.user), label: 'User'),
        BottomNavigationBarItem(icon: Icon(FeatherIcons.penTool), label: 'Pen'),
        //BottomNavigationBarItem(icon: Icon(FeatherIcons.facebook), label: 'Facebook'),
      ],
    );
  }
}
