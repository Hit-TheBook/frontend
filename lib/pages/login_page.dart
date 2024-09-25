import 'package:flutter/material.dart';
import 'package:project1/theme.dart'; // 테마 파일 경로
import 'package:project1/utils/login_api_helper.dart';
import 'package:project1/models/login_model.dart';

import 'main_page.dart';
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('로그인'),
        actions: [
          TextButton(
            onPressed: () {
              // 완료 버튼 클릭 시 동작 추가
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: EdgeInsets.zero,
            ),
            child: const Text(
              '완료',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Text(
              '이메일 주소',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF333333),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '비밀번호 입력',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF333333),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // 비밀번호 재설정 클릭 시 동작 추가
                },
                child: const Text(
                  '비밀번호 재설정',
                  style: TextStyle(
                    color: Color(0xFF9D9D9D),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  LoginApiHelper apiHelper = LoginApiHelper();

                  String email = emailController.text;
                  String password = passwordController.text;

                  LoginRequestModel requestModel = LoginRequestModel(
                    email: email,
                    password: password,
                  );

                  LoginResponseModel responseModel = await apiHelper.login(
                    requestModel.email,
                    requestModel.password,
                  );

                  if (responseModel.accessToken.isNotEmpty) {
                    print('로그인 성공');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                    );
                  } else {
                    print('로그인 실패: ${responseModel.message}');
                    // 실패 시 처리 (예: 에러 메시지 표시)
                  }

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
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
