import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project1/colors.dart';
import 'package:project1/pages/login_page.dart';
import 'package:project1/pages/study_page.dart';
import 'package:project1/pages/test_page.dart';
import 'package:project1/widgets/bottom_nav_bar.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:project1/utils/auth_api_helper.dart';
import 'package:project1/widgets/customdialog.dart';
import 'package:project1/models/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static final List<Widget> pages = <Widget>[
    const MainContent(),
    const StudyPage(),
    const TestPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 뒤로가기 버튼을 눌렀을 때 로그인 화면으로 이동
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false, // 기존 라우트를 모두 제거하고 LoginPage로 이동
        );
        return false; // 기본 뒤로가기 동작을 막음
      },
      child: Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavBar(
          currentIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
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
      if (response.statusCode == 200) {
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 자동으로 생성되는 뒤로가기 버튼 제거
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), // 상단 10, 좌우 20
          child: nickname != null
              ? Text(
            '$nickname', // 닉네임만 표시
            style: TextStyle(
              fontSize: 14.sp, // 화면 크기에 맞게 텍스트 크기 조정
            ),
          )
              : Text(
            'Loading...', // 닉네임이 로드되지 않았을 때 로딩 표시
            style: TextStyle(
              fontSize: 14.sp, // 기본 텍스트 크기 설정
            ),
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.black, // AppBar 배경색
        actions: [
          IconButton(
            icon: const Icon(Icons.mode_edit_outline_outlined, size: 25,),
            onPressed: () {
              // 메뉴 아이콘을 눌렀을 때 동작 추가
              print("Menu button pressed");
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined,size: 25,),
            onPressed: () {
              // 메뉴 아이콘을 눌렀을 때 동작 추가
              print("Menu button pressed");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(
            color: neonskyblue1, // 구분선 색상
            thickness: 1, // 구분선 두께
            indent: 0, // 왼쪽 여백
            endIndent: 0, // 오른쪽 여백
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/hitthebook.jpg', // 이미지 경로
                    width: 100.w, // 화면 크기에 맞게 너비 조정
                    height: 100.h, // 화면 크기에 맞게 높이 조정
                  ),
                  if (nickname != null && point != null) ...[
                    Text('닉네임: $nickname', style: TextStyle(fontSize: 18.sp)),
                    Text('포인트: $point', style: TextStyle(fontSize: 18.sp)),
                    const SizedBox(height: 20),
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
      ),
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
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false,
                );
              } else {
                print('탈퇴 실패: ${response.body}');
                _showErrorDialog(context, '탈퇴 실패', '서버 오류로 탈퇴할 수 없습니다. 나중에 다시 시도해주세요.');
              }
            } catch (e) {
              print('탈퇴 중 오류 발생: $e');
              _showErrorDialog(context, '탈퇴 실패', '탈퇴 중 오류가 발생했습니다. 다시 시도해주세요.');
            }
          },
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
