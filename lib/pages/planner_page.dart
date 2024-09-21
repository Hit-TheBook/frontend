import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../colors.dart';

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  _PlannerPageState createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _controller = TextEditingController();

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          color: Colors.grey[300], // 배경색을 회색으로 설정
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDate,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                _selectedDate = newDate;
              });
            },
          ),
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = '${_selectedDate.year}년 ${_selectedDate.month}월 ${_selectedDate.day}일';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('플래너'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_drop_down,
                    size: 24,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // 버튼 추가
          Row(
            mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
            children: [
              const SizedBox(width: 16), // 버튼을 오른쪽으로 이동
              SizedBox(
                width: 43,
                height: 22,
                child: ElevatedButton(
                  onPressed: () {
                    // 버튼 1 클릭 시 동작
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // 여백 제거
                  ),
                  child: const Text(
                    '공부',
                    style: TextStyle(fontSize: 10), // 텍스트 크기 조정
                  ),
                ),
              ),
              const SizedBox(width: 4), // 버튼 간격 조정
              SizedBox(
                width: 43,
                height: 22,
                child: ElevatedButton(
                  onPressed: () {
                    // 버튼 2 클릭 시 동작
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // 여백 제거
                  ),
                  child: const Text(
                    '일정',
                    style: TextStyle(fontSize: 10), // 텍스트 크기 조정
                  ),
                ),
              ),
              const Spacer(), // 버튼 2와 3 사이의 공간을 차지
              SizedBox(
                width: 70,
                height: 22,
                child: ElevatedButton(
                  onPressed: () {
                    // 버튼 3 클릭 시 동작
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // 여백 제거
                  ),
                  child: const Text(
                    '원시간표',
                    style: TextStyle(fontSize: 10), // 텍스트 크기 조정
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 새로운 컨테이너 추가
          Container(
            width: 380,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xff333333), // 배경색
              borderRadius: BorderRadius.circular(15), // 모서리 둥글게
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2, // 왼쪽 영역을 더 넓게
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '오늘의',
                          style: TextStyle(fontSize: 16, color: Colors.white), // 텍스트 색상 추가
                        ),
                        Text(
                          '총평',
                          style: TextStyle(fontSize: 16, color: Colors.white), // 텍스트 색상 추가
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(
                  color: Colors.white, // 세로줄 색상
                  thickness: 1, // 세로줄 두께
                  width: 10, // 세로줄과 텍스트 사이 간격
                ),
                Expanded(
                  flex: 7, // 오른쪽 영역을 좁게
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white), // 텍스트 색상
                      decoration: InputDecoration(
                        hintText: '클릭 후 오늘의 총 평을 입력해 보세요.',
                        hintStyle: const TextStyle(color: Colors.white54), // 힌트 색상
                        border: InputBorder.none, // 테두리 제거
                      ),
                      maxLines: null, // 여러 줄 입력 가능
                      textAlignVertical: TextAlignVertical.top, // 텍스트 필드를 위쪽으로 정렬
                      cursorColor: Colors.white, // 커서 색상
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 380,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xff333333), // 배경색
              borderRadius: BorderRadius.circular(15), // 모서리 둥글게
            ),
            alignment: Alignment.center,
            child: const Text(
              '여기에 내용이 들어갑니다.',
              style: TextStyle(fontSize: 16, color: Colors.white), // 텍스트 색상 추가
            ),
          ),
        ],
      ),
    );
  }
}
