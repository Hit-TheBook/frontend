import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/colors.dart'; // 화면 크기 조정

class SubjectDropdown extends StatelessWidget {
  final String selectedSubject; // 선택된 과목
  final List<String> subjectsList; // 과목 목록
  final ValueChanged<String?> onSubjectChanged; // 과목 변경 시 콜백

  const SubjectDropdown({
    Key? key,
    required this.selectedSubject,
    required this.subjectsList, // 과목 목록을 추가
    required this.onSubjectChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight, // 우측 정렬
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        height: 25.h, // 고정된 높이 설정
        decoration: BoxDecoration(
          color: neonskyblue1,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.black, width: 1.w),
        ),
        child: DropdownButton<String>(
          value: selectedSubject,
          onChanged: onSubjectChanged, // 선택된 과목이 변경되면 호출되는 콜백
          items: subjectsList.map((subject) { // 과목 목록을 items로 전달
            return DropdownMenuItem<String>(
              value: subject,
              child: Text(
                subject,
                style: TextStyle(
                  fontSize: 14.sp, // 화면 크기에 맞게 폰트 크기 설정
                ),
              ),
            );
          }).toList(),
          style: TextStyle(color: Colors.black, fontSize: 14.sp), // 텍스트 스타일
          dropdownColor: neonskyblue1, // 드롭다운 배경색
          icon: Padding(
            padding: EdgeInsets.only(left: 0.5.w), // 아이콘과 텍스트 간격을 좁히기 위한 패딩
            child: Icon(Icons.arrow_drop_down, color: Colors.black, size: 12.sp), // 화살표 아이콘
          ), // 화살표 아이콘
        ),
      ),
    );
  }
}
