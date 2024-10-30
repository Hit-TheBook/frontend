import 'dart:convert';
//import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';
import 'package:project1/pages/study_page.dart';
import 'package:project1/widgets/feedback_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:project1/pages/planner_detail_page.dart';
import 'package:project1/widgets/customfloatingactionbutton.dart';
import 'package:project1/pages/time_circle_planner_page.dart';
import 'package:project1/utils/planner_api_helper.dart';
import '../main.dart';
import '../models/planner_model.dart';
import 'package:project1/colors.dart';

import 'main_page.dart';


class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  _PlannerPageState createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _controller = TextEditingController();
  bool isStudying = true; // 공부 버튼 활성화 상태
  final FocusNode _textFieldFocusNode = FocusNode(); // FocusNode 추가
  bool isScheduleButtonPressed = false; // 일정 버튼 상태 변수
  List<dynamic> plannerData = []; // 플래너 데이터를 저장할 리스트


  String formatDateTimeForJava(DateTime dateTime) {
    DateTime utcDateTime = dateTime.toUtc(); // UTC로 변환
    final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"); // 포맷 설정
    return formatter.format(utcDateTime); // UTC 시간으로 포맷팅
  }

  Future<void> _loadReview() async {
    DateTime currentDateTime = DateTime.now();
    final plannerHelper = PlannerApiHelper();
    final response = await plannerHelper.findReview(formatDateTimeForJava(currentDateTime));

    if (response.statusCode == 200) {
      // 응답에서 리뷰 내용 추출 (예: response.body에서 내용 추출)
      // 여기서 response.body를 JSON으로 변환 후 내용을 _controller.text에 설정
      String reviewContent = jsonDecode(response.body)['content']; // 적절한 JSON 키 사용
      _controller.text = reviewContent;
    } else {
      // 에러 처리
      //ScaffoldMessenger.of(context).showSnackBar(
      //const SnackBar(content: Text('리뷰를 불러오는 데 실패했습니다.')),
      //);
    }
  }

  Future<void> _loadPlanner() async {
    String scheduleType = isScheduleButtonPressed ? 'EVENT' : 'SUBJECT';

    // ScheduleRequestModel 인스턴스 생성
    ScheduleRequestModel requestModel = ScheduleRequestModel(
      scheduleType: scheduleType,
      scheduleDate: _selectedDate,
    );

    // 모델을 사용하여 데이터를 요청
    final plannerHelper = PlannerApiHelper();
    final response = await plannerHelper.findPlanner(requestModel);

    if (response.statusCode == 200) {
      setState(() {
        final responseBody = jsonDecode(response.body);
        plannerData = responseBody['schedules'];  // 서버에서 받아온 데이터를 상태에 저장
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('플래너 데이터를 불러오는 데 실패했습니다.')),
      );
    }
  }



  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          color: Colors.grey[300],
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDate,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                _selectedDate = newDate;
              });
              // 날짜가 변경될 때마다 플래너 데이터를 로드합니다.
              _loadPlanner();
            },
          ),
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      // 날짜가 변경될 때마다 플래너 데이터를 로드합니다.
      _loadPlanner();
    }
  }

  TableRow _buildTimetableRow(String startTime, String endTime, String subject, String content,String feedbackType,Map<String, dynamic> schedule, DateTime startAt,DateTime endAt ) {
    return TableRow(
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                startTime,
                style: const TextStyle(color: Colors.white, fontSize: 9),
              ),
              const Text(
                '~',
                style: TextStyle(color: Colors.white, fontSize: 9),
              ),
              Text(
                endTime,
                style: const TextStyle(color: Colors.white, fontSize: 9),
              ),
            ],
          ),
        ),
        Container(
          height: 60,
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            subject,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        Container(
          height: 60,
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            content,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        InkWell( // 여기서 InkWell을 사용
          onTap: () {
            String scheduleType = isStudying ? 'SUBJECT' : 'EVENT';
            // plannerData에서 가져온 값으로 다이얼로그 호출
            _showFeedbackTypeDialog(
              plannerScheduleId: schedule['plannerScheduleId'], // 스케줄 ID
              scheduleTitle: schedule['scheduleTitle'],
              content: schedule['content'],
              feedbackType: schedule['feedbackType'],
              startAt: startAt,
              endAt: endAt,
              scheduleType: scheduleType, // scheduleType을 전달

            );
          },
          child : Container(
            height: 60,
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: _getFeedbackIcon(feedbackType), // 아이콘을 가져오는 함수 호출
          ),
        ),
      ],
    );
  }
  void _showFeedbackTypeDialog({
    required int plannerScheduleId,
    required String scheduleTitle,
    required String content,
    required String feedbackType,
    required DateTime startAt,
    required DateTime endAt,
    required String scheduleType,
  }) async { // async 추가
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FeedbackTypeDialog(
          onSelected: (selectedFeedbackType) {
            // 피드백 타입을 저장하기 위해 API 호출
            //_updateFeedbackType(plannerScheduleId, selectedFeedbackType);
          },
          scheduleTitle: scheduleTitle,
          content: content,
          feedbackType: feedbackType,
          startAt: startAt,
          endAt: endAt,
          plannerScheduleId: plannerScheduleId,
          scheduleType: scheduleType,
        );
      },
    );

    // 다이얼로그가 닫힌 후 플래너 데이터 새로 고침
    _loadPlanner();
  }






  Widget _getFeedbackIcon(String feedbackType) {
    switch (feedbackType) {
      case "DONE":
        return const Icon(
          Icons.circle_outlined, // Ellipse 13에 해당하는 아이콘 (동그라미)
          color: neonskyblue1,
        );
      case "PARTIAL":
        return const Icon(
          Icons.change_history, // Polygon 1에 해당하는 아이콘 (삼각형)
          color: neonskyblue1,
        );
      case "FAILED":
        return const Icon(
          Icons.close, // Arrow 62에 해당하는 아이콘 (화살표)
          color: neonskyblue1,
        );
      case "POSTPONED":
        return const Icon(
          Icons.arrow_forward, // X 아이콘
          color: neonskyblue1,
        );
      default:
        return const Icon(
          Icons.error, // 기본 아이콘 (오류 아이콘)
          color: Colors.red,
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadReview(); // 페이지 초기화 시 리뷰 로드
    _loadPlanner(); // 페이지 초기화 시 플래너 데이터 로드
    _textFieldFocusNode.addListener(_onFocusChange); // FocusNode 리스너 추가
  }


  // FocusNode의 상태 변화 감지
  void _onFocusChange() {
    if (!_textFieldFocusNode.hasFocus) {
      // 포커스가 해제되면 modifyReview 호출
      modifyReview();
    }
  }

  // modifyReview 메소드 정의
  Future<void> modifyReview() async {
    DateTime currentDateTime = DateTime.now();
    // ReviewModel 인스턴스 생성
    ReviewModel(
      reviewAt: currentDateTime,
      content: _controller.text, // 텍스트 필드의 내용 설정
    );

    // API 호출 (예: modifyReview 메서드 호출)
    final plannerHelper = PlannerApiHelper();
    final response = await plannerHelper.modifyReview(formatDateTimeForJava(currentDateTime), _controller.text);

    // 응답 처리
    if (response.statusCode == 200) {

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('리뷰 수정에 실패했습니다.')),
      );
    }
  }

  @override
  void dispose() {
    _textFieldFocusNode.removeListener(_onFocusChange); // 리스너 제거
    _textFieldFocusNode.dispose(); // FocusNode 정리
    _controller.dispose(); // 텍스트 필드 컨트롤러 정리
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = '${_selectedDate.year}년 ${_selectedDate.month}월 ${_selectedDate.day}일';
    return GestureDetector( // 수정 후
      onTap: () {
        if (_textFieldFocusNode.hasFocus) {
          FocusScope.of(context).requestFocus(FocusNode());
        }
      },
        child: WillPopScope(
        onWillPop: () async {
      // StudyPage로 이동
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const StudyPage()),
            (route) => false, // 모든 이전 페이지를 제거하고 StudyPage로 이동
      );
      return false;
        },


      child: Scaffold (
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('플래너'),
          centerTitle: true,
          leading: IconButton( // 뒤로 가기 버튼 추가
            icon: Icon(Icons.arrow_back), // 뒤로 가기 버튼에 사용할 아이콘
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StudyPage()), // 원하는 페이지로 이동
              );
            },
          ),
        ),

        body: SingleChildScrollView(
          child:Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Container(
                      width: 100,
                      height: 24,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 5.0, right: 0.0),
                      child: Text(
                        formattedDate,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, left: 0.0), // 원하는 만큼 위쪽 여백 조정
                    child: GestureDetector(
                      onTap: () => _selectDate(context), // 아이콘 클릭 시 날짜 선택 모달
                      child: Icon(
                        Icons.expand_more,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {


                      setState(() {
                        isStudying = true; // 공부 버튼 활성화
                        isScheduleButtonPressed = false; // 공부 버튼 눌렀을 때 상태 업데이트
                      });
                      _loadPlanner();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isStudying ? Color(0xFF69EDFF) : Color(0xFF9D9D9D), // 버튼 색상 설정
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      minimumSize: Size(50, 22),
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    ),
                    child: const Text(
                      '공부',
                      style: TextStyle(color: Color(0xFF333333), fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {

                      setState(() {
                        isStudying = false; // 일정 버튼 활성화
                        isScheduleButtonPressed = true; // 일정 버튼 상태 업데이트
                      });
                      _loadPlanner();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isStudying ? Color(0xFF9D9D9D) : Color(0xFF69EDFF), // 버튼 색상 설정
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      minimumSize: Size(50, 22),
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    ),
                    child: const Text(
                      '일정',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TimeCirclePlannerPage()), // TimeCirclePlanner로 이동
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF69EDFF), // 버튼 색상 설정
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      minimumSize: Size(60, 22),
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    ),
                    child: const Text(
                      '원시간표',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Container(
                width: 380,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xff333333),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              '오늘의',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            Text(
                              '총평',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      color: Colors.white,
                      thickness: 1,
                      width: 10,
                    ),
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          focusNode: _textFieldFocusNode,
                          controller: _controller,
                          maxLength: 200,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: '클릭 후 오늘의 총 평을 입력해 보세요.',
                            hintStyle: const TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          cursorColor: Colors.white,
                          onTap: () async {
                            DateTime currentDateTime = DateTime.now();

                            // ReviewModel 인스턴스 생성

                            ReviewModel review = ReviewModel(
                              reviewAt: currentDateTime,

                            );

                            // API 호출 (예: addReview 메서드 호출)
                            final plannerHelper = PlannerApiHelper();
                            final response = await plannerHelper.addReview(formatDateTimeForJava(currentDateTime), review);



                            // 응답 처리
                            if (response.statusCode == 200) {

                            } else {



                            }
                          },

                        ),

                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 380,
                decoration: BoxDecoration(
                  color: const Color(0xff333333),
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Table(
                  border: TableBorder(
                    verticalInside: BorderSide(color: Colors.black54, width: 2),
                    horizontalInside: BorderSide(color: Colors.black54, width: 2),
                  ),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: {
                    0: FixedColumnWidth(40),
                    1: FixedColumnWidth(40),
                    2: FixedColumnWidth(175),
                    3: FixedColumnWidth(35),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Color(0xFF69EDFF), borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                            '시간',
                            style: TextStyle(color: Color(0xFF333333), fontSize: 12),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                            isScheduleButtonPressed ? '주제' : '과목', // 조건에 따라 텍스트 변경
                            style: TextStyle(color: Color(0xFF333333), fontSize: 12),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                            '내용',
                            style: TextStyle(color: Color(0xFF333333), fontSize: 12),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                            '달성',
                            style: TextStyle(color: Color(0xFF333333), fontSize: 12),
                          ),
                        ),
                      ],
                    ),

                    // plannerData가 null일 때 기본 힌트를 표시
                    ...plannerData.map((schedule) {
                      DateTime startAt = schedule['startAt'] != null ? DateTime.parse(schedule['startAt']) : DateTime.now();
                      DateTime endAt = schedule['endAt'] != null ? DateTime.parse(schedule['endAt']) : DateTime.now();
                      String formattedStartTime = DateFormat('a h:mm').format(startAt);
                      String formattedEndTime = DateFormat('a h:mm').format(endAt);

                      return _buildTimetableRow(
                        formattedStartTime,
                        formattedEndTime,
                        schedule['scheduleTitle'] ?? '제목 없음',
                        schedule['content'] ?? '내용 없음',
                        schedule['feedbackType'] ?? 'FAIL',
                        schedule, // 전체 schedule 데이터를 넘깁니다.
                        startAt, // startAt 변수를 전달
                        endAt,   // endAt 변수를 전달
                      );
                    }).toList(),



                  ],

                ),
              ),
            ]
        ),
        ),
        floatingActionButton: CustomFloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlannerDetailPage(
                  title: isScheduleButtonPressed ?  '일정 플랜 추가' : '공부 플랜 추가', // 상단 바 제목 변경
                  scheduleType: isScheduleButtonPressed ?  'EVENT' :'SUBJECT', // 스케줄 타입 변경
                ),
              ),
            );
          },
        ),
      ),
    ),
    );


  }
}