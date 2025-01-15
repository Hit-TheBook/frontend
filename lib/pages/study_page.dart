import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:project1/pages/dday_page.dart';
import 'package:project1/pages/timer.dart';
import 'package:project1/theme.dart';
import 'package:project1/utils/dday_api_helper.dart'; // API 헬퍼 불러오기
import '../colors.dart';
import 'main_page.dart';
import 'planner_page.dart'; // 플래너 페이지 추가

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
    String formattedDate = DateFormat('yyyy년 MM월 dd일', 'ko_KR').format(now);
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
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80), // 상단 여백
                  const Text(
                    '나의 스터디',
                    style: TextStyle(
                      color: neonskyblue1,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$formattedDate ($firstLetterOfWeekDay)', // 날짜 표시
                    style: const TextStyle(
                      color: white1,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // 여백 추가

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildSectionContainer(
                      context: context,
                      title: ' 타이머',
                      subtitle: '오늘 총 누적시간',
                      subtitleValue: '00:00:00',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TimerPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    buildSectionContainer(
                      context: context,
                      title: ' 디데이',
                      subtitle: primaryDdayName ?? '대표 디데이를 설정해주세요.',
                      subtitleValue: remainingDays == null
                          ? '로딩 중...'
                          : (remainingDays == 0
                          ? "D-day"
                          : "D ${remainingDays! > 0 ? "-" : "+"}${remainingDays!.abs()}"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DdayPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    buildSectionContainer(
                      context: context,
                      title: ' 플래너',
                      height: 40.h,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PlannerPage()),
                        );
                      },
                      showDivider: false,
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
    required String title,
    String? subtitle,
    String? subtitleValue,
    required VoidCallback onPressed,
    double? height,
    bool showDivider = true,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: height ?? 80.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_outlined, color: Colors.white),
                  onPressed: onPressed,
                ),
              ],
            ),
            if (showDivider && subtitle != null && subtitleValue != null)
              const Divider(color: Colors.white, thickness: 1),
            if (subtitle != null && subtitleValue != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      subtitleValue,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
