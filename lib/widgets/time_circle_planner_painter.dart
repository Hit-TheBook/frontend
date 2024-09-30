import 'package:flutter/material.dart';
import 'dart:math';




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

  final double startAngle;
  final double sweepAngle;
  final int colorIndex;

  TimeCirclePlannerPainter(this.startAngle, this.sweepAngle, this.colorIndex);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    // 전체 배경을 흰색으로 채우기
    canvas.drawCircle(center, radius, paint);

    // 색상 설정
    paint..color = colors[colorIndex % colors.length];

    // 특정 영역 색칠
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      true, // 부채꼴로 채우기
      paint,
    );

    // 시계 숫자 그리기 (24등분)
    for (int i = 0; i < 24; i++) {
      final angle = i * (pi / 12) - pi / 2; // 15도 단위
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$i', // 0부터 23까지 숫자 표시
          style: TextStyle(color: Colors.white, fontSize: 20), // 글씨 색상을 빨간색으로 변경
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // 숫자를 원의 외부에 위치시키기
      final x = center.dx + (radius + 25) * cos(angle) - textPainter.width / 2; // 50 픽셀 바깥으로
      final y = center.dy + (radius + 25) * sin(angle) - textPainter.height / 2;
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
