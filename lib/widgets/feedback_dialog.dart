import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:project1/models/planner_model.dart';
import 'package:project1/utils/planner_api_helper.dart';

class FeedbackTypeDialog extends StatefulWidget {
  final Function(String) onSelected;
  final String scheduleTitle;
  final String content;
  final String feedbackType;
  final DateTime startAt;
  final DateTime endAt;
  final int plannerScheduleId;
  final String scheduleType;

  const FeedbackTypeDialog({
    Key? key,
    required this.onSelected,
    required this.scheduleTitle,
    required this.content,
    required this.feedbackType,
    required this.startAt,
    required this.endAt,
    required this.plannerScheduleId,
    required this.scheduleType,

  }) : super(key: key);

  @override
  _FeedbackTypeDialogState createState() => _FeedbackTypeDialogState();
}

class _FeedbackTypeDialogState extends State<FeedbackTypeDialog> {
  late String selectedFeedbackType;

  @override
  void initState() {
    super.initState();
    selectedFeedbackType = widget.feedbackType; // 초기 피드백 타입 설정
  }

  Icon _buildFeedbackIcon(String feedbackType) {
    switch (feedbackType) {
      case 'DONE':
        return Icon(Icons.circle_outlined, color: Colors.black, size: 20.h);
      case 'PARTIAL':
        return Icon(Icons.change_history, color: Colors.black, size: 20.h);
      case 'FAILED':
        return Icon(Icons.close, color: Colors.black, size: 20.h);
      case 'POSTPONED':
        return Icon(Icons.arrow_forward, color: Colors.black, size: 20.h);
      default:
        return Icon(Icons.help, color: Colors.black, size: 20.h);
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedStartTime = DateFormat('a h:mm').format(widget.startAt);
    String formattedEndTime = DateFormat('a h:mm').format(widget.endAt);

    return Container(
      height: 235.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 상단: 취소 버튼과 달성 텍스트
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // 취소 클릭 시 다이얼로그 닫기
                  },
                  child: Text(
                    '취소',
                    style: TextStyle(color: Colors.red, fontSize: 16.sp),
                  ),
                ),
                Text(
                  '달성',
                  style: TextStyle(color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () async {
                    try {
                      final feedbackRequest = FeedbackRequest(
                        result: selectedFeedbackType,
                        plannerScheduleId: widget.plannerScheduleId,
                        scheduleType: widget.scheduleType,
                      );

                      final plannerHelper = PlannerApiHelper();
                      final response = await plannerHelper.updateFeedbackType(
                        widget.plannerScheduleId,
                        widget.scheduleType,
                        selectedFeedbackType
                      );

                      if (response.statusCode == 200) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('피드백 업데이트에 실패했습니다.')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('오류가 발생했습니다: $e')),
                      );
                    }
                  },
                  child: Text(
                    '완료',
                    style: TextStyle(color: Colors.blue, fontSize: 16.sp),
                  ),
                ),

              ],
            ),
          ),
          SizedBox(height: 13.h),

          // 중간: 사용자 요청 스타일의 테이블
          Container(
            width: 324.w,
            height: 51.h,
            decoration: BoxDecoration(
              color: Color(0xFF69EDFF),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 시간
                Container(
                  width: 55.w,
                  height: 51.h,
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  alignment: Alignment.center,
                  child: Text(
                    '$formattedStartTime\n~\n$formattedEndTime',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w400,
                        height: 0.8),
                  ),
                ),
                _buildDivider(),
                // 과목
                Container(
                  width: 55.w,
                  height: 51.h,
                  padding: EdgeInsets.symmetric(
                      horizontal: 5.w, vertical: 7.50.h),
                  alignment: Alignment.center,
                  child: Text(
                    widget.scheduleTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5),
                  ),
                ),
                _buildDivider(),
                // 내용
                Expanded(
                  child: Container(
                    height: 51.h,
                    width: 174.w,
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    alignment: Alignment.center,
                    child: Text(
                      widget.content,
                      style: TextStyle(color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                _buildDivider(),
                // 피드백 아이콘
                Container(
                  width: 35.w,
                  height: 51.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildFeedbackIcon(selectedFeedbackType),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 하단: 아이콘 버튼들
          Container(
            height: 60.h,
            child: Padding(
              padding: EdgeInsets.only(top: 13.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconButton(Icons.circle_outlined, '완료', 'DONE'),
                  // 완료 아이콘
                  _buildIconButton(Icons.change_history, '일부', 'PARTIAL'),
                  // 일부 아이콘
                  _buildIconButton(Icons.close, '안함', 'FAILED'),
                  // 취소 아이콘
                  _buildIconButton(Icons.arrow_forward, '다음에', 'POSTPONED'),
                  // 다음에 아이콘
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1.w,
      height: 51.h,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(width: 0.5, color: Colors.black)),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, String value) {
    final isActive = (value == selectedFeedbackType);
    final buttonColor = isActive ? Color(0xFF69EDFF) : Colors.black; // 활성화된 색상
    final textColor = isActive ? Colors.black : Colors.white; // 활성화될 때 글씨 색상

    return Container(
      width: 80.w,
      height: 43.h,
      padding: EdgeInsets.only(top: 4.h),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFeedbackType = value; // 클릭한 버튼의 피드백 타입으로 설정
          });
          widget.onSelected(value); // 선택된 피드백 타입을 부모에게 전달
          // Navigator.pop(context); // 다이얼로그가 꺼지지 않도록 주석 처리
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20.h), // 아이콘 색상 적용
            const SizedBox(height:5 ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor, fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }
}