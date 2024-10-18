// lib/main_page.dart
import 'package:flutter/material.dart';
import 'package:project1/pages/study_page.dart';
import 'package:project1/pages/test_page.dart';
import 'package:project1/widgets/bottom_nav_bar.dart'; // BottomNavBar import
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:project1/utils/refresh_token_api_helper.dart'; // 이 파일의 경로에 따라 수정 필요

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static List<Widget> pages = <Widget>[
    const MainContent(), // MainPage의 내용을 별도 위젯으로 만듭니다.
    const StudyPage(),
    const TestPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)), // 왼쪽 메뉴버튼
        title: const Text('Hit The Book'), // 타이틀
        centerTitle: false, // 타이틀 텍스트 위치
        shape: const Border(bottom: BorderSide(color: Colors.grey, width: 1)), // 상단바 하단줄
        actions: [
          // 우측의 액션 버튼들
          IconButton(onPressed: () {}, icon: const Icon(FeatherIcons.edit2)),
          IconButton(onPressed: () {}, icon: const Icon(FeatherIcons.bell)),
          IconButton(onPressed: () {}, icon: const Icon(FeatherIcons.share2)),
        ],
      ),
      body: Center(
        child: Column( // Column 위젯으로 변경
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                RefreshTokenApiHelper apiHelper = RefreshTokenApiHelper();

                try {
                  final response = await apiHelper.refreshToken();
                  // 응답 처리
                  print('새로운 Access Token: ${response.accessToken}');
                  print('새로운 Refresh Token: ${response.refreshToken}');
                } catch (e) {
                  print('토큰 갱신 실패: $e');
                }
              },
              child: const Text('리프레시 토큰 테스트'),
            ),
            const SizedBox(height: 20), // 버튼 사이의 간격
            ElevatedButton(
              onPressed: () {
                // 탈퇴하기 버튼 클릭 시 처리할 내용
                _showConfirmationDialog(context);
              },
              child: const Text('탈퇴하기'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red), // 버튼 색상 변경
            ),
          ],
        ),
      ),
    );
  }

  // 탈퇴 확인 다이얼로그
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('탈퇴 확인'),
          content: const Text('정말로 탈퇴하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                // 탈퇴 로직 구현
                print('탈퇴가 완료되었습니다.');
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('탈퇴하기', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}


// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MainPage(),
//     );
//   }
// }
