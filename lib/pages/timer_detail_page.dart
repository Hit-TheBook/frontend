import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/colors.dart';
import 'package:project1/models/timer_model.dart';
import 'package:project1/utils/timer_api_helper.dart';

class TimerDetailPage extends StatefulWidget {
  final bool isEditMode; // 수정 모드 여부
  final String? initialSubjectName; // 초기 과목 이름
  final int? timerId; // 수정 시 필요한 타이머 ID

  const TimerDetailPage({
    Key? key,
    this.isEditMode = false, // 기본값은 추가 모드
    this.initialSubjectName,
    this.timerId,
  }) : super(key: key);

  @override
  _TimerDetailPageState createState() => _TimerDetailPageState();
}

class _TimerDetailPageState extends State<TimerDetailPage> {
  String? subjectName; // 과목 이름 저장
  TextEditingController _controller = TextEditingController(); // 텍스트 필드 컨트롤러

  @override
  void initState() {
    super.initState();
    // 수정 모드인 경우 초기 과목명을 설정
    subjectName = widget.initialSubjectName ?? '';
    _controller.text = subjectName ?? ''; // 텍스트 필드에 초기값 설정
  }

  // 폼 유효성 검사
  bool get isFormValid => subjectName != null && subjectName!.isNotEmpty;

  // 완료 버튼 클릭 시 동작
  void _submitForm() async {
    if (isFormValid) {
      // TimerApiHelper 초기화
      TimerApiHelper apiService = TimerApiHelper();

      try {
        if (widget.isEditMode) {
          // 수정 모드일 경우 modifySubject 호출
          TimerSubjectRequest request = TimerSubjectRequest(
            subjectName: subjectName!,
          );
          final response = await apiService.modifySubject(
            widget.timerId!,
            subjectName!,

          );

          if (response.statusCode == 200) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('과목 수정 완료')),
            // );
            Navigator.pop(context, true); // 수정 성공 후 이전 화면으로 이동
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('과목 수정 실패: ${response.body}')),
            );
          }
        } else {

          // 추가 모드일 경우 addSubject 호출 (Path Variable에 과목명 전달)
          final response = await apiService.addSubject(subjectName!); // 변경된 호출 방식

          if (response.statusCode == 200) {
            Navigator.pop(context, true); // 추가 성공 후 이전 화면으로 이동
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('과목 추가 실패: ${response.body}')),
            );
          }
        }
      } catch (e) {
        // 예외 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('API 호출 실패: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('과목 이름을 입력해주세요')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // 플래그에 따라 제목 변경
        title: Text(widget.isEditMode ? '과목 이름 수정' : '과목 추가'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: isFormValid ? _submitForm : null,
            child: Text(
              '완료',
              style: TextStyle(
                color: isFormValid ? Colors.white : Colors.grey,
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
              controller: _controller, // TextEditingController를 사용
              onChanged: (value) {
                setState(() {
                  subjectName = value; // 텍스트 필드 값 저장
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
            SizedBox(height: 10.h),
            Text(
              '이전에 추가한 과목과 동일한 이름은 설정 불가합니다.',
              style: TextStyle(
                color: neonskyblue1,
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
