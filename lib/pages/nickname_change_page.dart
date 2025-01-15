import 'package:flutter/material.dart';
import 'package:project1/colors.dart';
import '../models/register_view_model.dart'; // RegisterViewModel 불러오기
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_screen.dart';

class NicknameChangePage extends StatefulWidget {
  @override
  _NicknameChangePageState createState() => _NicknameChangePageState();
}

class _NicknameChangePageState extends State<NicknameChangePage> {
  final TextEditingController nicknameController = TextEditingController();
  bool _isNicknameValid = false; // 닉네임 길이 유효성 검사
  bool _isNicknameAvailable = false; // 닉네임 중복 체크 상태
  bool _hasCheckedNickname = false; // 중복 확인 여부 상태 추가
  final RegisterViewModel registerViewModel = RegisterViewModel(); // RegisterViewModel 인스턴스 생성

  void _validateNickname(String nickname) {
    setState(() {
      _isNicknameValid = nickname.trim().length >= 2 && nickname.trim().length <= 6;
      _isNicknameAvailable = false; // 새로운 닉네임 입력 시 다시 중복 체크 필요
      _hasCheckedNickname = false; // 입력하면 다시 중복 확인 필요
    });
  }

  Future<void> _checkNicknameAvailability() async {
    String nickname = nicknameController.text.trim();

    if (!_isNicknameValid) return;

    bool isAvailable = await registerViewModel.checkNicknameAvailability(nickname);

    setState(() {
      _isNicknameAvailable = isAvailable;
      _hasCheckedNickname = true; // 중복 확인 완료
    });
  }

  void _submitNickname() async {
    if (_isNicknameAvailable) {
      String newNickname = nicknameController.text.trim();

      // 닉네임 수정 API 호출
      bool success = await registerViewModel.updateNickname(newNickname);

      if (success) {
        // 닉네임 수정 성공
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(initialIndex: 0), // StudyPage가 보이도록 설정
          ),
              (route) => false, // 모든 이전 페이지 제거
        );
      } else {
        // 수정 실패 시, 오류 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('닉네임 수정에 실패했습니다.')),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('닉네임 변경')),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 프로필 이미지 (가운데 정렬)
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/hitthebook.jpg'), // 로컬 이미지 사용
            ),
            SizedBox(height: 20.h),


            // 닉네임 입력 필드 + 중복 확인 버튼
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30.h, // 높이 조정
                        child: TextField(
                          controller: nicknameController,
                          onChanged: _validateNickname,
                          decoration: InputDecoration(
                            fillColor: Color(0xFF333333),
                            filled: true,
                            border: OutlineInputBorder(),
                            hintText: '닉네임을 설정해주세요.',
                            hintStyle: TextStyle(color: white1),
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0), // 내부 패딩 조정
                          ),
                        ),
                      ),


                      // 중복 확인 메시지 자리 고정

                    ],
                  ),
                ),
                SizedBox(width: 20.w),
                SizedBox(
                  width: 100.w, // 버튼 가로 크기 조정
                  height: 30.h, // 버튼 높이 조정
                  child: ElevatedButton(
                    onPressed: _isNicknameValid ? _checkNicknameAvailability : null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        _isNicknameValid ? neonskyblue1 : Colors.grey,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: Text('중복 확인'), // 항상 '중복 확인' 유지
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            SizedBox(
              height: 20.h,
              child: _hasCheckedNickname
                  ? Align(
                alignment: Alignment.centerLeft,  // 왼쪽 정렬
                child: Text(
                  _isNicknameAvailable ? '사용 가능한 닉네임입니다.' : '이미 사용 중입니다.',
                  style: TextStyle(
                    color: _isNicknameAvailable ? Colors.blue : Colors.red,
                    fontSize: 14.sp,
                  ),
                ),
              )
                  : null,
            ),

            SizedBox(height: 270.h),

            // 완료 버튼 (닉네임이 사용 가능해야 활성화됨)
            ElevatedButton(
              onPressed: _isNicknameAvailable ? _submitNickname : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  _isNicknameAvailable ? neonskyblue1 : Colors.grey,
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(300.w, 30.h), // 원하는 크기 (가로: 200, 세로: 50)
                ),
              ),
              child: Text('완료'),
            ),
          ],
        ),
      ),
    );
  }
}
