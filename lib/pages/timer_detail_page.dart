import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/colors.dart';

class TimerDetailPage extends StatefulWidget {
  const TimerDetailPage({super.key});

  @override
  _TimerDetailPageState createState() => _TimerDetailPageState();
}

class _TimerDetailPageState extends State<TimerDetailPage> {
  String? scheduleTitle; // 과목 이름 저장

  bool get isFormValid => scheduleTitle != null && scheduleTitle!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('과목 추가'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: isFormValid
                ? () {
              // 완료 버튼 클릭 시 동작
              print('완료 버튼 활성화됨');
            }
                : null,
            child: Text(
              '완료',
              style: TextStyle(
                color: isFormValid ? Colors.white : Colors.grey,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              '과목 이름',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 5.h),
            TextField(
              onChanged: (value) {
                setState(() {
                  scheduleTitle = value; // 텍스트 필드 값 저장
                });
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'ex. 화학',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                filled: true,
                fillColor: const Color(0xFF333333),
              ),
            ),
            SizedBox(height: 10.h), // 텍스트와 텍스트 필드 사이 간격
            Text(
              '이전에 추가한 과목과 동일한 이름은 설정 불가합니다.',
              style: TextStyle(
                color: neonskyblue1, // 경고를 나타내기 위해 빨간색으로 설정
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
