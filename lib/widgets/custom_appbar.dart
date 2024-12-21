// lib/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:project1/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton; // 뒤로가기 버튼을 표시할지 여부
  final VoidCallback? onBackPressed; // 뒤로가기 버튼 동작을 커스터마이징할 수 있는 콜백

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false, // 기본값은 false
    this.onBackPressed, // 콜백 함수 추가
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
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: onBackPressed ?? () => Navigator.pop(context), // 기본 동작은 Navigator.pop(context)
      )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
