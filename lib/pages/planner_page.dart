import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:project1/widgets/customfloatingactionbutton.dart';

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
          color: Colors.grey[300],
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

  TableRow _buildTimetableRow(String startTime, String endTime, String subject, String content, bool achieved) {
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
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              const Text(
                '~',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              Text(
                endTime,
                style: const TextStyle(color: Colors.white, fontSize: 10),
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
        Container(
          height: 60,
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Icon(
            achieved ? Icons.check_circle : Icons.cancel,
            color: achieved ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
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
              width: 122,
              height: 24,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 16.0),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: SizedBox(
                      width: 117,
                      height: 24,
                      child: Text(
                        formattedDate,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: const Icon(
                      Icons.arrow_drop_down,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // 버튼 추가
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 16),
              Container(
                width: 43,
                height: 22,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: ShapeDecoration(
                  color: Color(0xFF69EDFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '공부',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 43,
                height: 22,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 43,
                        height: 22,
                        decoration: ShapeDecoration(
                          color: Color(0xFF9D9D9D),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 6,
                      top: 3,
                      child: SizedBox(
                        width: 30,
                        height: 17,
                        child: Text(
                          '일정',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: 60,
                height: 22,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: ShapeDecoration(
                  color: Color(0xFF69EDFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '원 시간표',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
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
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '클릭 후 오늘의 총 평을 입력해 보세요.',
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      cursorColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // 시간표 컨테이너 추가
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
                        '주제',
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
                // 시간표 데이터 추가
                _buildTimetableRow('am 6:00', 'am 7:00', '화학I', '실험 준비', false),
                _buildTimetableRow('am 7:00', 'am 8:00', '수학', '문제풀이', true),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // 하단에 추가할 Container


        ],
      ),

      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          // 플래너 페이지에서의 버튼 동작
        },
      ),
    );
  }
}
