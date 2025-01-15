import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:project1/pages/dday_page.dart';
import 'package:project1/pages/timer.dart';
import 'package:project1/theme.dart';
import 'package:project1/utils/dday_api_helper.dart'; // API 헬퍼 불러오기
import 'package:project1/utils/timer_api_helper.dart'; // 타이머 API 헬퍼 추가
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
  String displayedTime = '00:00:00';
  final TimerApiHelper _timerApiHelper = TimerApiHelper();

  @override
  void initState() {
    super.initState();
    fetchPrimaryDday();
    fetchStudyTime();
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

  Future<void> fetchStudyTime() async {
    try {
      final studyTimeData = await _timerApiHelper.fetchStudyTime();
      final studyTimeLength = studyTimeData.studyTimeLength;
      if (studyTimeLength != null) {
        Duration studyTimeDuration = _parseDuration(studyTimeLength);
        setState(() {
          displayedTime = formatDuration(studyTimeDuration);
        });
      }
    } catch (error) {
      print('studyTime 가져오기 실패: $error');
    }
  }
  Duration _parseDuration(String durationString) {
    final RegExp regExp = RegExp(r"PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?");
    final match = regExp.firstMatch(durationString);

    if (match != null) {
      final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
      final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
      final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;

      return Duration(hours: hours, minutes: minutes, seconds: seconds);
    }

    return Duration.zero; // 문자열이 잘못된 형식일 경우 0초 반환
  }




// Duration을 'HH:mm:ss' 형식으로 변환
  String formatDuration(Duration duration) {
    return '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 상단 배너 부분
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: black1, // 배경색 설정
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.r)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 70.h), // 상단 여백
                    Text(
                      '나의 스터디',
                      style: TextStyle(
                        color: neonskyblue1,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$formattedDate ($firstLetterOfWeekDay)', // 날짜 표시
                      style: TextStyle(
                        color: white1,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h), // 여백 추가

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buildSectionContainer(
                        context: context,
                        title: ' 타이머',
                        subtitle: '오늘 총 누적시간',
                        subtitleValue: displayedTime,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TimerPage()),
                          );
                        },
                      ),
                      SizedBox(height: 20.h),
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
                      SizedBox(height: 20.h),
                      buildSectionContainer(
                        context: context,
                        title: ' 플래너',
                        height: 38.h,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PlannerPage()),
                          );
                        },
                        showDivider: false,
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
