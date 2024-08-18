import 'package:flutter/material.dart';
import 'package:project1/theme.dart'; // Import the theme

class UsernamePage extends StatelessWidget {
  const UsernamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // 타이틀 가운데 정렬
        title: const Text('사용자 이름 설정'), // AppBar 타이틀
        actions: [
          TextButton(
            onPressed: () {
              // 완료 버튼 클릭 시 동작 추가
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, padding: EdgeInsets.zero, // 기본 패딩 제거
            ),
            child: const Text(
              '완료',
              style: TextStyle(
                color: AppColors.primary, // 버튼 텍스트 색상
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0), // 페이지 여백 추가
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8), // 텍스트와 텍스트필드 사이의 간격
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
