import 'package:flutter/material.dart';
import 'package:project1/colors.dart';
import 'package:project1/pages/timer.dart';
import 'dart:async';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:project1/widgets/customdialog.dart';
import 'package:project1/widgets/timerdialog.dart';
import 'package:project1/utils/timer_api_helper.dart';

import '../models/timer_model.dart';
class StudyTimerPage extends StatefulWidget {
  final int timerId;
  final String subjectName;
  final Duration totalStudyTime;
  final int targetscore;
  final Duration targetTime;


  StudyTimerPage({
    required this.timerId,
    required this.subjectName,
    required this.totalStudyTime,
   required this.targetscore,
    required this.targetTime,

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

    _studyDuration = widget.totalStudyTime;
  }
  void _showCustomDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TimerDialog(
          title: '획득한 점수 안내',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 왼쪽 정렬
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '목표시간 달성 및 추가 ${extraTime.inMinutes}분이 경과해',
                style: TextStyle(fontSize: 12.sp, color: Colors.white),
                textAlign: TextAlign.left, // 왼쪽 정렬
              ),

              Text(
                '$score점을 획득했습니다.',
                style: TextStyle(fontSize: 12.sp, color: Colors.white),
                textAlign: TextAlign.left, // 왼쪽 정렬
              ),
            ],
          ),
          onConfirm: () {
            Navigator.of(context).pop(); // 다이얼로그 닫기
            // 타이머 페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TimerPage(), // 타이머 페이지로 이동
              ),
            );
          },
          width: 250.w, // 다이얼로그 너비 (ScreenUtil 사용)
          height: 30.h, // 다이얼로그 높이 (ScreenUtil 사용)
        );
      },
    );
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

  String get studyTimeLength {
    final int hours = (_seconds ~/ 3600) % 24;  // 24시간을 넘지 않도록
    final int minutes = (_seconds % 3600) ~/ 60;
    final int seconds = _seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedTargetTime {
    final int hours = widget.targetTime.inHours;
    final int minutes = widget.targetTime.inMinutes % 60;
    final int seconds = widget.targetTime.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedStudyTime {
    final int hours = _studyDuration.inHours;
    final int minutes = _studyDuration.inMinutes % 60;
    final int seconds = _studyDuration.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Duration get extraTime {
    return _studyDuration > widget.targetTime
        ? _studyDuration - widget.targetTime
        : Duration.zero;
  }
  int get extraTimeInSeconds {
    int studyTimeInSeconds = _studyDuration.inSeconds;
    int targetTimeInSeconds = widget.targetTime.inSeconds;
    return studyTimeInSeconds - targetTimeInSeconds; // 음수, 0, 양수 모두 가능
  }


  int get score {
    if (_studyDuration <= widget.targetTime) {
      // 목표 시간보다 같거나 적을 때, 1분당 1점
      return _studyDuration.inMinutes;
    } else {
      // 목표 시간을 초과했을 때, 10분당 20점
      int extraMinutes = extraTime.inMinutes;
      int scoreForExtraTime = (extraMinutes ~/ 10) * 20; // 10분당 20점
      int remainingMinutes = extraMinutes % 10; // 10분 이내 나머지 시간은 1분당 1점
      return widget.targetTime.inMinutes + scoreForExtraTime + remainingMinutes;
    }
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
                  '목표시간 ${widget.targetTime.inHours.toString().padLeft(2, '0')}:${(widget.targetTime.inMinutes % 60).toString().padLeft(2, '0')}:${(widget.targetTime.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 16.sp, color: black1, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15.h),

              Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                child: Text(
                  '목표시간 달성 시 획득 점수: ${widget.targetscore}',
                  style: TextStyle(fontSize: 18.sp, color: neonskyblue1,fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15.h),

              Text(
                studyTimeLength,
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
                      onPressed: () async {
                        // 타이머 종료
                        if (_isRunning) {
                          _stopTimer();
                        }

                        // TimerEndRequest 생성
                        TimerEndRequest request = TimerEndRequest(
                          studyTimeLength: studyTimeLength, // 타이머 종료된 시간
                          targetTime: formattedTargetTime,  // 목표시간
                          score: score, // 점수
                        );

                        // TimerApiHelper 호출하여 타이머 종료 API 요청
                        TimerApiHelper apiHelper = TimerApiHelper();
                        try {
                          final response = await apiHelper.endTimer(widget.timerId, request);
                          if (response.statusCode == 200) {
                            // API 호출 성공 시 extraTimeInSeconds 값에 따라 다이얼로그를 보여줄지 결정
                            if (extraTimeInSeconds >= 0) {
                              _showCustomDialog(); // 목표시간을 초과했을 때 다이얼로그 띄우기
                            } else {
                              // 목표시간을 초과하지 않았을 때 TimerPage로 이동
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TimerPage(), // 타이머 페이지로 이동
                                ),
                              );
                            }
                          } else {
                            // 실패 시 오류 처리
                            print("타이머 종료 실패: ${response.body}");
                          }
                        } catch (e) {
                          print("API 호출 중 오류 발생: $e");
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0.h),
                        child: Text(
                          '타이머 종료',
                          style: TextStyle(fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.bold),
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
