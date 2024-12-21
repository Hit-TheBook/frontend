import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project1/pages/study_page.dart';
import 'package:project1/pages/time_setting_page.dart';
import 'package:project1/pages/timer_usage_report.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../colors.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/customfloatingactionbutton.dart';
import 'package:project1/pages/timer_detail_page.dart';
import 'package:project1/utils/timer_api_helper.dart';
import 'dart:convert';



class TimerPage extends StatefulWidget {
  const TimerPage({super.key});


  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHours = true;

  final DateTime _selectedDate = DateTime.now();
  int totalScore = 0;
  String displayedTime = '00:00:00';
  final TimerApiHelper _timerApiHelper = TimerApiHelper();

  List<Map<String, dynamic>> timerData = [];


  Duration convertToDuration(dynamic totalStudyTime) {
    if (totalStudyTime is Duration) {
      // 이미 Duration 타입이면 그대로 반환
      return totalStudyTime;
    } else if (totalStudyTime is Map<String, dynamic>) {
      // Map<String, dynamic> 타입인 경우, 'seconds' 값을 추출하여 Duration으로 변환
      final seconds = totalStudyTime['seconds'] ?? 0;
      return Duration(seconds: seconds);
    } else {
      // 예상하지 못한 타입일 경우 기본값으로 0초 반환
      return Duration.zero;
    }
  }


