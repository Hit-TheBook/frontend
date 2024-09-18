import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/pages/planner_page.dart';
import 'package:project1/theme.dart';
import 'package:project1/pages/timer.dart';
import 'package:project1/pages/dday_page.dart';
import '../colors.dart';
import 'count_up_timer_page.dart';
import 'package:project1/utils/dday_api_helper.dart'; // API 헬퍼 불러오기

class StudyPage extends StatefulWidget {
  const StudyPage({super.key});

  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  String? primaryDdayName;

  @override
  void initState() {
    super.initState();
    fetchPrimaryDday(); // 페이지가 로드될 때 API 호출
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchPrimaryDday(); // 페이지가 다시 표시될 때마다 API 호출
  }


  // API를 호출하여 대표 디데이 이름을 가져오는 함수
  Future<void> fetchPrimaryDday() async {
    try {
      // ApiHelper에서 fetchDdayList 호출
      final response = await ApiHelper.fetchDdayList('dday/primary'); // 적절한 엔드포인트 사용

      // 응답 데이터를 JSON으로 변환
      final decodedResponse = jsonDecode(response.body);

      setState(() {
        primaryDdayName = decodedResponse['ddayName'] ?? '대표 디데이를 설정해주세요.';
      });
    } catch (e) {
      // 오류 처리
      setState(() {
        primaryDdayName = '대표 디데이 불러오기 실패';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MM월 dd일', 'ko_KR').format(now);
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
                const SizedBox(height: 80), // 상단 여백 추가
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
                  // 여기서 디데이 항목에 primaryDdayName을 표시
                  buildSectionContainer(
                    context: context,
                    items: [
                      '디데이',
                      primaryDdayName ?? '로딩 중...',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PlannerPage()),
                      );
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
                      print('버튼 클릭됨: $title');
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
        color: const Color(0xFF333333), // 전체 컨테이너 배경색
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
