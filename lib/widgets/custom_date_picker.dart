import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime minimumDate;
  final DateTime maximumDate;
  final ValueChanged<DateTime> onDateSelected;

  const CustomDatePicker({
    Key? key,
    required this.initialDate,
    required this.minimumDate,
    required this.maximumDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime tempDate;
  late int selectedYearIndex;
  late int selectedMonthIndex;
  late int selectedDayIndex;

  @override
  void initState() {
    super.initState();
    // 초기값 설정
    tempDate = widget.initialDate;
    selectedYearIndex = tempDate.year - widget.minimumDate.year;
    selectedMonthIndex = tempDate.month - 1;
    selectedDayIndex = tempDate.day - 1;
  }

  @override
  Widget build(BuildContext context) {
    // 월과 일 정보
    final months = List.generate(
      12,
          (index) => '${index + 1}월',
    );
    final daysInMonth = DateTime(tempDate.year, tempDate.month + 1, 0).day;
    final days = List.generate(
      daysInMonth,
          (index) => '${index + 1}일',
    );

    return Container(
      height: 250.h,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 200.h,
            child: Row(
              children: [
                // 년도 Picker
                Expanded(
                  flex: 3,
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 32.h,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedYearIndex = index;
                        tempDate = DateTime(
                          widget.minimumDate.year + selectedYearIndex,
                          tempDate.month,
                          tempDate.day,
                        );
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        return Center(
                          child: Text(
                            '${widget.minimumDate.year + (index % (widget.maximumDate.year - widget.minimumDate.year + 1))}년',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: index == selectedYearIndex
                                  ? CupertinoColors.activeBlue
                                  : CupertinoColors.black,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // 월 Picker
                Expanded(
                  flex: 2,
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 32.h,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedMonthIndex = index;
                        tempDate = DateTime(
                          tempDate.year,
                          (selectedMonthIndex % 12) + 1,
                          tempDate.day,
                        );
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        return Center(
                          child: Text(
                            '${(index % 12) + 1}월',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: index == selectedMonthIndex
                                  ? CupertinoColors.activeBlue
                                  : CupertinoColors.black,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // 일 Picker
                Expanded(
                  flex: 2,
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 32.h,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedDayIndex = index;
                        tempDate = DateTime(
                          tempDate.year,
                          tempDate.month,
                          (selectedDayIndex % daysInMonth) + 1,
                        );
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        return Center(
                          child: Text(
                            '${(index % daysInMonth) + 1}일',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: index == selectedDayIndex
                                  ? CupertinoColors.activeBlue
                                  : CupertinoColors.black,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          CupertinoButton(
            child: const Text('확인'),
            onPressed: () {
              widget.onDateSelected(tempDate);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
