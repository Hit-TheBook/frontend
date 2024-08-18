import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/timer.dart';
import 'package:project1/dday.dart';
import 'count_up_timer_page.dart';

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
        automaticallyImplyLeading: false, // 상단바 뒤로가기버튼 없애기
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '나의 스터디',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '$formattedDate ($firstLetterOfWeekDay)',
              style: const TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView( // 전체 페이지를 스크롤 가능하게
        padding: const EdgeInsets.all(16.0), // 페이지 전체에 여백 추가
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildSectionContainer(
              context: context,
              items: [
                '디데이',
                '디데이 이름',
              ],
              onPressed: (String title) {
                if (title == '디데이') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DdayPage()),
                  ); //에 원하는 동작 추가
                }
                if (title == '00:00:00') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CountUpTimerPage()),
                  ); //에 원하는 동작 추가
                }},
            ),
            const SizedBox(height: 20), // 섹션 간의 간격 추가
            buildSectionContainer(
              context: context,
              items: [
                '타이머',
                '00:00:00',
              ],
              onPressed: (String title) {
              if (title == '타이머') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TimerPage()),
                ); //에 원하는 동작 추가
              }
              if (title == '00:00:00') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CountUpTimerPage()),
                ); //에 원하는 동작 추가
              }},
            ),
            const SizedBox(height: 20),
            buildSectionContainer(
              context: context,
              items: [
                '개인미션',
                '오늘 수행 미션',
                '진행중인 미션',
              ],
              onPressed: (String title) {
                // 버튼 클릭 시 동작
                if (kDebugMode) {
                  print('버튼 클릭됨: $title');
                }
                // 여기에 원하는 동작 추가
              },
            ),
            const SizedBox(height: 20),
            buildSectionContainer(
              context: context,
              items: [
                '플래너',
              ],
              onPressed: (String title) {
                // 버튼 클릭 시 동작
                if (kDebugMode) {
                  print('버튼 클릭됨: $title');
                }
                // 여기에 원하는 동작 추가
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionContainer({
    required BuildContext context,
    required List<String> items,
    required void Function(String) onPressed, // 버튼 클릭 시 호출할 함수
  }) {
    return Container(
      width: MediaQuery.of(context).size.width - 32, // 화면 너비에 맞게 설정 (좌우 padding 16씩 제외)
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200], // 전체 컨테이너 배경색
        borderRadius: BorderRadius.circular(15), // 둥근 모서리
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(items.length, (index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity, // 버튼을 컨테이너의 전체 너비로 확장
                child: TextButton(
                  onPressed: () {
                    // 버튼 클릭 시 동작
                    onPressed(items[index]);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black, // 버튼 텍스트 색상
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: Colors.transparent, // 배경색 투명
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // 둥근 모서리
                    ),
                  ),
                  child: Text(
                    items[index],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (index < items.length - 1) // 마지막 항목이 아니면 구분선 추가
                const Divider(
                  color: Colors.black, // 구분선 색상 변경
                  thickness: 1,
                ),
            ],
          );
        }),
      ),
    );
  }
}
