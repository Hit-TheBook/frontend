import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:project1/widgets/time_circle_planner_painter.dart';

class TimeCirclePlannerPage extends StatefulWidget {
  const TimeCirclePlannerPage({super.key});

  @override
  _TimeCirclePlannerPageState createState() => _TimeCirclePlannerPageState();
}

class _TimeCirclePlannerPageState extends State<TimeCirclePlannerPage> {
  int colorIndex = 0;
  double startAngle = 0;
  double sweepAngle = pi / 12; // 30도 (한 시간)

  // 선택된 시작 시간과 종료 시간을 저장
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  void _showTimePicker(BuildContext context, bool isStart) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: isStart ? startTime : endTime,
            onDateTimeChanged: (DateTime newTime) {
              setState(() {
                if (isStart) {
                  startTime = newTime;
                } else {
                  endTime = newTime;
                }
              });
            },
          ),
        );
      },
    );
  }

  void _addTimeSegment() {
    setState(() {
      // 시작 시간과 종료 시간을 기준으로 각도를 계산
      startAngle = (startTime.hour % 24) * (pi / 12) - pi / 2; // 시작 각도 계산
      double endAngle = (endTime.hour % 24) * (pi / 12) - pi / 2; // 종료 각도 계산

      // 색상 채우기 위한 스윕 각도 계산
      sweepAngle = endAngle - startAngle;

      // 종료 각도가 시작 각도보다 작은 경우(예: 23시 30분부터 1시 30분까지)
      if (sweepAngle < 0) {
        sweepAngle += 2 * pi; // 360도 추가
      }

      colorIndex++; // 다음 색상
    });
  }

  // 시작 시간과 종료 시간의 각도를 계산하는 메서드
  double _calculateStartAngle() {
    return (startTime.hour % 24) * (pi / 12) - pi / 2; // 24시간 기준
  }

  double _calculateEndAngle() {
    return (endTime.hour % 24) * (pi / 12) - pi / 2; // 24시간 기준
  }

  @override
  Widget build(BuildContext context) {
    // 시작 각도 및 종료 각도 계산
    double startAngle = _calculateStartAngle();
    double endAngle = _calculateEndAngle();

    return Scaffold(
      appBar: AppBar(title: const Text('원 시간표')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              size: const Size(300, 300),
              painter: TimeCirclePlannerPainter(startAngle, endAngle - startAngle, colorIndex as int), // 색칠할 영역
            ),
            const SizedBox(height: 20),
            Text(
              '시작 시간: ${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              '종료 시간: ${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showTimePicker(context, true), // 시작 시간 선택
              child: const Text('시작 시간 선택'),
            ),
            ElevatedButton(
              onPressed: () => _showTimePicker(context, false), // 종료 시간 선택
              child: const Text('종료 시간 선택'),
            ),
            ElevatedButton(
              onPressed: _addTimeSegment,
              child: const Text('시간 추가'),
            ),
          ],
        ),
      ),
    );
  }
}
