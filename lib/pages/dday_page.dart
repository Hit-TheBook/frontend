import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project1/pages/ddaydetail_page.dart';
import 'package:project1/pages/study_page.dart';
import '../utils/dday_api_helper.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/customfloatingactionbutton.dart';

class DdayPage extends StatefulWidget {
  const DdayPage({super.key});

  @override
  DdayPageState createState() => DdayPageState();
}

class DdayPageState extends State<DdayPage> {
  final List<Map<String, dynamic>> _ddayList = []; // 디데이 정보를 저장할 리스트
  Map<String, dynamic>? _selectedDday; // 현재 선택된 디데이 정보

  @override
  void initState() {
    super.initState();
    _fetchDdayList(); // 화면이 생성될 때 디데이 리스트를 가져옴
  }

  Future<void> _fetchDdayList() async {
    try {
      final apiHelper = ApiHelper();
      final response = await apiHelper.findDdayList('dday/list');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        // 대표 디데이와 일반 디데이를 구분
        final primaryDday = data['primaryDday']; // 대표 디데이
        List<dynamic> upComingDdays = data['upComingDdays'] ?? [];
        List<dynamic> oldDdays = data['oldDdays'] ?? [];

        // 대표 디데이가 null이 아닌지 확인
        if (primaryDday != null) {
          print('현재 설정된 대표 디데이:');
          print('ID: ${primaryDday['ddayId']}');
          print('이름: ${primaryDday['ddayName']}');
          print('시작일: ${primaryDday['startDate']}');
          print('종료일: ${primaryDday['endDate']}');
          print('남은날짜: ${primaryDday['remainDays']}');
          print('기간: ${primaryDday['durationDays']}');

          // 같은 ID를 가진 디데이를 리스트에서 제거
          upComingDdays = upComingDdays.where((item) => item['ddayId'] != primaryDday['ddayId']).toList();
          oldDdays = oldDdays.where((item) => item['ddayId'] != primaryDday['ddayId']).toList();
        } else {
          print('현재 설정된 대표 디데이가 없습니다.');
        }

        setState(() {
          // 기존 데이터를 클리어
          _ddayList.clear();

          // 대표 디데이가 null이 아닌 경우에만 추가
          // 대표 디데이가 있을 경우 콘솔에 출력
          if (primaryDday != null && primaryDday['ddayId'] != null) {
            print('현재 설정된 대표 디데이:');
            print('ID: ${primaryDday['ddayId']}');
            print('이름: ${primaryDday['ddayName']}');
            print('시작일: ${primaryDday['startDate']}');
            print('종료일: ${primaryDday['endDate']}');
            print('남은날짜: ${primaryDday['remainingDays']}');
            print('기간: ${primaryDday['durationDays']}');


            // 같은 ID를 가진 디데이를 리스트에서 제거
            upComingDdays = upComingDdays.where((item) => item['ddayId'] != primaryDday['ddayId']).toList();
            oldDdays = oldDdays.where((item) => item['ddayId'] != primaryDday['ddayId']).toList();

            _ddayList.add({
              'ddayId': primaryDday['ddayId'] ?? '', // null 처리
              'ddayName': primaryDday['ddayName'] ?? 'Unknown', // null 처리
              'startDate': primaryDday['startDate'] ?? '', // null 처리
              'endDate': primaryDday['endDate'] ?? '',
              'remainingDays': primaryDday['remainingDays'] ?? '',
              'durationDays': primaryDday['durationDays'] ?? '',// null 처리
              'isPrimary': true, // 대표 디데이 여부를 표시할 수 있는 플래그 추가
            });
          } else {
            print('현재 설정된 대표 디데이가 없습니다.');
          }


          // 일반 디데이를 대표 디데이 아래에 추가
          _ddayList.addAll(upComingDdays.map((item) => {
            'ddayId': item['ddayId'],
            'ddayName': item['ddayName'],
            'startDate': item['startDate'],
            'endDate': item['endDate'],
            'remainingDays' : item['remainingDays'],
            'durationDays': item['durationDays'],
            'isPrimary': false, // 일반 디데이
          }).toList());

          // 과거 디데이 추가
          _ddayList.addAll(oldDdays.map((item) => {
            'ddayId': item['ddayId'],
            'ddayName': item['ddayName'],
            'startDate': item['startDate'],
            'endDate': item['endDate'],
            'remainingDays' : item['remainingDays'],
            'durationDays': item['durationDays'],
            'isPrimary': false, // 일반 디데이
          }).toList());
        });

        // 성공적으로 디데이 리스트를 가져왔을 때 콘솔에 로그 출력
        print('디데이 리스트를 성공적으로 가져왔습니다: ${_ddayList.length}개의 디데이 항목이 있습니다.');
      } else {
        throw Exception('Failed to load dday list. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching dday list: $error');
    }
  }





