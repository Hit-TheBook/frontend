import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudyPage extends StatelessWidget {
  const StudyPage({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MM월 dd일', 'ko_KR').format(now);

    // 요일의 첫 글자를 한국어로 얻기
    String weekDay = DateFormat('EEEE', 'ko_KR').format(now);
    String firstLetterOfWeekDay = weekDay.isNotEmpty ? weekDay[0] : '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)), // 왼쪽 메뉴버튼
        title: Text('$formattedDate ($firstLetterOfWeekDay)'), // 타이틀
        centerTitle: true, // 타이틀 텍스트 위치
        shape: const Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      body: const Center(
        child: Text('study'),
      ),
    );
  }
}
