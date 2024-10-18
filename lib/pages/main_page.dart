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
        title: const Text('사용자 이름'), // 타이틀
        centerTitle: false, // 타이틀 텍스트 위치
        shape: const Border(bottom: BorderSide(color: Colors.grey, width: 1)), //상단바 하단줄
        actions: [
          // 우측의 액션 버튼들
          IconButton(onPressed: () {}, icon: const Icon(FeatherIcons.edit2)),
          IconButton(onPressed: () {}, icon: const Icon(FeatherIcons.bell)),
          IconButton(onPressed: () {}, icon: const Icon(FeatherIcons.share2)),
        ],
      ),
      body: Center(
        child: ElevatedButton(
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
      ),

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
