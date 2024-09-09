// lib/timer.dart
import 'package:flutter/material.dart';
import 'package:project1/widgets/bottom_nav_bar.dart'; // BottomNavBar import
import 'package:project1/pages/study_page.dart'; // Import pages for navigation
import 'package:project1/pages/test_page.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart'; //타이머

import '../colors.dart';
import '../widgets/custom_appbar.dart';
import 'main_page.dart'; // Import pages for navigation

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHours= true;







  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: '타이머 ', // 사용할 타이틀을 전달
      ),
      body: Center(
        child: Column(

        )
      ),

    );
  }
}
