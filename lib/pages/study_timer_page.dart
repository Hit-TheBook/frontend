import 'package:flutter/material.dart';
import 'package:project1/colors.dart';
import 'dart:async';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudyTimerPage extends StatefulWidget {
  final int timerId;
  final String subjectName;
  final String studyTimeLength;
  final int point;
  final Duration goalDuration;
  final int goalPoint;

  StudyTimerPage({
    required this.timerId,
    required this.subjectName,
    required this.studyTimeLength,
    required this.point,
    required this.goalDuration,
    required this.goalPoint,
  });

  @override
  _StudyTimerPageState createState() => _StudyTimerPageState();
}

class _StudyTimerPageState extends State<StudyTimerPage> with WidgetsBindingObserver {
  late Timer _timer;
  int _seconds = 0;
  bool _isRunning = false;
  late Duration _studyDuration;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    WidgetsBinding.instance.addObserver(this);

    List<String> timeParts = widget.studyTimeLength.split(":");
    if (timeParts.length == 3) {
      int hours = int.parse(timeParts[0]);
      int minutes = int.parse(timeParts[1]);
      int seconds = int.parse(timeParts[2]);
      _studyDuration = Duration(hours: hours, minutes: minutes, seconds: seconds);
    } else {
      _studyDuration = Duration();
    }
  }

  @override
  void dispose() {
    Wakelock.disable();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      if (_isRunning) _stopTimer();
    } else if (state == AppLifecycleState.resumed) {
      if (_isRunning) _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        _studyDuration += Duration(seconds: 1);
      });
    });
    setState(() {
      _isRunning = true;
    });
  }

  void _stopTimer() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  String get formattedTime {
    final int hours = _seconds ~/ 3600;
    final int minutes = (_seconds % 3600) ~/ 60;
    final int seconds = _seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedStudyTime {
    final int hours = _studyDuration.inHours;
    final int minutes = _studyDuration.inMinutes % 60;
    final int seconds = _studyDuration.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Padding(
                padding: EdgeInsets.only(top: 80.0.h),
                child: Text(
                  widget.subjectName,
                  style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 47.h),

              Container(
                width: 170.w,
                height: 30.h,
                  padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: white1,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '누적시간 $formattedStudyTime',
                  style: TextStyle(fontSize: 16.sp, color: black1,fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15.h),

              // 목표시간 텍스트 수정
              Container(
                width: 170.w,
                height: 30.h,
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: neonskyblue1,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '목표시간 ${widget.goalDuration.inHours.toString().padLeft(2, '0')}:${(widget.goalDuration.inMinutes % 60).toString().padLeft(2, '0')}:${(widget.goalDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 16.sp, color: black1, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15.h),

              Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                child: Text(
                  '목표시간 달성 시 획득 점수: ${widget.goalPoint}',
                  style: TextStyle(fontSize: 18.sp, color: neonskyblue1,fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15.h),

              Text(
                formattedTime,
                style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.bold, color: neonskyblue1),
              ),
              SizedBox(height: 47.h),

              Column(
                children: [
                  IconButton(
                    icon: Icon(_isRunning ? Icons.pause_circle_outline : Icons.play_circle_outline_outlined),
                    iconSize: 45.sp,
                    color: white1,
                    onPressed: () {
                      if (_isRunning) {
                        _stopTimer();
                      } else {
                        _startTimer();
                      }
                    },
                  ),
                  SizedBox(height: 47.h),
                  Container(
                    width: 98.w,
                    height: 33.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: neonskyblue1,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: TextButton(
                      onPressed: () {
                        _stopTimer();
                      },
                      child: Padding(

                        padding: EdgeInsets.symmetric(vertical: 2.0.h, ),

                        child: Text(
                          '타이머 종료',
                          style: TextStyle(fontSize: 16.sp, color: Colors.black,fontWeight:FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
