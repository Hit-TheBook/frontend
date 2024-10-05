import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project1/main.dart';
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
    // 비밀번호 입력 리스너 추가
    passwordController.addListener(() {
      setState(() {
        isPasswordValid = _validatePassword(passwordController.text);
      });
    });
  }


  Duration _countdownDuration = Duration(minutes: 5);
  Timer? _countdownTimer;
  bool _isCountdownActive = false;
  bool _isCountdownVisible = false; // Add this variable to track visibility of countdown
  bool _isCodeVerified = false; // Add this variable to track verification status

  Future<void> _sendAuthCode() async {
    print('Sending auth code to: ${emailController.text}');
    bool success = await registerViewModel.sendAuthCode(emailController.text);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('인증번호가 발송되었습니다.')));
      _startCountdown();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('인증번호 발송 실패')));
    }
  }

  Future<void> _sendResetAuthCode() async {
    print('Sending auth code to: ${emailController.text}');
    bool success = await registerViewModel.sendResetAuthCode(emailController.text);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('인증번호가 발송되었습니다.')));
      _startCountdown();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('이메일을 다시 한 번 확인해주세요.')));
    }
  }

  Future<void> _verifyCode() async {
    String email = emailController.text;
    String code = codeController.text;

    bool verified = await registerViewModel.verifyAuthCode(email, code);
    if (verified) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('인증번호 확인 완료')));
      setState(() {
        _isCodeVerified = true;
        _isCountdownActive = false; // Stop the countdown timer
        _isCountdownVisible = false; // Hide countdown and label
      });
      if (_countdownTimer != null) {
        _countdownTimer!.cancel(); // Cancel the timer
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('인증번호가 올바르지 않습니다.')));
    }
  }

  Future<void> _registerUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('비밀번호가 일치하지 않습니다.')));
      return;
    }

    bool registered = await registerViewModel.registerUser(
        emailController.text,
        passwordController.text,
        nicknameController.text
    );

    if (registered) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('회원가입 성공')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Main()), // Change to LoginPage for completion
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

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('비밀번호 재설정 완료')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Main()), // Change to LoginPage for completion
      );
    } else {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('비밀번호 재설정 실패')));
    }
  }

  Future<void> _checkPreviousPassword() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('비밀번호가 일치하지 않습니다.')));
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
      _showPasswordResetDialog(context);
    }
  }



  void _showPasswordResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: '비밀번호 재설정 안내',
          content: Column(
            mainAxisSize: MainAxisSize.min, // 내용에 맞춰 Column 크기를 설정
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('이전 비밀번호와 동일한 비밀번호를 다시 사용할 수 없습니다.'),
            ],
          ),
          onConfirm: () {
            Navigator.of(context).pop(); // 다이얼로그 닫기
          },
        );
      },
    );
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
        _showCustomDialog(context); // Show timeout dialog when countdown ends
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

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: '인증번호 안내',
          content: Column(
            mainAxisSize: MainAxisSize.min, // 내용에 맞춰 Column 크기를 설정
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('인증 시간이 만료되었습니다.'),
              SizedBox(height: 8), // 텍스트 사이에 공간 추가
              Text('인증번호 재발급이 필요합니다.'),
            ],
          ),
          onConfirm: () {
            Navigator.of(context).pop(); // 다이얼로그 닫기
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
              onPressed: () {
                if (widget.isResetPassword) {
                  // 비밀번호 재설정 관련 메소드 호출
                  _checkPreviousPassword();
                } else {
                  // 일반 등록 관련 메소드 호출
                  _isCodeVerified ? _registerUser : null;//인증 완료시만 _registerUser 호출
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
