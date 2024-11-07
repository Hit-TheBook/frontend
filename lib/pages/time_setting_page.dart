import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Cupertino 관련 위젯을 사용하기 위한 import
import 'package:project1/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeSettingPage extends StatefulWidget {
  final int timerId;
  final String subjectName;
  final String studyTimeLength;
  final int point;

  TimeSettingPage({
    required this.timerId,
    required this.subjectName,
    required this.studyTimeLength,
    required this.point,
  });

  @override
  _TimeSettingPageState createState() => _TimeSettingPageState();
}

class _TimeSettingPageState extends State<TimeSettingPage> {
  int selectedHours = 0;
  int selectedMinutes = 0;

  String formatTime(int hours, int minutes) {
    final formattedHours = hours.toString().padLeft(2, '0');
    final formattedMinutes = minutes.toString().padLeft(2, '0');
    return '$formattedHours:$formattedMinutes:00';
  }

  int get goalPoint {
    // 목표시간에 1분당 1점 계산
    return selectedHours * 60 + selectedMinutes;
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
                initialTimerDuration: Duration(hours: selectedHours, minutes: selectedMinutes),
                onTimerDurationChanged: (Duration duration) {
                  setState(() {
                    selectedHours = duration.inHours;
                    selectedMinutes = duration.inMinutes % 60;
                  });
                },
                mode: CupertinoTimerPickerMode.hm, // 시와 분만 설정할 수 있도록 모드 지정
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('목표시간 설정', style: TextStyle(fontSize: 18.sp)),
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
              padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 10.0.h), // 내부 패딩 조정
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
                        formatTime(selectedHours, selectedMinutes),
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: () => _selectTime(context),
                        child: Container(
                          width: 15.w, // 아이콘의 너비
                          height: 15.h, // 아이콘의 높이
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
                    '목표시간 달성 시 획득 점수: $goalPoint',
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
              crossAxisAlignment: CrossAxisAlignment.start,  // 기본 설정
              children: [
                Text(
                  '목표시간 점수 안내',
                  style: TextStyle(fontSize: 12.sp, color: white1),
                ),
                Image.asset(
                  'assets/images/timegoal.png',
                  width: 210.w, // 이미지 너비 설정
                  height: 270.h, // 이미지 높이 설정
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