  // 디데이 상세 페이지로 이동하는 함수
  void _navigateToDdayDetail() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DdaydetailPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _ddayList.add(result);
      });
    } else {
      print("Unexpected result type: $result");
    }
  }

  // 디데이 옵션(수정, 삭제 등)을 보여주는 함수
  void _showDdayOptions(BuildContext context, Map<String, dynamic> dday) {
    _selectedDday = dday;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF333333), // 배경색 설정
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // 둥근 테두리
          ),
          contentPadding: EdgeInsets.zero, // Padding 제거
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // 화면 가로의 80%로 설정
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: const Text(
                    '대표 디데이 설정',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white), // 글씨색 흰색
                  ),
                  onTap: () {
                    Navigator.pop(context); // 다이얼로그 닫기
                    _setAsFeaturedDday(dday);
                  },
                ),
                ListTile(
                  title: const Text(
                    '디데이 정보 수정',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white), // 글씨색 흰색
                  ),
                  onTap: () {
                    Navigator.pop(context); // 다이얼로그 닫기
                    _editDdayInfo(dday);
                  },
                ),
                ListTile(
                  title: const Text(
                    '디데이 삭제',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white), // 글씨색 흰색
                  ),
                  onTap: () {
                    Navigator.pop(context); // 다이얼로그 닫기
                    _deleteDday(dday);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 대표 디데이 설정 함수 (서버와 통신)
  Future<void> _setAsFeaturedDday(Map<String, dynamic> dday) async {
    final ddayId = dday['ddayId'].toString(); // int를 String으로 변환

    try {
      // API 호출하여 대표 디데이 설정
      final apiHelper = ApiHelper();
      final response = await apiHelper.setFeaturedDday(ddayId);

      if (response.statusCode == 200) {
        // 서버에 성공적으로 저장되면 로컬 리스트에서도 변경
        setState(() {
          _ddayList.remove(dday);
          _ddayList.insert(0, dday);
        });

        // 성공적으로 대표 디데이 설정 후 사용자에게 알림
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${dday['ddayName']}이(가) 대표 디데이로 설정되었습니다.')),
        );
      } else {
        throw Exception('Failed to set featured dday. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error setting featured dday: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('대표 디데이 설정에 실패했습니다.')),
      );
    }
  }


  // 디데이 정보 수정 함수
  Future<void> _editDdayInfo(Map<String, dynamic> dday) async {
    final ddayId = dday['ddayId'].toString(); // int를 String으로 변환
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DdaydetailPage(
          initialTitle: dday['ddayName'],
          initialStartDate: DateTime.parse(dday['startDate']),
          initialEndDate: DateTime.parse(dday['endDate']),
          isEditing: true,// 수정모드를 나타내는 플래그
          ddayId: ddayId, // 디데이 ID 전달
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        final index = _ddayList.indexOf(dday);
        if (index != -1) {
          _ddayList[index] = result;
        }
      });
    }
  }





// DdayPageState 클래스에서 삭제 메소드 정의
  Future<void> _deleteDday(Map<String, dynamic> dday) async {


    final ddayId = dday['ddayId'].toString(); // int를 String으로 변환


    try {
      final apiHelper = ApiHelper();
      final response = await apiHelper.deleteDday(ddayId);

      if (response.statusCode == 200) {
        // 서버에서 성공 응답을 받으면, 리스트에서 해당 디데이 제거
        setState(() {
          _ddayList.remove(dday);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${dday['ddayName']}이(가) 삭제되었습니다.')),
        );
      } else {
        throw Exception('Failed to delete dday. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting dday: $error');
    }
  }



  // 날짜 형식 포맷팅 함수
  String _formatDate(DateTime date) {
    return DateFormat('yyyy.MM.dd').format(date);
  }

  // 시작일과 종료일의 차이를 계산하는 함수
  String _calculateDuration(DateTime startDate, DateTime endDate) {
    final difference = endDate.difference(startDate).inDays;
    return '$difference일';
  }

  // 시작일까지 남은 일수를 계산하는 함수
  String? _calculateDaysUntilStart(DateTime startDate) {
    final today = DateTime.now();
    final difference = startDate.difference(today).inDays;
    if (difference > 0) {
      return '$difference일 후 시작';
    }
    return null; // 오늘 날짜가 시작일을 지나면 null 반환
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // 뒤로 가기 버튼을 눌렀을 때 StudyPage로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StudyPage()),
          );
          return true; // 기본 뒤로가기 동작을 막음
        },
      child : Scaffold(
        appBar:  const CustomAppBar(
          title: '디데이',
          showBackButton: true,
        ),
        body: _ddayList.isEmpty
          ? const Center(
        child: Text(
          '디데이를 추가해 보세요',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
        ),
      )
          : ListView.builder(
        itemCount: _ddayList.length,
        itemBuilder: (context, index) {
          final dday = _ddayList[index];
          final ddayId = dday['ddayId'];
          final ddayName = dday['ddayName'];
          final startDate = DateTime.parse(dday['startDate']);
          final endDate = DateTime.parse(dday['endDate']);
          final formattedStartDate = _formatDate(startDate);
          final formattedEndDate = _formatDate(endDate);
          final durationDays= dday['durationDays'];
          final remaningDays = dday['remaningDays'];
          final duration = _calculateDuration(startDate, endDate);
          final daysUntilStart = _calculateDaysUntilStart(startDate);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF333333), // 배경색
                borderRadius: BorderRadius.circular(16.0), // 둥근 테두리
              ),
              child: ElevatedButton(
                onPressed: () => _showDdayOptions(context, dday),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // 배경색 투명
                  elevation: 0, // 그림자 제거
                  minimumSize: const Size(double.infinity, 60), // 높이 조정
                  padding: EdgeInsets.zero, // Padding 제거
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // 여백 추가
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            ddayName,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold, // 글씨 굵게
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$formattedStartDate~$formattedEndDate ($duration)',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      if (daysUntilStart != null) // 오늘 날짜가 시작일을 지나지 않았다면
                        Text(
                          daysUntilStart,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: _navigateToDdayDetail,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    ),
    );
  }
}