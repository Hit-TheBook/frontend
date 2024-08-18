import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project1/theme.dart'; // 테마 사용
import 'count_up_timer_page.dart';
import 'custom_appbar.dart'; // 기존 CustomAppBar

class DdaydetailPage extends StatefulWidget {
  const DdaydetailPage({super.key});

  @override
  DdaydetailPageState createState() => DdaydetailPageState();
}

class DdaydetailPageState extends State<DdaydetailPage> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _startDate() {
    // 시작일 버튼 클릭 시 동작 추가
    if (kDebugMode) {
      print('Start Date button clicked');
    }
  }

  void _endDate() {
    // 종료일 버튼 클릭 시 동작 추가
    if (kDebugMode) {
      print('End Date button clicked');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('디데이 추가'),
        centerTitle: true, // 타이틀을 중앙에 위치시킴
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // 완료 버튼 클릭 시 동작 추가
              // 예: 데이터를 저장하거나 다른 페이지로 이동
            },
            child: const Text(
              '완료',
              style: TextStyle(
                color: Colors.white, // 버튼 텍스트 색상
                fontWeight: FontWeight.bold, // 버튼 텍스트 두께
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 양쪽 끝으로 확장
          children: [
            const Text(
              '디데이 이름',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '디데이 이름을 입력하세요',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '날짜',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                ElevatedButton(
                  onPressed: _startDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // 둥근 직사각형
                    ),
                    minimumSize: const Size(double.infinity, 48), // 버튼을 양옆으로 넓게
                  ),
                  child: const Text(
                    '시작일',
                    style: TextStyle(color: Colors.white), // 버튼 내부 텍스트 색상

                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _endDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // 둥근 직사각형
                    ),
                    minimumSize: const Size(double.infinity, 48), // 버튼을 양옆으로 넓게
                  ),
                  child: const Text(
                    '종료일',
                    style: TextStyle(color: Colors.white), // 버튼 내부 텍스트 색상
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
