// lib/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:project1/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton; // 뒤로가기 버튼을 표시할지 여부

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false, // 기본값은 false
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: black1,
      title: Text(
        title,
        style: const TextStyle(
          color: white1,
        ),
      ),
      iconTheme: const IconThemeData(
        color: neonskyblue1,
      ),
      leading: showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
