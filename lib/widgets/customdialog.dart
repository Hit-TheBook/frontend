import 'package:flutter/material.dart';
import 'package:project1/colors.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content; // Widget 타입으로 content 받음
  final VoidCallback onConfirm;

  const CustomDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: content, // 전달된 content를 그대로 사용
      actions: <Widget>[
        TextButton(
          onPressed: onConfirm,
          child: const Text('확인', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
      backgroundColor: gray1,
    );
  }
}