  @override
  void initState() {
    super.initState();
    fetchTimerContentList(); // 화면이 로드될 때 API 호출
    fetchStudyTime();
  }
  // fetchStudyTime API를 호출하여 studyTime과 score를 가져옵니다.
  Future<void> fetchStudyTime() async {
    try {
      final studyTimeData = await _timerApiHelper.fetchStudyTime();

      // studyTimeLength가 문자열로 제공되는 경우
      final studyTimeLength = studyTimeData.studyTimeLength;
      if (studyTimeLength != null) {
        // ISO 8601 형식의 문자열을 Duration 객체로 변환
        Duration studyTimeDuration = _parseDuration(studyTimeLength);

        setState(() {
          displayedTime = formatDuration(studyTimeDuration); // Duration 형식으로 변환하여 표시
          totalScore = studyTimeData.score; // 점수 업데이트
        });
      } else {
        // studyTimeLength가 null인 경우 처리
        setState(() {
          displayedTime = '00:00:00'; // 기본값
          totalScore = studyTimeData.score;
        });
      }
    } catch (error) {
      print('studyTime 가져오기 실패: $error');
    }
  }

// ISO 8601 문자열을 Duration으로 변환하는 함수
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchTimerContentList(); // 화면에 다시 진입할 때 API 호출
    fetchStudyTime();
  }
  /// API를 호출하여 타이머 데이터를 가져옵니다.
  Future<void> fetchTimerContentList() async {
    try {
      // TimerApiHelper에서 API 호출
      final timerList = await _timerApiHelper.getTimerList();

      setState(() {
        timerData = timerList; // 가져온 데이터를 timerData에 할당
      });
    } catch (error) {
      print('타이머 데이터 가져오기 실패: $error');
    }
  }


  Future<void> deleteTimer(int timerId) async {
    // API 호출
    bool success = await _timerApiHelper.deleteTimer(timerId);

    if (success) {
      // 삭제 성공 시 UI 업데이트
      setState(() {
        timerData.removeWhere((entry) => entry['timerId'] == timerId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('과목 삭제 성공')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('과목 삭제 실패')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        '${_selectedDate.year}년 ${_selectedDate.month}월 ${_selectedDate.day}일';

    return Scaffold(
      appBar: CustomAppBar(
        title: '타이머',
        showBackButton: true,
        onBackPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => StudyPage()),  // 첫 번째 페이지로 이동
                (Route<dynamic> route) => false,  // 이전 페이지 모두 제거
          );
        },
      ),



      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formattedDate,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp, // 사용한 부분
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h), // ScreenUtil로 높이 조정
            Text(
              displayedTime,
              style: TextStyle(
                color: neonskyblue1,
                fontSize: 32.sp, // 사용한 부분
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h), // ScreenUtil로 높이 조정
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '오늘 획득 총 점수:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp, // 사용한 부분
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.w), // ScreenUtil로 너비 조정
                Text(
                  '$totalScore',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp, // 사용한 부분
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 7.h), // ScreenUtil로 높이 조정
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.bar_chart,
                    size: 20,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TimerUsageReportPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: 400.w, // ScreenUtil로 너비 조정
                    color: const Color(0xff333333),
                    child: Table(
                      border: TableBorder(
                        verticalInside:
                        BorderSide(color: Colors.black54, width: 2),
                        horizontalInside:
                        BorderSide(color: Colors.black54, width: 2),
                      ),
                      defaultVerticalAlignment:
                      TableCellVerticalAlignment.middle,
                      columnWidths: {
                        0: FixedColumnWidth(30.w), // ScreenUtil로 너비 조정
                        1: FixedColumnWidth(140.w), // ScreenUtil로 너비 조정
                        2: FixedColumnWidth(70.w), // ScreenUtil로 너비 조정
                        3: FixedColumnWidth(55.w), // ScreenUtil로 너비 조정
                        4: FixedColumnWidth(30.w), // ScreenUtil로 너비 조정
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Color(0xFF69EDFF),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                          ),
                          children: [
                            Container(
                              height: 30.h,
                              padding: EdgeInsets.all(4.0.w), // ScreenUtil로 패딩 조정
                              alignment: Alignment.center,
                              child: Text(
                                '시작',
                                style: TextStyle(
                                    color: Color(0xFF333333), fontSize: 12.sp),
                              ),
                            ),
                            Container(
                              height: 30.h,
                              padding: EdgeInsets.all(4.0.w), // ScreenUtil로 패딩 조정
                              alignment: Alignment.center,
                              child: Text(
                                '과목명',
                                style: TextStyle(
                                    color: Color(0xFF333333), fontSize: 12.sp),
                              ),
                            ),
                            Container(
                              height: 30.h,
                              padding: EdgeInsets.all(4.0.w), // ScreenUtil로 패딩 조정
                              alignment: Alignment.center,
                              child: Text(
                                '누적 시간',
                                style: TextStyle(
                                    color: Color(0xFF333333), fontSize: 12.sp),
                              ),
                            ),
                            Container(
                              height: 30.h,
                              padding: EdgeInsets.all(4.0.w), // ScreenUtil로 패딩 조정
                              alignment: Alignment.center,
                              child: Text(
                                '누적 점수',
                                style: TextStyle(
                                    color: Color(0xFF333333), fontSize: 12.sp),
                              ),
                            ),
                            Container(
                              height: 30.h,
                              padding: EdgeInsets.all(4.0.w), // ScreenUtil로 패딩 조정
                              alignment: Alignment.center,
                              child: Text(
                                '설정',
                                style: TextStyle(
                                    color: Color(0xFF333333), fontSize: 12.sp),
                              ),
                            ),
                          ],
                        ),
                        for (var entry in timerData)
                          TableRow(
                            decoration: BoxDecoration(
                              color: Color(0xFF333333),
                            ),
                            children: [
                              Container(
                                height: 30.h, // ScreenUtil로 높이 조정
                                padding: EdgeInsets.all(8.0.w), // ScreenUtil로 패딩 조정
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white,
                                    size: 18.sp, // ScreenUtil로 크기 조정
                                  ),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    Duration totalDuration = convertToDuration(entry['totalStudyTime']);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TimeSettingPage(
                                          timerId: entry['timerId'],
                                          subjectName: entry['subjectName'],
                                          totalStudyTime: totalDuration,
                                          totalScore: entry['totalScore'],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                height: 30.h, // ScreenUtil로 높이 조정
                                padding: EdgeInsets.all(8.0.w), // ScreenUtil로 패딩 조정
                                alignment: Alignment.center,
                                child: Text(entry['subjectName'] ?? '',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              // "누적 시간"을 포맷팅해서 표시
                              Container(
                                height: 30.h,
                                padding: EdgeInsets.all(8.0.w),
                                alignment: Alignment.center,
                                child: Builder(
                                  builder: (context) {
                                    // entry['totalStudyTime']이 Duration 객체라면 그대로 사용
                                    Duration totalDuration = entry['totalStudyTime'] is Duration
                                        ? entry['totalStudyTime']
                                        : convertToDuration(entry['totalStudyTime']);

                                    String formattedDuration = '${totalDuration.inHours.toString().padLeft(2, '0')}:${(totalDuration.inMinutes % 60).toString().padLeft(2, '0')}:${(totalDuration.inSeconds % 60).toString().padLeft(2, '0')}';

                                    return Text(formattedDuration, style: TextStyle(color: Colors.white,fontSize: 12.sp), );
                                  },
                                ),
                              ),

                              Container(
                                height: 30.h, // ScreenUtil로 높이 조정
                                padding: EdgeInsets.all(8.0.w), // ScreenUtil로 패딩 조정
                                alignment: Alignment.center,
                                child: Text(entry['totalScore']?.toString() ?? '',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              Container(
                                height: 30.h, // ScreenUtil로 높이 조정
                                padding: EdgeInsets.all(8.0.w), // ScreenUtil로 패딩 조정
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: Icon(Icons.more_vert, color: Colors.white, size: 18.sp),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    // Dialog로 중앙에 표시
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true, // 배경 클릭 시 닫기
                                      builder: (BuildContext context) {
                                        return Center(
                                          child: Container(
                                            width: 340.w,
                                            height: 110.h, // 고정 높이 설정
                                            decoration: BoxDecoration(
                                              color: gray1,
                                              borderRadius: BorderRadius.circular(15.r),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
                                              children: [
                                                // 첫 번째 버튼: 과목 이름 수정
                                                CupertinoActionSheetAction(
                                                  onPressed: () {
                                                    Navigator.pop(context); // 다이얼로그 닫기
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => TimerDetailPage(
                                                          isEditMode: true, // 수정 모드로 진입
                                                          initialSubjectName: entry['subjectName'], // 기존 과목명 전달
                                                          timerId: entry['timerId'], // 타이머 ID 전달
                                                        ),
                                                      ),
                                                    ).then((result) async {
                                                      if (result == true) {
                                                        await fetchTimerContentList(); // 데이터 새로고침
                                                        setState(() {}); // UI 갱신
                                                      }
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 8.h), // 버튼 높이 축소 조정
                                                    child: Text(
                                                      '과목 이름 수정',
                                                      style: TextStyle(color: white1, fontSize: 14.sp),
                                                    ),
                                                  ),
                                                ),
                                                // 구분선
                                                Divider(
                                                  color: Colors.white.withOpacity(0.5), // 구분선 색상
                                                  thickness: 1.h, // 구분선 두께
                                                  height: 0, // 구분선 자체 간격 제거
                                                ),
                                                // 두 번째 버튼: 과목 삭제
                                                CupertinoActionSheetAction(
                                                  onPressed: () {
                                                    Navigator.pop(context); // 다이얼로그 닫기
                                                    // CustomDialog 호출
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                            '삭제 후 점수 안내',
                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                          ),
                                                          content: Text(
                                                            '과목 삭제 후에도 사전에 처리된 점수에 영향을 주지 않습니다.',
                                                            style: TextStyle(fontSize: 14.sp, color: Colors.white),
                                                          ),
                                                          actions: <Widget>[
                                                            // 취소 및 확인 버튼을 같은 행에 배치
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 두 버튼을 양쪽 끝으로 배치
                                                              children: [
                                                                // 취소 버튼 (왼쪽 끝에 배치, 볼드체)
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.pop(context); // 다이얼로그 닫기
                                                                  },
                                                                  child: const Text(
                                                                    '취소',
                                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                  ),
                                                                ),
                                                                // 확인 버튼 (오른쪽 끝에 배치, 볼드체)
                                                                TextButton(
                                                                  onPressed: () async {
                                                                    Navigator.pop(context); // 다이얼로그 닫기

                                                                    // 삭제할 과목의 ID 가져오기 (entry['timerId'] 사용)
                                                                    int timerId = entry['timerId']; // 삭제할 과목의 ID

                                                                    // API 호출
                                                                    bool success = await TimerApiHelper().deleteTimer(timerId);

                                                                    if (success) {
                                                                      // 삭제 성공 시 UI 갱신
                                                                      setState(() {
                                                                        timerData.removeWhere((entry) => entry['timerId'] == timerId); // 삭제된 과목 제거
                                                                      });
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                        const SnackBar(content: Text('과목 삭제 성공')),
                                                                      );
                                                                    } else {
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                        const SnackBar(content: Text('과목 삭제 실패')),
                                                                      );
                                                                    }
                                                                  },
                                                                  child: const Text(
                                                                    '확인',
                                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                          backgroundColor: gray1,
                                                        );
                                                      },
                                                    );



                                                  },
                                                  isDestructiveAction: true, // 파괴적 동작 스타일 적용
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 8.h), // 버튼 높이 축소 조정
                                                    child: Text(
                                                      '과목 삭제',
                                                      style: TextStyle(fontSize: 14.sp, color: white1),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );






                                  },
                                ),




                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () async {
          // TimerDetailPage로 이동
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TimerDetailPage(),
            ),
          );

          // 과목이 추가되었으면 목록을 새로고침
          if (result == true) {
            fetchTimerContentList(); // 타이머 목록을 새로 불러오는 함수
            setState(() {}); // 화면을 갱신
          }
        },
      ),

    );
  }
}
