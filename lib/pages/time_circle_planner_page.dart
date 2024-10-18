import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import flutter_screenutil
import 'package:project1/widgets/time_circle_planner_painter.dart';
import 'package:project1/utils/planner_api_helper.dart';
import 'dart:convert';
import '../models/planner_model.dart';

class TimeCirclePlannerPage extends StatefulWidget {
  const TimeCirclePlannerPage({super.key});

  @override
  _TimeCirclePlannerPageState createState() => _TimeCirclePlannerPageState();
}

class _TimeCirclePlannerPageState extends State<TimeCirclePlannerPage> {
  int colorIndex = 0;
  List<PlannerModel> schedules = [];

  // 선택된 시작 시간과 종료 시간을 저장
  /*DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();*/
  @override
  void initState() {
    super.initState();
    _fetchTimeTable();
  }


  Future<void> _fetchTimeTable() async {
    // ScheduleRequestModel 인스턴스 생성
    TimeTableRequestModel requestModel = TimeTableRequestModel(
      scheduleDate: DateTime.now(),
    );

    // 모델을 사용하여 데이터를 요청
    final plannerHelper = PlannerApiHelper();
    final response = await plannerHelper.findTimeTable(requestModel);

    if (response.statusCode == 200) {
      setState(() {
        final responseBody = jsonDecode(response.body);
        List<dynamic> schedulesJson = responseBody['schedules'];

        // TimeTableResponseModel 리스트를 PlannerModel 리스트로 변환
        schedules = schedulesJson.map((scheduleJson) {
          TimeTableResponseModel timeTableResponse = TimeTableResponseModel.fromJson(scheduleJson);
          return PlannerModel(
            scheduleTitle: timeTableResponse.scheduleTitle,
            content: timeTableResponse.content,
            scheduleAt: DateTime.now(), // 임시로 현재 시간 할당 (필요 시 수정)
            startAt: timeTableResponse.startAt,
            endAt: timeTableResponse.endAt,
          );
        }).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('플래너 데이터를 불러오는 데 실패했습니다.')),
      );
    }
  }


  /*void _showTimePicker(BuildContext context, bool isStart) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: isStart ? startTime : endTime,
            onDateTimeChanged: (DateTime newTime) {
              setState(() {
                if (isStart) {
                  startTime = newTime;
                } else {
                  endTime = newTime;
                }
              });
            },
          ),
        );
      },
    );
  }

  void _addTimeSegment() {
    setState(() {
      colorIndex++; // 다음 색상으로 이동
    });
  }*/

  @override
  Widget build(BuildContext context) {
    // ScreenUtil 초기화
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true);

    return Scaffold(
      appBar: AppBar(title: const Text('원 시간표')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              size: Size(260.w, 260.w), // 화면 크기 조정
              painter: TimeCirclePlannerPainter(schedules), // DateTime 전달
            ),
            SizedBox(height: 20.h), // 높이 조정
            /*Text(
              '시작 시간: ${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 18.sp), // 글꼴 크기 조정
            ),
            Text(
              '종료 시간: ${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 18.sp), // 글꼴 크기 조정
            ),*/
            SizedBox(height: 20.h), // 높이 조정
           /* ElevatedButton(
              onPressed: () => _showTimePicker(context, true), // 시작 시간 선택
              child: const Text('시작 시간 선택'),
            ),
            ElevatedButton(
              onPressed: () => _showTimePicker(context, false), // 종료 시간 선택
              child: const Text('종료 시간 선택'),
            ),
            ElevatedButton(
              onPressed: _addTimeSegment,
              child: const Text('시간 추가'),
            ),*/
          ],
        ),
      ),
    );
  }
}
