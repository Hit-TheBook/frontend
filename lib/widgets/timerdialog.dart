import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/colors.dart';

class TimerDialog extends StatelessWidget {
  final String title; // 다이얼로그 제목
  final Widget content; // 다이얼로그 내용 (위젯)
  final VoidCallback onConfirm; // 확인 버튼 콜백
  final double? width; // 다이얼로그 너비
  final double? height; // 다이얼로그 높이

  const TimerDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
    this.width,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15.sp, // 제목 크기 조정
        ),
      ),

      content: Container(
        width: width ?? MediaQuery.of(context).size.width * 0.8,
        height: height,
        //padding: EdgeInsets.all(3.0.sp),
        child: content,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onConfirm,
          child: Text(
            '확인',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.sp, // 버튼 텍스트 크기 조정
            ),
          ),
        ),
      ],
      backgroundColor: gray1, // 다이얼로그 배경 색상
    );
  }
}
