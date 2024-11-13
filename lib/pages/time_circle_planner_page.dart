import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchTimeTable();
  }

  Future<void> _fetchTimeTable() async {
    TimeTableRequestModel requestModel = TimeTableRequestModel(
      scheduleDate: DateTime.now(),
    );

    final plannerHelper = PlannerApiHelper();
    final response = await plannerHelper.findTimeTable(requestModel);

    if (response.statusCode == 200) {
      setState(() {
        final responseBody = jsonDecode(response.body);
        List<dynamic> schedulesJson = responseBody['schedules'];

        schedules = schedulesJson.map((scheduleJson) {
          TimeTableResponseModel timeTableResponse = TimeTableResponseModel.fromJson(scheduleJson);
          return PlannerModel(
            scheduleTitle: timeTableResponse.scheduleTitle,
            content: timeTableResponse.content,
            scheduleAt: DateTime.now(),
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

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true);

    return Scaffold(
      appBar: AppBar(title: const Text('원 시간표')),
      body: SingleChildScrollView( // 스크롤 추가
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomPaint(
                size: Size(260.w, 260.w),
                painter: TimeCirclePlannerPainter(schedules),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
