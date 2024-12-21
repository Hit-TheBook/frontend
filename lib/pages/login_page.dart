import 'package:flutter/material.dart';
import 'package:project1/pages/register_page.dart';
import 'package:project1/theme.dart'; // 테마 파일 경로
import 'package:project1/utils/login_api_helper.dart';
import 'package:project1/models/login_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 추가
import 'main_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/widgets/customdialog.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // dotenv 패키지 추가
import 'package:encrypt/encrypt.dart' as encrypt; // encrypt 패키지 추가
import 'dart:convert'; // JSON 인코딩

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  // AES 암호화 함수
  String encryptPassword(String password) {
    // .env에서 Base64로 인코딩된 키 가져오기
    String base64Key = dotenv.get('SECRET_KEY', fallback: '');

    // Base64 디코딩
    final decodedKey = base64.decode(base64Key);

    // AES 암호화 준비
    final key = encrypt.Key(decodedKey);
    final iv = encrypt.IV.fromSecureRandom(16); // 고유한 IV 생성
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc)); // CBC 모드

    // 비밀번호 암호화
    final encrypted = encrypter.encrypt(password, iv: iv);

    // IV와 암호화된 데이터를 Base64로 인코딩 후 반환
    final combined = iv.bytes + encrypted.bytes;
    return base64.encode(combined); // Base64로 변환
  }

// AES 복호화 함수
  String decryptPassword(String encryptedPassword) {
    // .env에서 Base64로 인코딩된 키 가져오기
    String base64Key = dotenv.get('SECRET_KEY', fallback: '');

    // Base64 디코딩
    final decodedKey = base64.decode(base64Key);

    // Base64 디코딩된 암호화된 데이터
    final decoded = base64.decode(encryptedPassword);

    // IV와 암호화된 데이터 분리
    final iv = encrypt.IV(decoded.sublist(0, 16)); // IV는 첫 16바이트
    final encryptedBytes = decoded.sublist(16); // 나머지는 암호화된 데이터

    // AES 복호화 준비
    final key = encrypt.Key(decodedKey);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc)); // CBC 모드

    // 복호화
    return encrypter.decrypt(
      encrypt.Encrypted(encryptedBytes),
      iv: iv,
    );
  }

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
                  // AES 복호화 함수



                  // 비밀번호 암호화
                  String encryptedPassword = encryptPassword(password);
                  // **콘솔에 입력된 비밀번호와 암호화된 비밀번호 출력**
                  print('입력된 비밀번호: $password');
                  print('암호화된 비밀번호: $encryptedPassword');

                  // 암호화된 비밀번호 복호화
                  String decryptedPassword = decryptPassword(encryptedPassword);
                  print('복호화된 비밀번호: $decryptedPassword');

                  // 복호화된 비밀번호와 입력된 비밀번호가 동일한지 확인
                  if (password == decryptedPassword) {
                    print('복호화 성공: 원래 비밀번호와 동일합니다.');
                  } else {
                    print('복호화 실패: 원래 비밀번호와 다릅니다.');
                  }
                  LoginRequestModel requestModel = LoginRequestModel(
                    email: email,
                    password:encryptedPassword//password encryptedPassword, // 암호화된 비밀번호 사용
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
