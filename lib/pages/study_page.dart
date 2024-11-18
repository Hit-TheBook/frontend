import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/pages/dday_page.dart';
import 'package:project1/pages/test_page.dart';
import 'package:project1/pages/timer.dart';
import 'package:project1/theme.dart';
import 'package:project1/utils/dday_api_helper.dart'; // API 헬퍼 불러오기
import 'package:project1/pages/count_up_timer_page.dart';
import '../colors.dart';
import 'main_page.dart';
import 'planner_page.dart'; // 플래너 페이지 추가
import 'package:project1/widgets/bottom_nav_bar.dart'; // BottomNavBar 임포트


class StudyPage extends StatefulWidget {
  const StudyPage({super.key});

  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  String? primaryDdayName;
  int? remainingDays;

  @override
  void initState() {
    super.initState();
    fetchPrimaryDday();
  }

  Future<void> fetchPrimaryDday() async {
    try {
      final apiHelper = ApiHelper();
      final response = await apiHelper.fetchDdayList('dday/primary');
      final decodedResponse = jsonDecode(response.body);

      setState(() {
        primaryDdayName = decodedResponse['ddayName'] ?? '대표 디데이를 설정해주세요.';
        remainingDays = decodedResponse['remainingDays'] ?? 0;
      });
    } catch (e) {
      setState(() {
        primaryDdayName = '대표 디데이 불러오기 실패';
        remainingDays = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MM월 dd일', 'ko_KR').format(now);
    String weekDay = DateFormat('EEEE', 'ko_KR').format(now);
    String firstLetterOfWeekDay = weekDay.isNotEmpty ? weekDay[0] : '';

    return WillPopScope(
      onWillPop: () async {
        // 뒤로 가기 버튼 눌렀을 때 항상 MainPage로 이동
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
              (route) => false, // 기존 스택 제거
        );
        return false; // 기본 뒤로 가기 동작 방지
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 상단 배너 부분
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: black1, // 배경색 설정
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80), // 상단 여백
                  const Text(
                    '나의 스터디',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$formattedDate ($firstLetterOfWeekDay)', // 날짜 표시
                    style: const TextStyle(
                      color: Color(0xFF8E8E8E),
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // 여백 추가
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildSectionContainer(
                      context: context,
                      items: [
                        '디데이',
                        primaryDdayName != null && remainingDays != null
                            ? '$primaryDdayName                                          D -$remainingDays'
                            : '로딩 중...',
                      ],
                      onPressed: (String title) {
                        if (title == '디데이') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DdayPage()),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
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
                      },
                    ),
                    const SizedBox(height: 20),
                    buildSectionContainer(
                      context: context,
                      items: ['플래너'],
                      onPressed: (String title) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PlannerPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(8),
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
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
              if (index < items.length - 1)
                const Divider(
                  color: AppColors.primary,
                  thickness: 1,
                ),
            ],
          );
        }),
      ),
    );
  }
}
