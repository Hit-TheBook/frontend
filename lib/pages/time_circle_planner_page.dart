import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/colors.dart';
import 'package:project1/pages/planner_page.dart';
import 'package:project1/pages/timer.dart';
import 'package:project1/widgets/time_circle_planner_painter.dart';
import 'package:project1/utils/planner_api_helper.dart';
import 'dart:convert';
import '../models/planner_model.dart';
import '../widgets/custom_appbar.dart';
import 'home_screen.dart';

class TimeCirclePlannerPage extends StatefulWidget {
  const TimeCirclePlannerPage({super.key});

  @override
  _TimeCirclePlannerPageState createState() => _TimeCirclePlannerPageState();
}

class _TimeCirclePlannerPageState extends State<TimeCirclePlannerPage> {
  int colorIndex = 0;
  List<PlannerModel> schedules = [];

  // TimeCirclePlannerPainter에 정의된 colors 리스트를 여기에 동일하게 정의
  final List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

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
    ScreenUtil.init(context, designSize: Size(360, 640), minTextAdapt: true);

    return Scaffold(
      appBar: CustomAppBar(
        title: '원시간표',
        showBackButton: true,
        onBackPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PlannerPage()),
          ).then((_) {
            setState(() {});  // 돌아올 때 화면 새로고침
          });

        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w), // 화면 좌우 여백 추가
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              CustomPaint(
                size: Size(260.w, 260.w),
                painter: TimeCirclePlannerPainter(schedules),
              ),
              SizedBox(height: 20.h),
              schedules.isNotEmpty // 테이블 데이터가 있을 경우에만 테이블을 표시
                  ? Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.white,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: DataTable(
                    columnSpacing: 17.w,
                    columns: [
                      DataColumn(
                        label: Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '색상',
                              style: TextStyle(color: neonskyblue1, fontSize: 12.sp),
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: Container(
                            width: 60.w,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '주제',
                                style: TextStyle(color: neonskyblue1, fontSize: 12.sp),
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: Container(
                            width: 150.w,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '내용',
                                style: TextStyle(color: neonskyblue1, fontSize: 12.sp),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                      schedules.length,
                          (index) {
                        final schedule = schedules[index];
                        final color = colors[index % colors.length];

                        return DataRow(
                          cells: [
                            DataCell(
                              Center(
                                child: Container(
                                  width: 25.w,
                                  height: 25.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: color,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 60.w,
                                child: Center(
                                  child: Text(
                                    schedule.scheduleTitle,
                                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 150.w,
                                child: Center(
                                  child: Text(
                                    schedule.content,
                                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              )
                  : Container(
                height: 200.h, // 테이블이 없을 때의 빈 공간 설정
              ),
              SizedBox(height: 300.h), // 하단 여백 추가
            ],
          ),
        ),
      ),
    );
  }
}
