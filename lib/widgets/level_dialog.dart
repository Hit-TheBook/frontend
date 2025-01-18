import 'package:project1/colors.dart';
import '../models/level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 추가

// 레벨 이름에 따른 색상 매핑
Color getLevelColor(String levelName) {
  if (levelName.contains("BLUE")) {
    return Colors.blue;
  } else if (levelName.contains("GREEN")) {
    return Colors.green;
  } else if (levelName.contains("YELLOW")) {
    return Colors.yellow;
  } else if (levelName.contains("ORANGE")) {
    return Colors.orange;
  } else if (levelName.contains("RED")) {
    return Colors.red;
  } else {
    return Colors.black;
  }
}

void showLevelDialog(BuildContext context, Offset buttonPosition) {
  final screenWidth = MediaQuery.of(context).size.width;
  final dialogWidth = 180.w; // 다이얼로그의 너비 (스크린 비율 기반)
  final dialogPadding = 8.w; // 다이얼로그 좌우 여백

  // 다이얼로그의 x 위치를 계산, 화면 경계 밖으로 나가지 않도록 제한
  final dialogX = (buttonPosition.dx - dialogWidth / 2).clamp(
    dialogPadding,
    screenWidth - dialogWidth - dialogPadding,
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Stack(
        children: [
          Positioned(
            left: dialogX,
            top: buttonPosition.dy + 40.h, // 버튼 아래로 배치 (스크린 비율 기반)
            child: Dialog(
              backgroundColor: Colors.transparent, // 다이얼로그 배경 투명
              child: CustomPaint(
                painter: SpeechBubblePainter(
                  color: gray1,
                  tailPosition: dialogWidth + 30.w, // 꼬리 위치를 우측 하단으로 이동
                ),
                child: Container(
                  padding: EdgeInsets.all(8.w), // 내부 여백
                  constraints: BoxConstraints(
                    maxWidth: dialogWidth, // 다이얼로그 최대 너비
                    maxHeight: 150.h, // 다이얼로그 최대 높이
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: levels.map((level) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h), // 간격
                          child: Text(
                            level.maxPoint == 999999999
                                ? '${level.name}: ${level.minPoint} 이상'
                                : '${level.name}: ${level.minPoint} ~ ${level.maxPoint}',
                            style: TextStyle(
                              fontSize: 10.sp, // 스크린 비율 기반 글씨 크기
                              color: getLevelColor(level.name),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

/// 말풍선 모양을 그리는 CustomPainter
class SpeechBubblePainter extends CustomPainter {
  final Color color;
  final double tailPosition;

  SpeechBubblePainter({required this.color, required this.tailPosition});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(20.w, 0) // 좌측 상단 시작점
      ..lineTo(size.width - 20.w, 0) // 우측 상단
      ..arcToPoint(
        Offset(size.width, 20.h),
        radius: Radius.circular(20.r),
      ) // 우측 상단 라운드
      ..lineTo(size.width, size.height - 30.h) // 우측 하단
      ..lineTo(tailPosition + 10.w, size.height) // V자 꼬리 오른쪽
      ..lineTo(tailPosition, size.height + 15.h) // V자 끝
      ..lineTo(tailPosition - 10.w, size.height) // V자 꼬리 왼쪽
      ..lineTo(20.w, size.height) // 좌측 하단
      ..arcToPoint(
        Offset(0, size.height - 20.h),
        radius: Radius.circular(20.r),
      ) // 좌측 하단 라운드
      ..lineTo(0, 20.h) // 좌측 상단
      ..arcToPoint(
        Offset(20.w, 0),
        radius: Radius.circular(20.r),
      ) // 좌측 상단 라운드
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
