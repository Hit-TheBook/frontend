import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class WeekCalendarComponent extends StatefulWidget {
  final Function(List<DateTime>) onWeekSelected;

  const WeekCalendarComponent({Key? key, required this.onWeekSelected}) : super(key: key);

  @override
  _WeekCalendarComponentState createState() => _WeekCalendarComponentState();
}

class _WeekCalendarComponentState extends State<WeekCalendarComponent> {
  DateTime _focusedDay = DateTime.now();
  List<DateTime> _selectedWeek = [];

  void _selectDateCupertino(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // 배경을 어두운 색으로 설정
      builder: (BuildContext context) {
        return Container(
          height: 220.h, // 팝업 높이 설정
          color: Colors.white, // 배경색 설정
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  height: 160.h, // 날짜 선택기 높이 설정
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: _focusedDay, // 초기값을 현재 날짜로 설정
                    minimumDate: DateTime.utc(2020, 1, 1),
                    maximumDate: DateTime.utc(2070, 12, 31),
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        _focusedDay = newDate; // 선택된 날짜로 _focusedDay 업데이트
                        _selectedWeek = _getWeekDays(newDate); // 선택한 날짜의 주간 날짜 업데이트
                      });
                      widget.onWeekSelected(_selectedWeek); // 콜백 호출
                    },
                  ),
                ),
              ),
              CupertinoButton(
                child: const Text('완료'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _selectDateCupertino(context),
              child: Text(
                '${_focusedDay.year}년 ${_focusedDay.month}월',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            IconButton(
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              iconSize: 24.sp,
              onPressed: () => _selectDateCupertino(context),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2.w,
                blurRadius: 5.r,
                offset: Offset(0, 3.h),
              ),
            ],
          ),
          child: TableCalendar(
            locale: 'ko_KR',
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              leftChevronVisible: false,
              rightChevronVisible: false,
            ),
            calendarStyle: CalendarStyle(
              defaultTextStyle: TextStyle(color: Colors.black, fontSize: 14.sp),
              selectedTextStyle: TextStyle(color: Colors.black, fontSize: 14.sp),
              todayTextStyle: TextStyle(color: Colors.black, fontSize: 14.sp),
              // 선택된 날짜의 배경색과 테두리 설정
              selectedDecoration: BoxDecoration(
                color: neonskyblue1, // 선택된 날짜 배경색
                shape: BoxShape.circle, // 원형으로 만들기
                border: Border.all(
                  color: Colors.white, // 테두리 색상
                  width: 2.w, // 테두리 두께
                ),
              ),
            ),
            // 선택된 주간 날짜들을 강조
            selectedDayPredicate: (day) {
              return _selectedWeek.any((selectedDay) =>
              selectedDay.year == day.year &&
                  selectedDay.month == day.month &&
                  selectedDay.day == day.day);
            },
            onDaySelected: null, // 날짜 선택 비활성화
          ),
        ),
      ],
    );
  }

  List<DateTime> _getWeekDays(DateTime selectedDay) {
    final int startOffset = selectedDay.weekday - 1;
    final List<DateTime> weekDays = [];

    for (int i = 0; i < 7; i++) {
      weekDays.add(selectedDay.subtract(Duration(days: startOffset - i)));
    }

    return weekDays;
  }
}
