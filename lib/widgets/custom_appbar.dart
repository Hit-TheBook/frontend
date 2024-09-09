// lib/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:project1/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: black1, // AppBar의 배경색을 검정색으로 설정
      title: Text(
        title,
        style: const TextStyle(
          color: white1, // 타이틀 텍스트의 색깔을 흰색으로 설정
        ),
      ),
      iconTheme: const IconThemeData(
        color: neonskyblue1, // 뒤로가기 아이콘의 색깔을 설정
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
