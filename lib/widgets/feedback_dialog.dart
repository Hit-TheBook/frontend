import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedbackTypeDialog extends StatelessWidget {
  final Function(String) onSelected;

  const FeedbackTypeDialog({Key? key, required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h, // 높이 설정
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.r), // 반지름 설정
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 상단: 취소 버튼과 달성 텍스트
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w), // 패딩 설정
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // 취소 클릭 시 다이얼로그 닫기
                  },
                  child: Text(
                    '취소',
                    style: TextStyle(color: Colors.red, fontSize: 16.sp), // 글꼴 크기 설정
                  ),
                ),
                Text(
                  '달성', // "달성" 텍스트를 가운데 위치
                  style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                // 완료 버튼 추가
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // 다이얼로그를 닫습니다.
                  },
                  child: Text(
                    '완료',
                    style: TextStyle(color: Colors.blue, fontSize: 16.sp), // 글꼴 크기 설정
                  ),
                ),
              ],
            ),
          ),
          SizedBox(

            height: 13.h, // 10픽셀의 높이
          ),

          // 중간: 사용자 요청 스타일의 테이블
          Container(
            width: 324.w, // 너비 설정
            height: 51.h, // 높이 설정
            decoration: BoxDecoration(
              color: Color(0xFF69EDFF),
              borderRadius: BorderRadius.circular(10.r), // 반지름 설정
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 시간
                Container(
                  width: 55.w, // 너비 설정
                  height: 51.h, // 높이 설정
                  padding: EdgeInsets.symmetric(horizontal: 5.w), // 수평 패딩 설정
                  alignment: Alignment.center, // 세로 및 가로 중앙 정렬
                  child: Text(
                    'am 8:13\n~\npm 10:00',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 9.sp, // 글꼴 크기 설정
                      fontWeight: FontWeight.w400,
                      height: 0.8, // 줄 높이 설정
                    ),
                  ),
                ),

                // 구분선
                Container(
                  width: 1.w, // 세로선의 너비
                  height: 51.h, // 충분한 높이 설정
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(width: 0.5, color: Colors.black),
                    ),
                  ),
                ),

                // 과목
                Container(
                  width: 55.w, // 너비 설정
                  height: 51.h, // 높이 설정
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 7.50.h), // 패딩 설정
                  alignment: Alignment.center, // 수직 및 수평 중앙 정렬
                  child: Text(
                    '화학I',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp, // 글꼴 크기 설정
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ),

                // 구분선
                Container(
                  width: 1.w, // 세로선의 너비
                  height: 51.h, // 충분한 높이 설정
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(width: 0.5, color: Colors.black),
                    ),
                  ),
                ),

                // 내용
                Expanded(
                  child: Container(
                    height: 51.h,
                    width: 174.w,
                    padding: EdgeInsets.symmetric(horizontal: 5.w), // 수평 패딩 설정
                    alignment: Alignment.center, // 세로 및 가로 중앙 정렬
                    child: Text(
                      '수능특강 p30~31 풀기(맞힌 문제 제외하고 풀기)',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp, // 글꼴 크기 설정
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center, // 텍스트 중앙 정렬
                    ),
                  ),
                ),

                // 구분선
                Container(
                  width: 1.w, // 세로선의 너비
                  height: 51.h, // 충분한 높이 설정
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(width: 0.5, color: Colors.black),
                    ),
                  ),
                ),

                // 피드백 아이콘
                Container(
                  width: 35.w, // 너비 설정
                  height: 51.h, // 높이 설정
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 피드백 아이콘 추가
                      Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: 10.h, // 아이콘 크기 설정
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 하단: 아이콘 버튼들
          Container(
            height: 47.h, // 원하는 높이로 설정
            child: Padding(
              padding: EdgeInsets.only(top: 13.h), // 위쪽에만 패딩 설정

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 완료 버튼
                  _buildIconButton(Icons.circle, Colors.green, '완료', 'DONE', context, 80.w), // 너비 설정
                  // 일부 버튼
                  _buildIconButton(Icons.change_history, Colors.orange, '일부', 'PARTIAL', context, 80.w), // 너비 설정
                  // 연기 버튼
                  _buildIconButton(Icons.close, Colors.red, '실패', 'FAILED', context, 80.w), // 너비 설정
                  _buildIconButton(Icons.arrow_forward, Colors.yellow, '연기', 'POSTPONED', context, 80.w), // 너비 설정
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, String label, String value, BuildContext context, double width) {
    return Container(
      width: width, // 버튼 너비 지정
      height: 47.h,
      padding: EdgeInsets.only(top: 4.h),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: GestureDetector(
        onTap: () {
          onSelected(value);
          Navigator.pop(context);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 10.h),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }
}
