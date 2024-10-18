import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // flutter_screenutil import
import 'dart:math';

import '../models/planner_model.dart';

class TimeCirclePlannerPainter extends CustomPainter {
  final List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];
  final List<PlannerModel> schedules; // PlannerModel 리스트를 받는 생성자

  TimeCirclePlannerPainter(this.schedules);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    double radius = size.width / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    // 전체 배경을 흰색으로 채우기
    paint.color = Colors.white;
    canvas.drawCircle(center, radius, paint);

    // 각 일정에 대해 색칠
    for (int i = 0; i < schedules.length; i++) {
      final schedule = schedules[i];
      double startAngle = timeToAngle(schedule.startAt);
      double endAngle = timeToAngle(schedule.endAt);

      // 종료 시간이 시작 시간보다 앞에 있으면 부채꼴을 한 바퀴 돌아서 색칠
      double sweepAngle = endAngle >= startAngle
          ? endAngle - startAngle
          : 2 * pi - (startAngle - endAngle);

      // 색상 설정
      paint.color = colors[i % colors.length]; // 색상 배열 순환

      // 특정 영역 색칠
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true, // 부채꼴로 채우기
        paint,
      );
      // 부채꼴 중간 지점에 텍스트 추가
      double middleAngle = startAngle + sweepAngle / 2;
      final textPainter = TextPainter(
        text: TextSpan(
          text: schedule.scheduleTitle,
          style: TextStyle(
            color: Colors.black, // 텍스트 색상
            fontSize: 12.sp, // 텍스트 크기
            fontWeight: FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // 텍스트를 부채꼴 중간에 위치시키기
      final x = center.dx + (radius / 1.5) * cos(middleAngle) - textPainter.width / 2;
      final y = center.dy + (radius / 1.5) * sin(middleAngle) - textPainter.height / 2;
      textPainter.paint(canvas, Offset(x, y));
    }




    // 시계 숫자 그리기 (12시간제로 표시)
    for (int i = 0; i < 24; i++) {
      final angle = i * (pi / 12) - pi / 2; // 15도 단위 (12시 기준)
      final textPainter = TextPainter(
        text: TextSpan(
          text: convertTo12HourFormat(i), // 12시간 형식으로 변환된 숫자 표시
          style: TextStyle(
            color: Colors.white, // 숫자의 색을 검정색으로 변경
            fontSize: 12.sp, // 화면 크기에 따라 동적으로 크기 조정
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // 숫자를 원의 외부에 위치시키기
      final x = center.dx + (radius + 15) * cos(angle) - textPainter.width / 2;
      final y = center.dy + (radius + 15) * sin(angle) - textPainter.height / 2;
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  // 시간 -> 각도 변환 함수 (24시간 기준, 시계에서 12시가 -pi/2)
  double timeToAngle(DateTime time) {
    int hours = time.hour % 24; // 24시간 형식으로 변환
    double minutes = time.minute / 60;
    double totalHours = hours + minutes;
    return (totalHours / 24) * 2 * pi - pi / 2; // 24시간 기준으로 각도 계산
  }

  // 숫자 변환 함수 (12시간 형식)
  String convertTo12HourFormat(int hour) {
    if (hour == 0) {
      return '12'; // 0시는 12시로 표시
    } else if (hour > 12) {
      return '${hour - 12}'; // 13시부터는 12를 빼서 12시간제로 변환
    } else {
      return '$hour'; // 그 외는 그대로 표시
    }
  }
}