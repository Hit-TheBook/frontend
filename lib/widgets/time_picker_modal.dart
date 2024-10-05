import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimePickerModal extends StatefulWidget {
  final bool isStartTime; // 시작 시각 여부를 나타내는 매개변수

  TimePickerModal({required this.isStartTime}); // 생성자에서 매개변수 받기

  @override
  _TimePickerModalState createState() => _TimePickerModalState();
}

class _TimePickerModalState extends State<TimePickerModal> {
  int selectedHour = 12; // 기본 선택된 시간 (12시)
  int selectedMinute = 0; // 기본 선택된 분 (0분)

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5, // 모달의 높이를 화면 높이의 50%로 설정
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // 모달 상단의 둥근 모서리
        ),
        child: Column(
          children: [
            // 상단 버튼 바
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              color: Colors.grey[200], // 상단바 배경색
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 모달 닫기
                    },
                    child: Text(
                      '취소',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Text(
                    widget.isStartTime ? '시작 시각 선택' : '종료 시각 선택',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // 완료 로직 처리
                      Navigator.of(context).pop(); // 모달 닫기
                      // 선택된 시간과 분을 처리하는 로직 추가 가능
                      print('선택된 시간: $selectedHour 시 $selectedMinute 분');
                    },
                    child: Text(
                      '완료',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      backgroundColor: Colors.white,
                      itemExtent: 32.0,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          selectedHour = value; // 선택된 시간을 업데이트
                        });
                      },
                      children: List<Widget>.generate(24, (index) {
                        return Center(
                          child: Text('$index 시'),
                        );
                      }),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      backgroundColor: Colors.white,
                      itemExtent: 32.0,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          selectedMinute = value; // 선택된 분을 업데이트
                        });
                      },
                      children: List<Widget>.generate(60, (index) {
                        return Center(
                          child: Text('$index 분'),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 모달을 아래에서 보여주기 위한 함수
void showTimePickerModal(BuildContext context, bool isStartTime) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return TimePickerModal(isStartTime: isStartTime);
    },
    isScrollControlled: true, // 스크롤 가능하도록 설정
    isDismissible: true, // 모달을 탭하여 닫을 수 있도록 설정
    enableDrag: true, // 드래그로 모달을 닫을 수 있도록 설정
  );
}
