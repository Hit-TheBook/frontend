import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project1/pages/study_page.dart';
import 'package:project1/pages/test_page.dart';
import 'package:project1/widgets/bottom_nav_bar.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:project1/utils/auth_api_helper.dart';
import 'package:project1/widgets/customdialog.dart';
import 'package:project1/utils/auth_api_helper.dart';
import 'package:project1/models/user_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static List<Widget> pages = <Widget>[
    const MainContent(), // MainContent를 포함
    const StudyPage(),   // StudyPage
    const TestPage(),    // TestPage
  ];

  void _onItemTapped(int index) {
    if (index == 1) { // StudyPage 탭 클릭 시
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StudyPage()), // StudyPage로 이동
      );
    } else {
      setState(() {
        _selectedIndex = index; // 선택된 인덱스에 따라 페이지가 변경됨
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 1
          ? const StudyPage() // StudyPage로 직접 이동할 경우 하단바 숨김
          : pages[_selectedIndex], // 현재 선택된 페이지만 보여줌
      bottomNavigationBar: _selectedIndex == 1
          ? null // StudyPage일 경우 하단바 숨김
          : BottomNavBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped, // 탭 클릭 시 동작
      ),
    );
  }
}

class MainContent extends StatefulWidget {
  const MainContent({super.key});

  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  String? nickname;
  int? point;
  final AuthApiHelper authApiHelper = AuthApiHelper();

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // 사용자 정보를 로드
  }

  Future<void> _loadUserInfo() async {
    try {
      final response = await authApiHelper.findUserName('member'); // 엔드포인트 수정
      // HTTP 응답의 상태 코드가 200인지 확인
      if (response.statusCode == 200) {
        // JSON 디코딩 후 UserResponse 객체로 변환
        final userInfo = UserResponse.fromJson(jsonDecode(response.body));
        setState(() {
          nickname = userInfo.nickname;
          point = userInfo.point;
        });
      } else {
        print('사용자 정보를 가져오는 중 오류 발생: ${response.body}');
      }
    } catch (e) {
      print('사용자 정보를 가져오는 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text('Hit The Book'),
          centerTitle: false,
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/hitthebook.jpg', // 여기에 이미지 파일 경로를 넣으세요.
                  width: 100, // 원하는 너비 조정
                  height: 100, // 원하는 높이 조정
                ),
                if (nickname != null && point != null) ...[
                  Text('닉네임: $nickname', style: TextStyle(fontSize: 18)),
                  Text('포인트: $point', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 20), // 간격
                ],
                ElevatedButton(
                  onPressed: () {
                    _showConfirmationDialog(context);
                  },
                  child: const Text('탈퇴하기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: '탈퇴 확인',
          content: const Text('정말로 탈퇴하시겠습니까?'),
          onConfirm: () async {
            String endpoint = 'member';
            try {
              final response = await authApiHelper.deleteAccount(endpoint);
              if (response.statusCode == 200) {
                print('탈퇴가 완료되었습니다.');
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MainPage()),
                      (Route<dynamic> route) => false,
                );
              } else {
                print('탈퇴 실패: ${response.body}');
              }
            } catch (e) {
              print('탈퇴 중 오류 발생: $e');
            }
            Navigator.of(context).pop(); // 다이얼로그 닫기
          },
        );
      },
    );
  }
}
