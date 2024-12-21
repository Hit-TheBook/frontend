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

  late Map<String, Map<String, List<double>>> subjectData = {};

  List<double> fillMissingData(List<double> data, int targetLength) {
    // 데이터 길이가 targetLength에 미치지 못하면 0으로 채움
    return List.generate(targetLength, (index) => index < data.length ? data[index] : 0.0);
  }

  int getDayIndex(DateTime date) {
    // DateTime의 weekday는 1부터 시작하므로, 배열 인덱스(0부터)로 맞춰줌
    return date.weekday - 1;
  }

  int getWeekIndex(DateTime? date) {
    if (date == null) {
      return -1;  // null일 경우 기본값을 반환하거나 오류를 처리
    }

    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    int firstWeekday = firstDayOfMonth.weekday == 7 ? 0 : firstDayOfMonth.weekday;
    DateTime firstMonday = firstDayOfMonth.subtract(Duration(days: firstWeekday - 1));
    int weekIndex = ((date.difference(firstMonday).inDays) / 7).floor();

    return weekIndex;
  }

  double parseDurationToHours(String duration) {
    try {
      debugPrint('Parsing duration: $duration');

      // 정규식을 사용해 시간(H), 분(M), 초(S)을 각각 추출
      final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
      final match = regex.firstMatch(duration);

      if (match != null) {
        final hours = match.group(1) != null ? int.parse(match.group(1)!) : 0;
        final minutes = match.group(2) != null ? int.parse(match.group(2)!) : 0;
        final seconds = match.group(3) != null ? int.parse(match.group(3)!) : 0;

        debugPrint('Parsed values: hours = $hours, minutes = $minutes, seconds = $seconds');

        // 시간, 분, 초를 시간 단위로 환산하여 합산
        return hours.toDouble() + (minutes / 60.0) + (seconds / 3600.0);
      }
    } catch (e) {
      print('Error parsing duration: $e');
    }

    return 0.0; // 기본값 0.0 반환
  }





  Future<void> fetchDailySubjectStatistics(String targetDate, String subjectName) async {
    try {
      final response = await TimerApiHelper().fetchDailySubjectStatistics(targetDate, subjectName);

      // 응답 로그 확인
      print('Received daily statistics: $response');

      // 응답에서 날짜별 데이터를 가져오기
      Map<String, dynamic> dailyData = response; // 예시 응답: monday, tuesday 등 포함
      print('*************************');
      print('$dailyData');
      print("dailyData = $dailyData, type = ${dailyData.runtimeType}");

      // 각 요일에 대해 데이터를 변환하여 List<double>로 저장
      List<double> dailyDataInHours = [
        dailyData['monday'] ?? 'PT0S',
        dailyData['tuesday'] ?? 'PT0S',
       dailyData['wednesday'] ?? 'PT0S',
        dailyData['thursday'] ?? 'PT0S',
        dailyData['friday'] ?? 'PT0S',
       dailyData['saturday'] ?? 'PT0S',
        dailyData['sunday'] ?? 'PT0S',
      ];
      debugPrint('@@@@@@@@@@ $dailyDataInHours');


      // 부족한 데이터는 0으로 채움
      dailyDataInHours = fillMissingData(dailyDataInHours, 7); // 7일로 맞추기
      debugPrint('@@@@@@@@@@ $dailyDataInHours');

      setState(() {
        subjectData[subjectName] = {
          "daily": dailyDataInHours,
        };
      });
    } catch (e) {
      print('Error fetching daily data: $e');
    }
  }


  Future<void> fetchWeeklySubjectStatistics(String targetDate, String subjectName) async {
    try {
      final response = await TimerApiHelper().fetchWeeklySubjectStatistics(targetDate, subjectName);

      // 응답 로그 확인
      print('Received weekly statistics: $response');

      // 응답에서 날짜별 데이터를 가져오기
      Map<String, dynamic> weeklyData = response; //
      print('*************************');
      print('$weeklyData');
      print("weeklyData = $weeklyData, type = ${weeklyData.runtimeType}");

      // 각 요일에 대해 데이터를 변환하여 List<double>로 저장
      List<double> weeklyDataInHours = [
        weeklyData['firstWeek'] ?? 'PT0S',
        weeklyData['secondWeek'] ?? 'PT0S',
        weeklyData['thirdWeek'] ?? 'PT0S',
        weeklyData['fourthWeek'] ?? 'PT0S',

      ];
      debugPrint('@@@@@@@@@@ $weeklyDataInHours');


      // 부족한 데이터는 0으로 채움
      weeklyDataInHours = fillMissingData(weeklyDataInHours, 4); // 4주로 맞추기
      debugPrint('@@@@@@@@@@ $weeklyDataInHours');

      setState(() {
        subjectData[subjectName] = {
          "weekly": weeklyDataInHours,
        };
      });
    } catch (e) {
      print('Error fetching weekly data: $e');
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
        await fetchDailySubjectStatistics(targetDate, selectedSubject);
        fetchWeeklySubjectStatistics(targetDate, selectedSubject);// API 호출
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

          // 날짜 변경 시 API 호출
          if (selectedSubject.isNotEmpty && selectedDay != null) {
            final targetDate = selectedDay!.toIso8601String().split('T').first;

            // 일간/주간 모드에 맞는 API 호출
            if (isDailySelected) {
              fetchDailySubjectStatistics(targetDate, selectedSubject); // 일간 모드에서는 daily API 호출
            } else {
              fetchWeeklySubjectStatistics(targetDate, selectedSubject); // 주간 모드에서는 weekly API 호출
            }
          }
        });
      },
      isDailySelected: isDailySelected,
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
                      // 일간 모드로 변경 시 해당 API 호출
                      if (selectedSubject.isNotEmpty && selectedDay != null) {
                        final targetDate = selectedDay!.toIso8601String().split('T').first;
                        fetchDailySubjectStatistics(targetDate, selectedSubject); // 일간 API 호출
                      }
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
                      // 주간 모드로 변경 시 해당 API 호출
                      if (selectedSubject.isNotEmpty && selectedDay != null) {
                        final targetDate = selectedDay!.toIso8601String().split('T').first;
                        fetchWeeklySubjectStatistics(targetDate, selectedSubject); // 주간 API 호출
                      }
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
                      ?  getWeekIndex(selectedDay!) // 주간: 선택된 주의 인덱스 // 주간 모드에서 선택된 주의 인덱스
                      : null, // 하이라이트 없음
                ),
              ),

              SizedBox(height: 20.h),
              Divider(color: white1, thickness: 2),

              SubjectDropdown(
                selectedSubject: selectedSubject,
                subjectsList: subjectsList,
                onSubjectChanged: (newSubject) {
                  setState(() {
                    selectedSubject = newSubject ?? '';
                  });

                  // 과목 변경 시 API 호출
                  if (selectedDay != null && selectedSubject.isNotEmpty) {
                    final targetDate = selectedDay!.toIso8601String().split('T').first;
                    if (isDailySelected) {
                      fetchDailySubjectStatistics(targetDate, selectedSubject);
                    } else {
                      fetchWeeklySubjectStatistics(targetDate, selectedSubject);
                    }
                  }
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
              // BarGraph에 데이터를 전달하는 부분 수정

              Container(
                height: 150.h, // 원하는 높이로 설정
                child: Builder(
                  builder: (context) {
                    // 데이터 전달 전 로그 추가
                    final graphData = isDailySelected
                        ? fillMissingData(
                      subjectData[selectedSubject]?["daily"] ?? [],
                      7,  // 일간 데이터는 7일로 맞춤
                    )
                        : fillMissingData(
                      subjectData[selectedSubject]?["weekly"] ?? [],
                      4,  // 주간 데이터는 4주로 맞춤
                    );

                    // 로그 출력
                    print('Data passed to BarGraph: $graphData');

                    return BarGraph(
                      data: graphData,
                      labels: isDailySelected ? dailyLabels : weeklyLabels,
                      highlightedIndex: selectedDay != null
                          ? (isDailySelected
                          ? getDayIndex(selectedDay!)  // 일간 모드에서 선택된 날짜의 요일 인덱스
                          : getWeekIndex(selectedDay!))  // 주간 모드에서 선택된 주의 인덱스
                          : null,
                    );
                  },
                ),
              ),



              SizedBox(height: 20.h),
              Divider(color: white1, thickness: 2),
            ],

          ),
        ),
      ),
    );
  }
}
