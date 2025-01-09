import 'package:flutter/material.dart';
import '../colors.dart';
import 'main_page.dart';
import 'study_page.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex; // 추가: 초기 선택된 인덱스
  const HomeScreen({Key? key, this.initialIndex = 0}) : super(key: key); // 기본값 0


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // 초기값 설정
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          MainPage(),  // 0번 인덱스: 메인 페이지
          StudyPage(), // 1번 인덱스: 스터디 페이지
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: black1,
        currentIndex: _selectedIndex,
        unselectedItemColor: neonskyblue1,
        selectedItemColor: neonskyblue1,
        onTap: _onItemTapped,
        showSelectedLabels: false,  // 선택된 라벨 숨김
        showUnselectedLabels: false, // 선택 안된 라벨 숨김
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium_outlined), label: '메인'),
          BottomNavigationBarItem(icon: Icon(Icons.mode_edit_outline_outlined), label: '스터디'),
        ],
      ),
    );
  }
}
