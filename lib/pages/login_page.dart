import 'package:flutter/material.dart';
import 'package:project1/pages/register_page.dart';
import 'package:project1/theme.dart'; // 테마 파일 경로
import 'package:project1/utils/login_api_helper.dart';
import 'package:project1/models/login_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 추가
import 'main_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/widgets/customdialog.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    bool isResetPassword = false; // 비밀번호 재설정 플래그
    final storage = FlutterSecureStorage(); // 추가
    LoginApiHelper apiHelper = LoginApiHelper(); // 여기서 인스턴스 생성

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('로그인'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w), // ScreenUtil 사용
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h), // ScreenUtil 사용
            Text(
              '이메일 주소',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h), // ScreenUtil 사용
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF333333),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.h), // ScreenUtil 사용
            Text(
              '비밀번호 입력',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h), // ScreenUtil 사용
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF333333),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8.h), // ScreenUtil 사용
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  isResetPassword = true; // 플래그를 true로 설정
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(isResetPassword: isResetPassword),
                    ),
                  ); // 비밀번호 재설정 클릭 시 동작 추가
                },
                child: const Text(
                  '비밀번호 재설정',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.h), // ScreenUtil 사용
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

                    // 저장된 토큰 확인
                    var tokens = await apiHelper.getTokens();
                    print('저장된 Access Token: ${tokens['accessToken']}');
                    print('저장된 Refresh Token: ${tokens['refreshToken']}');

                    print('로그인 성공');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                    );
                  } else {
                    print('로그인 실패: ${responseModel.message}');

                    // CustomDialog 사용하여 에러 메시지 표시
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialog(
                          title: '로그인 실패',
                          content: const Text(
                            '로그인 정보를 확인해주세요.',
                            style: TextStyle(color: Colors.white),
                          ),
                          onConfirm: () {
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r), // ScreenUtil 사용
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
