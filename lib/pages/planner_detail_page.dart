import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/pages/planner_page.dart';
import 'package:project1/utils/planner_api_helper.dart';
import 'package:project1/models/planner_model.dart'; // 모델 파일

class PlannerDetailPage extends StatefulWidget {

  final String title; // 제목을 받을 변수
  final String scheduleType; // 스케줄 타입을 받을 변수

  const PlannerDetailPage({
    super.key,
    required this.title,
    required this.scheduleType,
  });

  @override
  _PlannerDetailPageState createState() => _PlannerDetailPageState();
}

class _PlannerDetailPageState extends State<PlannerDetailPage> {
  DateTime? startAt; // 시작 시간 저장 (nullable)
  DateTime? endAt;   // 종료 시간 저장 (nullable)
  String? scheduleTitle;   // 과목 이름 저장
  String? content;   // 내용 저장
  DateTime? scheduleAt;    // 일정 시간 저장
  String scheduleType = "default"; // 스케줄 타입 (예시)

  // 모든 필드가 채워졌는지 확인
  bool get isFormValid => startAt != null && endAt != null && scheduleTitle != null && content != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 14.sp,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: isFormValid ? () async {
              // 완료 버튼 클릭 시 동작

              await _savePlan();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlannerPage()), // PlannerPage로 이동
              );
            } : null, // 버튼이 비활성화될 때는 null 설정
            child: Text(
              '완료',
              style: TextStyle(
                color: isFormValid ? Colors.white : Colors.grey, // 활성화 시 흰색, 비활성화 시 회색
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new), // 원하는 아이콘으로 변경
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기 버튼 동작
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 25.w, right: 25.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              buildTimeSection(context),
              SizedBox(height: 20.h),
              buildSubjectSection(context),
              SizedBox(height: 20.h),
              buildContentSection(context),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                height: 14.h,
                child: Text(
                  '플랜 추가 완료 후에는 수정이 불가합니다.',
                  style: TextStyle(
                    color: Color(0xFF69EDFF),
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _savePlan() async {
    // PlannerApiHelper의 인스턴스 생성
    PlannerApiHelper plannerApiHelper = PlannerApiHelper();


    // PlanerModel 객체 생성
    PlannerModel model = PlannerModel(
      scheduleTitle: scheduleTitle!,
      content: content!,
      scheduleAt: DateTime.now(), // 일정 시간 현재로 설정 (필요에 따라 수정)
      startAt: startAt!,
      endAt: endAt!,
    );
    String scheduleType = "EVENT";
    // API 호출
    final response = await plannerApiHelper.addPlanner(widget.scheduleType, model);

    if (response.statusCode == 200) {
      // 성공적으로 저장된 경우
      print("플랜이 성공적으로 추가되었습니다.");
    } else {
      // 오류 처리
      print("플랜 추가 실패: ${response.statusCode}");
    }
  }

  Widget buildTimeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: 22.h,
          child: Text(
            '시간',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ),
        Container(
          width: 200.w,
          padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.h),
          decoration: ShapeDecoration(
            color: Color(0xFF333333),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTimeSelector('시작 시각', context, true),
              SizedBox(height: 5.h),
              buildTimeSelector('종료 시각', context, false),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSubjectSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: 1.h,
        ),
        SizedBox(height: 1.h),
        buildTextField(
        widget.scheduleType == "EVENT" ? '주제' : '과목',
        widget.scheduleType == "EVENT" ? 'ex. 프로젝트' : 'ex. 한국사',
        8,

            context, (value) {
          setState(() {
            scheduleTitle = value; // 과목 이름 저장
          });
        }),
      ],
    );
  }

  Widget buildContentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: 1.h,
        ),

        buildTextField('내용', widget.scheduleType == "EVENT" ? 'ex. 회의 참석하기' : 'ex. 모의고사 1회 풀기',
            25, context, (value) {
          setState(() {
            content = value; // 내용 저장
          });
        }),
      ],
    );
  }

  Widget buildTimeSelector(String title, BuildContext context, bool isStartTime) {
    String? displayedTime = isStartTime ? startAt != null ? _formatTime(startAt!) : null : endAt != null ? _formatTime(endAt!) : null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                Text(
                  displayedTime ?? '', // 선택한 시간이 null이 아닐 때만 표시
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 15.sp,
          ),
          onPressed: () {
            showTimePickerModal(context, isStartTime);
          },
        ),
      ],
    );
  }

  void showTimePickerModal(BuildContext context, bool isStartTime) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250.0,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isStartTime ? '시작 시각 선택' : '종료 시각 선택',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    CupertinoButton(
                      child: Text(
                        '완료',
                        style: TextStyle(color: Colors.black),
                      ),
                        onPressed: () {
                          Navigator.of(context).pop(); // 현재 화면을 닫고

                        },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (DateTime newTime) {
                    setState(() {
                      if (isStartTime) {
                        startAt = newTime; // 시작 시간 저장
                      } else {
                        endAt = newTime; // 종료 시간 저장
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildTextField(String label, String hint, int maxLength, BuildContext context, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: 22.h,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          height: 43.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
          decoration: ShapeDecoration(
            color: Color(0xFF333333),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: TextField(
            maxLength: maxLength,
            onChanged: onChanged, // 텍스트 변경 시 호출
            buildCounter: (BuildContext context, {required int currentLength, required bool isFocused, required int? maxLength}) {
              return const SizedBox.shrink(); // 카운터 숨기기
            },
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Color(0xFF4B4B4B),
                fontSize: 12.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    String amPm = time.hour >= 12 ? 'pm' : 'am';
    return '$amPm ${(time.hour % 12 == 0) ? 12 : (time.hour % 12)}:${time.minute.toString().padLeft(2, '0')}';
  }
}
