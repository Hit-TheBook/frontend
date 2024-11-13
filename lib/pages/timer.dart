import 'package:flutter/material.dart';
import 'package:project1/pages/time_setting_page.dart';
import 'package:project1/pages/timer_usage_report.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../colors.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/customfloatingactionbutton.dart';
import 'package:project1/pages/timer_detail_page.dart';

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

  List<Map<String, dynamic>> timerData = [
    {
      'timerId': 0,
      'subjectName': '화학',
      'studyTimeLength': '06:00:00',
      'point': 0,
    },
    {
      'timerId': 1,
      'subjectName': '수학',
      'studyTimeLength': '11:00:00',
      'point': 10,
    },
    {
      'timerId': 2,
      'subjectName': '영어',
      'studyTimeLength': '12:00:00',
      'point': 20,
    },
  ];

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        '${_selectedDate.year}년 ${_selectedDate.month}월 ${_selectedDate.day}일';

    return Scaffold(
      appBar: const CustomAppBar(
        title: '타이머',
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TimeSettingPage(
                                          timerId: entry['timerId'],
                                          subjectName: entry['subjectName'],
                                          studyTimeLength: entry['studyTimeLength'],
                                          point: entry['point'],
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
                              Container(
                                height: 30.h, // ScreenUtil로 높이 조정
                                padding: EdgeInsets.all(8.0.w), // ScreenUtil로 패딩 조정
                                alignment: Alignment.center,
                                child: Text(entry['studyTimeLength'] ?? '',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              Container(
                                height: 30.h, // ScreenUtil로 높이 조정
                                padding: EdgeInsets.all(8.0.w), // ScreenUtil로 패딩 조정
                                alignment: Alignment.center,
                                child: Text(entry['point']?.toString() ?? '',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              Container(
                                height: 30.h, // ScreenUtil로 높이 조정
                                padding: EdgeInsets.all(8.0.w), // ScreenUtil로 패딩 조정
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: Icon(Icons.more_vert,
                                      color: Colors.white, size: 18.sp),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    print("설정 아이콘 클릭됨");
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TimerDetailPage(),
            ),
          );
        },
      ),
    );
  }
}
