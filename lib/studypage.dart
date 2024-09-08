import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/theme.dart';
import 'package:project1/timer.dart';
import 'package:project1/dday.dart';
import 'colors.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0), // 상단 여백 추가
            decoration: const BoxDecoration(
              color: black1, // 상단 배경색
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15), // 하단 모서리 둥글게
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40), // 상단 여백 추가
                const Text(
                  '나의 스터디',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$formattedDate ($firstLetterOfWeekDay)',
                  style: const TextStyle(
                    color: Color(0xFF8E8E8E),
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20), // 상단 내용과 버튼 사이의 간격
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0), // 페이지 여백 추가
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
                        );
                      }
                      if (title == '00:00:00') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CountUpTimerPage()),
                        );
                      }
                    },
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
                        );
                      }
                      if (title == '00:00:00') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CountUpTimerPage()),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  buildSectionContainer(
                    context: context,
                    items: [
                      '플래너',
                    ],
                    onPressed: (String title) {
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
                      '개인미션',
                      '오늘 수행 미션',
                    ],
                    onPressed: (String title) {
                      if (kDebugMode) {
                        print('버튼 클릭됨: $title');
                      }
                      // 여기에 원하는 동작 추가
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionContainer({
    required BuildContext context,
    required List<String> items,
    required void Function(String) onPressed,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      padding: const EdgeInsets.all(4.0), // 컨테이너 여백 조정
      decoration: BoxDecoration(
        color: const Color(0xFF9D9D9D), // 전체 컨테이너 배경색
        borderRadius: BorderRadius.circular(8), // 둥근 모서리
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(items.length, (index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    onPressed(items[index]);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white, // 버튼 텍스트 색상
                    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0), // 버튼 패딩 조정
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // 둥근 모서리
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      items[index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              if (index < items.length - 1) // 마지막 항목이 아니면 구분선 추가
                const Divider(
                  color: AppColors.primary, // 구분선 색상
                  thickness: 1,
                ),
            ],
          );
        }),
      ),
    );
  }
}
