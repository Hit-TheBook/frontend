import 'package:flutter/material.dart';
import 'package:project1/studypage.dart';
import 'package:project1/testpage.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';


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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(FeatherIcons.user), label: ''),
          BottomNavigationBarItem(icon: Icon(FeatherIcons.penTool), label: ''),
          BottomNavigationBarItem(icon: Icon(FeatherIcons.facebook), label: ''),
        ],
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
      body: const Center(
        child: Text('Welcome to the Main Page!'),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}
