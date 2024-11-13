import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class WeekCalendarComponent extends StatefulWidget {
  final Function(List<DateTime>, DateTime?) onWeekSelected;
  final bool isDailySelected;


  const WeekCalendarComponent({Key? key, required this.onWeekSelected,required this.isDailySelected, }) : super(key: key);


  // 주간 날짜 계산 메서드
  List<DateTime> getWeekDays(DateTime referenceDate) {
    final startOfWeek = referenceDate.subtract(Duration(days: referenceDate.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  @override
  _WeekCalendarComponentState createState() => _WeekCalendarComponentState();
}

class _WeekCalendarComponentState extends State<WeekCalendarComponent> {
  DateTime _focusedDay = DateTime.now();  // 오늘 날짜로 초기화
  List<DateTime> _selectedWeek = [];
  DateTime? _selectedDay; // 단일 날짜를 위한 변수

  @override
  void initState() {
    super.initState();
    // isDailySelected 값에 따라 초기화
    _initializeCalendar(widget.isDailySelected);
  }

  // isDailySelected 값에 따라 초기화하는 메서드
  void _initializeCalendar(bool isDailySelected) {
    if (isDailySelected) {
      // 일간 모드 - 오늘 날짜로 설정
      _focusedDay = DateTime.now();
      _selectedDay = _focusedDay;  // 오늘 날짜를 선택
      _selectedWeek = [];
    } else {
      // 주간 모드 - 이번 주의 날짜들로 설정
      _focusedDay = DateTime.now();
      _selectedWeek = widget.getWeekDays(_focusedDay);  // 이번 주의 날짜들
      _selectedDay = null;  // 주간 모드에서는 단일 날짜 선택하지 않음
    }
  }

  // 주간 모드로 전환할 때 호출하는 메서드
  void _updateSelectedWeekToToday() {
    setState(() {
      _focusedDay = DateTime.now(); // 오늘 날짜로 변경
      _selectedWeek = widget.getWeekDays(_focusedDay);  // 오늘 기준으로 주간 날짜 업데이트
      _selectedDay = null; // 선택된 날짜를 초기화
    });
    widget.onWeekSelected(_selectedWeek, _selectedDay);  // 콜백 호출
  }

  // 주간을 선택했을 때 항상 오늘 기준으로 업데이트
  void _handleWeekButtonPress() {
    if (!widget.isDailySelected) {
      _updateSelectedWeekToToday();  // 오늘 기준으로 주간 강조
    }
  }

  @override
  void didUpdateWidget(WeekCalendarComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // isDailySelected 값이 변경되었을 때 초기화
    if (oldWidget.isDailySelected != widget.isDailySelected) {
      _initializeCalendar(widget.isDailySelected);
    }
  }

  void _selectDateCupertino(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Container(
          height: 220.h,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  height: 160.h,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: _focusedDay,
                    minimumDate: DateTime.utc(2020, 1, 1),
                    maximumDate: DateTime.utc(2070, 12, 31),
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        _focusedDay = newDate;
                        _selectedWeek = widget.getWeekDays(newDate);  // 주간 날짜 업데이트
                        _selectedDay = newDate; // 단일 날짜 선택
                      });
                      widget.onWeekSelected(_selectedWeek, _selectedDay);  // 콜백 호출
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
              selectedDecoration: BoxDecoration(
                color: neonskyblue1,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2.w,
                ),
              ),
              todayDecoration: BoxDecoration(),
            ),
            selectedDayPredicate: widget.isDailySelected
                ? (day) {
              return _selectedDay != null &&
                  day.year == _selectedDay!.year &&
                  day.month == _selectedDay!.month &&
                  day.day == _selectedDay!.day;
            }
                : (day) {
              // 주간 날짜 강조: day.year, day.month, day.day 직접 비교
              return _selectedWeek.any((selectedDay) =>
              selectedDay.year == day.year &&
                  selectedDay.month == day.month &&
                  selectedDay.day == day.day);
            },
            onDaySelected: widget.isDailySelected
                ? (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                _selectedWeek = widget.getWeekDays(focusedDay);  // 주간 날짜 업데이트
                _selectedDay = selectedDay;  // 선택된 날짜 업데이트
              });
              widget.onWeekSelected(_selectedWeek, _selectedDay);  // 콜백 호출
            }
                : null,
          ),
        ),
      ],
    );
  }
}
