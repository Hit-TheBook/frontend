import 'package:flutter/material.dart';
import 'package:project1/widgets/week_calendar_component.dart';
import 'package:project1/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/widgets/bargraph.dart';
import 'package:project1/widgets/subject_dropdown.dart';
import 'package:project1/utils/timer_api_helper.dart';

class TimerUsageReportPage extends StatefulWidget {
  const TimerUsageReportPage({Key? key}) : super(key: key);

  @override
  _TimerUsageReportPageState createState() => _TimerUsageReportPageState();
}

class _TimerUsageReportPageState extends State<TimerUsageReportPage> {
  List<DateTime> selectedWeekDays = [];
  DateTime? selectedDay = DateTime.now();
  bool isDailySelected = true;

  // 일간 및 주간 데이터와 라벨 예시
  final List<double> dailyData = [30, 70, 110, 90, 60, 80, 20];
  final List<String> dailyLabels = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]; // 일간 라벨

  final List<double> weeklyData = [50, 100, 150, 80];
  final List<String> weeklyLabels = ["첫째주", "둘째주", "셋째주", "넷째주"]; // 주간 라벨

  late List<String> subjectsList = [];  // 빈 리스트로 초기화

  String selectedSubject = '';     // 선택된 과목 (초기값을 빈 문자열로 설정)

  // 일간 및 주간 데이터 예시
  final Map<String, Map<String, List<double>>> subjectData = {
    "Math": {
      "daily": [30, 50, 80, 60, 100],
      "weekly": [200, 250, 300, 300],
    },
    // "English": {
    //   "daily": [40, 60, 90, 110, 130, 300, 300],
    //   "weekly": [220, 270, 350, 300],
    // },
    // "Scienceaaaaaaaaaaaa": {
    //   "daily": [20, 30, 60, 40, 70, 300, 300],
    //   "weekly": [150, 180, 240, 300],
    // },
  };

  List<double> fillMissingData(List<double> data, int targetLength) {
    // 데이터 길이가 targetLength에 미치지 못하면 0으로 채움
    return List.generate(targetLength, (index) => index < data.length ? data[index] : 0.0);
  }

  int getDayIndex(DateTime date) {
    // DateTime의 weekday는 1부터 시작하므로, 배열 인덱스(0부터)로 맞춰줌
    return date.weekday - 1;
  }

  int getWeekIndex(DateTime date) {
    // 현재 월의 첫 번째 날
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    // 첫 번째 날의 요일 (월요일 기준으로 설정하기 위해 조정)
    int firstWeekday = firstDayOfMonth.weekday == 7 ? 0 : firstDayOfMonth.weekday; // 일요일 = 0

    // 첫 번째 월요일의 날짜
    DateTime firstMonday = firstDayOfMonth.subtract(Duration(days: firstWeekday - 1));

    // 주차 계산
    int weekIndex = ((date.difference(firstMonday).inDays) / 7).floor();

    return weekIndex;
  }
  Future<void> fetchDailySubjectStatistics(String targetDate, String subjectName) async {
    try {
      // fetchDailySubjectStatistics가 void를 반환한다면 상태 확인을 위해 다른 방식으로 처리해야 함
      await TimerApiHelper().fetchDailySubjectStatistics(targetDate, subjectName);

      // 정상 처리 후의 로직
      print('Data fetched successfully');
      // 상태 코드 체크를 못 하므로, 성공적인 결과를 처리할 로직을 작성해야 함.
    } catch (e) {
      // 오류 처리
      print('Error fetching data: $e');
    }
  }


  @override
  void initState() {
    super.initState();
    // 페이지가 처음 로드될 때 과목 목록을 API에서 가져오기
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    try {
      final subjects = await TimerApiHelper().fetchSubjects(); // TimerApiHelper 인스턴스를 통해 fetchSubjects 호출
      setState(() {
        subjectsList = subjects.isEmpty ? [] : subjects; // 비어있을 경우 빈 리스트로 초기화
        selectedSubject = subjects.isNotEmpty ? subjects[0] : ''; // 과목이 있을 경우 첫 번째 과목을 선택, 없으면 빈 문자열
      });

      // 과목이 로드되면 초기 선택 날짜와 첫 번째 과목을 서버에 보내는 API 호출
      if (selectedSubject.isNotEmpty && selectedDay != null) {
        final targetDate = selectedDay!.toIso8601String().split('T').first; // YYYY-MM-DD 형식으로 변환
        await fetchDailySubjectStatistics(targetDate, selectedSubject); // API 호출
      }
    } catch (e) {
      print('Failed to load subjects: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    final weekCalendarComponent = WeekCalendarComponent(
      onWeekSelected: (weekDays, selectedDay) {
        setState(() {
          selectedWeekDays = weekDays;
          this.selectedDay = selectedDay;
        });
      },
      isDailySelected: isDailySelected,  // 전달된 값
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '통계',
          style: TextStyle(fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isDailySelected = true;
                        selectedDay = DateTime.now();
                        selectedWeekDays.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDailySelected ? neonskyblue1 : Colors.white,
                      minimumSize: Size(54.w, 24.h),
                    ),
                    child: Text('일간', style: TextStyle(fontSize: 14.sp)),
                  ),
                  SizedBox(width: 10.w),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isDailySelected = false;
                        selectedDay = DateTime.now();
                        selectedWeekDays = weekCalendarComponent.getWeekDays(DateTime.now());
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDailySelected ? Colors.white : neonskyblue1,
                      minimumSize: Size(54.w, 24.h),
                    ),
                    child: Text('주간', style: TextStyle(fontSize: 14.sp)),
                  ),
                ],
              ),
              SizedBox(height: 5.h),

              if (isDailySelected) ...[
                weekCalendarComponent,
                SizedBox(height: 20.h),
                Text(
                  '선택된 날짜',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  selectedDay != null ? selectedDay!.toIso8601String() : '',
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 10.h),
                Divider(color: white1, thickness: 2),
              ] else ...[
                weekCalendarComponent,
                Text(
                  '선택된 주간 날짜',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  selectedWeekDays.isNotEmpty
                      ? selectedWeekDays.map((date) => date.toIso8601String()).join(', ')
                      : '',
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 10.h),
                Divider(color: white1, thickness: 2),
              ],

              SizedBox(height: 35.h),
              Center(
                child: Text(
                  "총 누적시간",
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                ),
              ),

              SizedBox(height: 5.h),
              Container(
                height: 150.h, // 원하는 높이로 설정
                child: BarGraph(
                  data: isDailySelected ? dailyData : weeklyData,
                  labels: isDailySelected ? dailyLabels : weeklyLabels,
                  highlightedIndex: isDailySelected && selectedDay != null
                      ? getDayIndex(selectedDay!) // 일간 모드에서 선택된 날짜의 요일 인덱스
                      : !isDailySelected && selectedDay != null
                      ? getWeekIndex(selectedDay!) // 주간 모드에서 선택된 주의 인덱스
                      : null, // 하이라이트 없음
                ),
              ),

              SizedBox(height: 20.h),
              Divider(color: white1, thickness: 2),

              SubjectDropdown(
                selectedSubject: selectedSubject,
                subjectsList: subjectsList, // API로 받은 과목 목록 전달
                onSubjectChanged: (newSubject) {
                  setState(() {
                    selectedSubject = newSubject ?? ''; // 선택된 과목이 null일 경우 빈 문자열로 설정
                  });
                },
              ),

              SizedBox(height: 10.h),
              // 그래프 표시
              Center(
                child: Text(
                  "과목 별 누적시간",
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                ),
              ),

              SizedBox(height: 10.h),
              // BarGraph 위젯에 선택된 과목과 일간/주간 데이터를 전달
              Container(
                height: 150.h, // 원하는 높이로 설정
                child: BarGraph(
                  data: [],//isDailySelected
                  //     ? fillMissingData(
                  //   subjectData.containsKey(selectedSubject)
                  //       ? subjectData[selectedSubject]!["daily"]!
                  //       : [],
                  //   7,
                  // ) // 7일 고정
                  //     : fillMissingData(
                  //   subjectData.containsKey(selectedSubject)
                  //       ? subjectData[selectedSubject]!["weekly"]!
                  //       : [],
                  //   4,
                  // ), // 4주 고정
                  labels: isDailySelected ? dailyLabels : weeklyLabels,
                  highlightedIndex: isDailySelected && selectedDay != null
                      ? getDayIndex(selectedDay!)
                      : !isDailySelected && selectedDay != null
                      ? getWeekIndex(selectedDay!)
                      : null, // 하이라이트 없음
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
