import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project1/main.dart';
import 'package:project1/pages/login_page.dart';
import 'package:project1/theme.dart';

import 'package:project1/widgets/customdialog.dart';
import '../colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/register_view_model.dart'; // Import ViewModel for managing state

class RegisterPage extends StatefulWidget {

  final bool isResetPassword;

  const RegisterPage({Key? key, this.isResetPassword = false}) : super(key: key);


  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();

  final RegisterViewModel registerViewModel = RegisterViewModel();

  // 비밀번호 유효성 상태 추가
  bool isPasswordValid = false;
  bool isButtonEnabled = false; // '완료' 버튼 상태 변수


  // 비밀번호 유효성 검사 함수
  bool _validatePassword(String password) {
    final RegExp passwordExp = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$%\^&\*])[A-Za-z\d!@#\$%\^&\*]{8,}$',
    );
    return passwordExp.hasMatch(password);
  }

  @override
  void initState() {
    super.initState();
    passwordController.addListener(() {
      setState(() {
        isPasswordValid = _validatePassword(passwordController.text);
      });
      updateButtonState();
    });

    // 텍스트 필드 상태 업데이트 리스너 추가
    emailController.addListener(updateButtonState);
    codeController.addListener(updateButtonState);
    confirmPasswordController.addListener(updateButtonState);
    nicknameController.addListener(updateButtonState);
  }

  void updateButtonState() {
    setState(() {
      // 모든 필드가 채워져 있고, 비밀번호가 유효한 경우에만 버튼 활성화
      isButtonEnabled = emailController.text.isNotEmpty &&
          codeController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty &&
          (!widget.isResetPassword || nicknameController.text.isNotEmpty) &&
          isPasswordValid &&
          _isCodeVerified; // 인증 코드가 확인된 경우만
    });
  }

  // 기타 메소드들은 그대로 유지합니다.



  Duration _countdownDuration = Duration(minutes: 5);
  Timer? _countdownTimer;
  bool _isCountdownActive = false;
  bool _isCountdownVisible = false; // Add this variable to track visibility of countdown
  bool _isCodeVerified = false; // Add this variable to track verification status

  Future<void> _sendAuthCode() async {
    print('Sending auth code to: ${emailController.text}');

    final response = await registerViewModel.sendAuthCode(emailController.text);

    if (response.statusCode == 200) {
      // 성공: 상태 코드 200
      _startCountdown();  // 인증 코드 전송 후 카운트다운 시작
    } else if (response.statusCode == 400) {
      // 잘못된 요청: 상태 코드 400
      _showCustomDialog(context, '이메일 확인', '잘못된 요청입니다. 이메일 주소를 다시 한번 확인해주세요.');
    } else if (response.statusCode == 445) {
      // 중복된 이메일: 상태 코드 445
      _showCustomDialog(context, '이메일 확인', '이미 가입된 이메일입니다');
    } else {
      // 그 외 다른 상태 코드 처리
      _showCustomDialog(context, '오류', '인증 코드 전송 중 오류가 발생했습니다. 상태 코드: ${response.statusCode}');
    }
  }


  Future<void> _sendResetAuthCode() async {
    print('Sending auth code to: ${emailController.text}');
    bool success = await registerViewModel.sendResetAuthCode(emailController.text);

    if (success) {

      _startCountdown();
    } else {
      _showCustomDialog(context, '이메일 확인', '이메일 주소를 다시 한번 확인해주세요.');
    }
  }

  Future<void> _verifyCode() async {
    String email = emailController.text;
    String code = codeController.text;

    bool verified = await registerViewModel.verifyAuthCode(email, code);
    if (verified) {

      setState(() {
        _isCodeVerified = true;
        _isCountdownActive = false; // Stop the countdown timer
        _isCountdownVisible = false; // Hide countdown and label
      });
      if (_countdownTimer != null) {
        _countdownTimer!.cancel(); // Cancel the timer
      }
    } else {
      _showCustomDialog(context, '인증번호 안내', '알맞지 않은 인증번호 입니다.');
    }
  }

  Future<void> _registerUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      _showCustomDialog(context, '비밀번호 확인 안내', '비밀번호가 일치하지않습니다.');
      return;
    }

    bool registered = await registerViewModel.registerUser(
        emailController.text,
        passwordController.text,
        nicknameController.text
    );

    if (registered) {
      _showCustomDialog(
        context,
        '시작하기 안내',
        '정상적으로 회원가입이 완료되었습니다.',
        onConfirm: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()), // 원하는 페이지로 이동
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('회원가입 실패')));
    }
  }

  Future<void> _resetPassword() async {
    bool resetPassword = await registerViewModel.resetPassword(
        emailController.text,
        passwordController.text,
    );

    if (resetPassword) {

      _showCustomDialog(
        context,
        '비밀번호 재설정 안내',
        '비밀번호가 정상적으로 재설정되었습니다.',
        onConfirm: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()), // 원하는 페이지로 이동
          );
        },
      );

    } else {

      _showCustomDialog(context, '비밀번호 재설정 안내', '비밀번호 재설정 실패');
    }
  }

  Future<void> _checkPreviousPassword() async {
    if (passwordController.text != confirmPasswordController.text) {
      _showCustomDialog(context, '비밀번호 확인 안내', '비밀번호가 일치하지않습니다.');
      return;
    }

    // 이전 비밀번호 확인
    final response = await registerViewModel.checkPreviousPassword(
      emailController.text,
      passwordController.text,
    );

    // 응답 상태 코드에 따른 처리
    if (response.statusCode == 200) {
      debugPrint('200');
      await _resetPassword();
    } //else if (response.statusCode == 500) {
      //debugPrint('500');
     // _showPasswordResetDialog(context); // 서버 오류 처리
    //}
    else {
      _showCustomDialog(context, '비밀번호 재설정 실패', '이전 비밀번호와 동일한 비밀번호를 사용할 수 없습니다.');
    }
  }


  void _startCountdown() {
    if (_countdownTimer != null) {
      _countdownTimer!.cancel();
    }
    setState(() {
      _isCountdownActive = true;
      _isCountdownVisible = true; // Show countdown and label
      _countdownDuration = Duration(minutes: 5);
    });

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdownDuration.inSeconds <= 0) {
        timer.cancel();
        setState(() {
          _isCountdownActive = false;
          _isCountdownVisible = false; // Hide countdown and label on timeout
        });
        _showCustomDialog(context,'인증번호 안내', '인증 시간이 만료되었습니다. 인증번호 재발급이 필요합니다.'); // Show timeout dialog when countdown ends
        return;
      }
      setState(() {
        _countdownDuration = _countdownDuration - Duration(seconds: 1);
      });
    });
  }

  String _formatDuration(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }




  void _showCustomDialog(BuildContext context, String title, String content, {VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: title,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(content),
              SizedBox(height: 8),
            ],
          ),
          onConfirm: () {
            if (onConfirm != null) {
              onConfirm(); // onConfirm 콜백이 있을 경우 실행
            } else {
              Navigator.of(context).pop(); // onConfirm이 없으면 다이얼로그만 닫기
            }
          },
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.isResetPassword ? '비밀번호 재설정' : '시작하기'), // widget을 사용하여 접근
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이메일 입력 필드
              Text('이메일 주소', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        fillColor: Color(0xFF333333),
                        filled: true,
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.isResetPassword) {
                        _sendResetAuthCode();
                      } else {
                        _sendAuthCode();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(neonskyblue1), // 버튼 배경색
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder( // ShapeDecoration의 shape 부분
                          borderRadius: BorderRadius.circular(5), // 원하는 둥근 모서리 설정
                        ),
                      ),
                    ),
                    child: const Text('인증번호 받기'),
                  ),


                ],
              ),
              SizedBox(height: 16.h),

              // 인증번호 입력 필드
              Text('인증번호', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: codeController,
                      decoration: const InputDecoration(
                        fillColor: Color(0xFF333333),
                        filled: true,
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  if (_isCountdownVisible) // Conditionally show countdown and label
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '남은시간',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
                        ),
                        SizedBox(height: 4.h),
                        if (_isCountdownActive)
                          Text(
                            _formatDuration(_countdownDuration),
                            style: const TextStyle(color: Colors.red, fontSize: 16),
                          ),
                      ],
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _verifyCode,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(neonskyblue1), // 버튼 배경색
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder( // ShapeDecoration의 shape 부분
                          borderRadius: BorderRadius.circular(5), // 원하는 둥근 모서리 설정
                        ),
                      ),
                    ),
                    child: Text(_isCodeVerified ? '인증 완료' : '확인'), // Update button text based on verification status
                  ),
                ],
              ),
             SizedBox(height: 16.h),

              // 비밀번호 입력 필드
              Text('비밀번호', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
             SizedBox(height: 8.h),
            // 비밀번호 입력 필드 (유효성 검사 추가)
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                fillColor: Color(0xFF333333),
                filled: true,
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                // 유효성 검사 상태에 따른 아이콘 변경
                suffixIcon: isPasswordValid
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.error, color: Colors.red),

              ),
            ),

              const SizedBox(height: 8),
              Text(
                '* 8자리 이상 영어, 숫자, 특수문자를 조합해야 합니다.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: neonskyblue1), // 직접 정의한 색상 사용
              ),
             SizedBox(height: 16.h),


              // 비밀번호 확인 입력 필드
              Text('비밀번호 확인', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
             SizedBox(height: 8.h),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  fillColor: Color(0xFF333333),
                  filled: true,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                ),
              ),
             SizedBox(height: 16.h),

              // 사용자 이름 입력 필드
              if (!widget.isResetPassword) // isResetPassword가 false일 때만 보이도록
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '사용자 이름 입력',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: nicknameController,
                      decoration: const InputDecoration(
                        fillColor: Color(0xFF333333),
                        filled: true,
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '* 최소 2글자 이상 6글자 이하(공백 제외)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: neonskyblue1), // 직접 정의한 색상 사용
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),


              // 완료 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () {
                    if (widget.isResetPassword) {
                      _isCodeVerified ? _checkPreviousPassword() : null;
                    } else {
                      _isCodeVerified ? _registerUser() : null;
                    }
                  }
                      : null, // 버튼 비활성화 처리
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey; // 비활성화 상태일 때 회색
                      }
                      return neonskyblue1; // 활성화 상태일 때의 색상
                    }),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: const Text('완료'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}