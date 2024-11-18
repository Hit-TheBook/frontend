import 'package:flutter/material.dart';
import 'package:project1/widgets/week_calendar_component.dart';
import 'package:project1/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/widgets/bargraph.dart';

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
  final List<double> dailyData = [30, 70, 110, 90, 60, 80,140];
  final List<String> dailyLabels = ["10/7", "10/8", "10/9", "10/10", "10/11", "10/12","10/13"]; // 일간 라벨

  final List<double> weeklyData = [50, 100, 150, 80];
  final List<String> weeklyLabels = ["Week1", "Week2", "Week3", "Week4"]; // 주간 라벨



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
                Divider(color: Colors.grey, thickness: 1),
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
                Divider(color: Colors.grey, thickness: 1),
              ],

              SizedBox(height: 20.h),
              BarGraph(
                data: isDailySelected ? dailyData : weeklyData,
                labels: isDailySelected ? dailyLabels : weeklyLabels,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
