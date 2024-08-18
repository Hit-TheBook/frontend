import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project1/ddaydetail.dart';
import 'package:project1/theme.dart';
import 'count_up_timer_page.dart';
import 'custom_appbar.dart';
import 'mainpage.dart'; // Import pages for navigation

class DdayPage extends StatefulWidget {
  const DdayPage({super.key});

  @override
  DdayPageState createState() => DdayPageState();
}

class DdayPageState extends State<DdayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '디데이 ', // 사용할 타이틀을 전달
      ),
      body: const Center(
        child: Column(
          // 여기에 위젯을 추가할 수 있습니다.
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 버튼 클릭 시 동작을 여기에 추가
          if (kDebugMode) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DdaydetailPage()),
            );
          }
        },
        backgroundColor: AppColors.primary, // + 아이콘
        elevation: 6.0, // 버튼의 그림자 설정
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100), // 원형 버튼
        ), // 아이콘 배경색 설정
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // FAB 위치를 오른쪽 하단으로 설정
    );
  }
}
