import 'package:flutter/material.dart';
import 'package:project1/widgets/week_calendar_component.dart';
import 'package:project1/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimerUsageReportPage extends StatefulWidget {
  const TimerUsageReportPage({Key? key}) : super(key: key);

  @override
  _TimerUsageReportPageState createState() => _TimerUsageReportPageState();
}

class _TimerUsageReportPageState extends State<TimerUsageReportPage> {
  List<DateTime> selectedWeekDays = [];
  bool isDailySelected = true; // 플래그 변수: 일간/주간 선택 상태

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '통계',
          style: TextStyle(fontSize: 18.sp), // ScreenUtil로 크기 조정
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w), // ScreenUtil을 활용해 패딩 크기 조정
        child: SingleChildScrollView(  // 스크롤을 추가한 부분
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
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDailySelected ? neonskyblue1 : Colors.white,
                      minimumSize: Size(54.w, 24.h), // ScreenUtil로 버튼 크기 조정
                    ),
                    child: Text('일간', style: TextStyle(fontSize: 14.sp)), // 글씨 크기 조정
                  ),
                  SizedBox(width: 10.w),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isDailySelected = false;
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

              // 일간 버튼이 활성화되었을 때만 표시
              if (isDailySelected) ...[
                WeekCalendarComponent(
                  onWeekSelected: (weekDays) {
                    setState(() {
                      selectedWeekDays = weekDays;
                    });
                  },
                ),
                SizedBox(height: 20.h),
                Text(
                  '선택된 날짜',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                ...selectedWeekDays.map((day) => Text(
                  day.toIso8601String(),
                  style: TextStyle(fontSize: 14.sp),
                )).toList(),
              ] else
                Text(
                  '주간 통계 보기 화면입니다.',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
