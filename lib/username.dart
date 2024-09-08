import 'package:flutter/material.dart';
import 'package:project1/theme.dart'; // Import the theme

class UsernamePage extends StatelessWidget {
  const UsernamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // 타이틀 가운데 정렬
        title: const Text('로그인'), // AppBar 타이틀
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
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 페이지 여백 추가
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // 상단 정렬
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60), // 상단에 여백 추가
            Text(
              '이메일 주소',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8), // 텍스트와 텍스트필드 사이의 간격
            const TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF333333), // 텍스트 필드의 배경 색상 설정
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16), // 이메일 필드와 비밀번호 필드 사이의 간격
            Text(
              '비밀번호 입력',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8), // 텍스트와 텍스트필드 사이의 간격
            const TextField(
              obscureText: true, // 비밀번호 입력 시 텍스트 숨김
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF333333), // 텍스트 필드의 배경 색상 설정
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8), // 비밀번호 필드와 비밀번호 재설정 링크 사이의 간격
            Align(
              alignment: Alignment.centerRight, // 오른쪽 정렬
              child: TextButton(
                onPressed: () {
                  // 비밀번호 재설정 클릭 시 동작 추가
                },
                child: const Text(
                  '비밀번호 재설정',
                  style: TextStyle(
                    color: Color(0xFF9D9D9D), // 텍스트 색상 설정
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32), // 비밀번호 필드와 확인 버튼 사이의 간격
            SizedBox(
              width: double.infinity, // 버튼을 전체 너비로 확장
              child: ElevatedButton(
                onPressed: () {
                  // 확인 버튼 클릭 시 동작 추가
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, // 테마에 정의된 색상 사용
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // 직사각형 모양으로 변경
                  ),
                ),
                child: const Text('확인'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
