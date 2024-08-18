import 'package:flutter/material.dart';
import 'package:project1/theme.dart'; // Import the theme
import 'package:project1/username.dart'; // Import the UsernamePage

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // 타이틀 가운데 정렬
        title: const Text('시작하기'), // AppBar 타이틀
      ),
      body: SingleChildScrollView(  // Scroll 가능하게 변경
        child: Padding(
          padding: const EdgeInsets.all(16.0), // 페이지 여백 추가
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '이메일 주소',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8), // 텍스트와 텍스트필드 사이의 간격
              Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8), // 텍스트필드와 버튼 사이의 간격
                  ElevatedButton(
                    onPressed: () {
                      // 버튼 클릭 시 동작 추가
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary, // 테마에 정의된 색상 사용
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // 직사각형 모양으로 변경
                      ),
                    ),
                    child: const Text('인증번호 받기'),
                  ),
                ],
              ),
              const SizedBox(height: 16), // 이메일 입력 필드와 인증번호 필드 사이의 간격
              Text(
                '인증번호',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8), // 텍스트와 텍스트필드 사이의 간격
              Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8), // 텍스트필드와 버튼 사이의 간격
                  ElevatedButton(
                    onPressed: () {
                      // 버튼 클릭 시 동작 추가
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary, // 테마에 정의된 색상 사용
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // 직사각형 모양으로 변경
                      ),
                    ),
                    child: const Text('확인'),
                  ),
                ],
              ),
              const SizedBox(height: 16), // 인증번호 필드와 비밀번호 필드 사이의 간격
              Text(
                '비밀번호',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8), // 텍스트와 텍스트필드 사이의 간격
              const TextField(
                obscureText: true, // 비밀번호 입력 시 텍스트 숨김
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16), // 비밀번호 필드와 비밀번호 확인 필드 사이의 간격
              Text(
                '비밀번호 확인',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8), // 텍스트와 텍스트필드 사이의 간격
              const TextField(
                obscureText: true, // 비밀번호 확인 입력 시 텍스트 숨김
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 80), // 버튼을 화면 하단에서 위로 올리기 위한 간격
              SizedBox(
                width: double.infinity, // 버튼을 전체 너비로 확장
                child: ElevatedButton(
                  onPressed: () {
                    // 다음으로 버튼 클릭 시 UsernamePage로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UsernamePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // 테마에 정의된 색상 사용
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // 직사각형 모양으로 변경
                    ),
                  ),
                  child: const Text('다음으로'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
