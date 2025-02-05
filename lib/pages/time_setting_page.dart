import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Cupertino 관련 위젯을 사용하기 위한 import
import 'package:project1/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'study_timer_page.dart';

class TimeSettingPage extends StatefulWidget {
  final int timerId;
  final String subjectName;
  final Duration totalStudyTime;
  final int totalScore;

  TimeSettingPage({
    required this.timerId,
    required this.subjectName,
    required this.totalStudyTime,
    required this.totalScore,
  });



  @override
  _TimeSettingPageState createState() => _TimeSettingPageState();
}

class _TimeSettingPageState extends State<TimeSettingPage> {
  Duration targetTime = Duration(hours: 0, minutes: 0, seconds: 0);
  @override
  void initState() {
    super.initState();

    // 이전 페이지에서 전달된 값들을 출력
    debugPrint('받은 timerId: ${widget.timerId}');
    debugPrint('받은 subjectName: ${widget.subjectName}');
    debugPrint('받은 totalStudyTime: ${widget.totalStudyTime}');
    debugPrint('받은 totalScore: ${widget.totalScore}');
  }

  String formatTime(Duration duration) {
    final formattedHours = duration.inHours.toString().padLeft(2, '0');
    final formattedMinutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final formattedSeconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$formattedHours:$formattedMinutes:$formattedSeconds';
  }

  int get targetscore {
    // 목표시간에 1분당 1점 계산
    return targetTime.inMinutes;
  }

  // CupertinoTimePicker를 호출하는 함수
  Future<void> _selectTime(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('목표시간 설정'),
          actions: <Widget>[
            Container(
              height: 200.h,
              child: CupertinoTimerPicker(
                initialTimerDuration: targetTime,
                onTimerDurationChanged: (Duration duration) {
                  setState(() {
                    targetTime = duration;
                  });
                },
                mode: CupertinoTimerPickerMode.hms, // 시, 분, 초 모드로 변경
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('완료'),
            onPressed: () {
              Navigator.pop(context); // 선택을 마친 후 팝업 닫기
            },
          ),
        );
      },
    );
  }

  // '시작' 텍스트가 활성화될 조건 체크
  bool get isStartTextEnabled {
    return targetTime.inMinutes >= 10;
  }

  // '시작' 텍스트 클릭 시 이동할 페이지 (예: TimerPage)
  void _startTimer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudyTimerPage(
          timerId: widget.timerId,
          subjectName: widget.subjectName,
          totalStudyTime: widget.totalStudyTime,
          //point: widget.totalScore,
          targetTime: targetTime,
          targetscore: targetscore,

        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('목표시간 설정', style: TextStyle(fontSize: 18.sp)),
        actions: [
          // "시작" 텍스트를 AppBar 오른쪽에 배치
          TextButton(
            onPressed: isStartTextEnabled ? () => _startTimer(context) : null,
            child: Text(
              '시작',
              style: TextStyle(
                fontSize: 14.sp,
                color: isStartTextEnabled ? neonskyblue1 : Colors.grey, // 비활성화 색상
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new), // 원하는 아이콘으로 변경
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기 버튼 동작
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text('목표시간', style: TextStyle(fontSize: 12.sp)),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 10.0.h),
              decoration: BoxDecoration(
                color: gray1,
                borderRadius: BorderRadius.circular(8.0.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        formatTime(targetTime),
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: () => _selectTime(context),
                        child: Container(
                          width: 15.w,
                          height: 15.h,
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.chevron_right,
                            size: 15.sp,
                            color: neonskyblue1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '목표시간 달성 시 획득 점수: $targetscore',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              '목표시간 설정은 최소 10분부터 가능합니다.',
              style: TextStyle(fontSize: 12.sp, color: neonskyblue1),
            ),
            SizedBox(height: 30.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '목표시간 점수 안내',
                  style: TextStyle(fontSize: 12.sp, color: white1),
                ),
                Image.asset(
                  'assets/images/timegoal.png',
                  width: 210.w,
                  height: 270.h,
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
