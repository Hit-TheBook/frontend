import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/utils/api_helper.dart'; // API 헬퍼 파일 가져오기
import 'ddaydetail_page.dart';
import 'package:project1/widgets/custom_appbar.dart';
import 'package:project1/theme.dart';

class DdayPage extends StatefulWidget {
  const DdayPage({super.key});

  @override
  DdayPageState createState() => DdayPageState();
}

class DdayPageState extends State<DdayPage> {
  List<Map<String, dynamic>> _ddayList = [];
  Map<String, dynamic>? _selectedDday;

  @override
  void initState() {
    super.initState();
    _fetchDday(); // 페이지 로드 시 디데이 목록을 가져옵니다.
  }

  Future<void> _fetchDday() async {
    try {
      final response = await ApiHelper.getRequest('dday');
      if (response.statusCode == 200) {
        setState(() {
          _ddayList = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
        print('Ddays fetched successfully: $_ddayList');
      } else {
        print('Failed to fetch Ddays: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Ddays: $e');
    }
  }

  Future<void> _addDday(Map<String, dynamic> ddayData) async {
    try {
      final response = await ApiHelper.addDday(ddayData);
      if (response != null) {
        setState(() {
          _ddayList.add(response);
        });
        print('Dday added: $ddayData');
      }
    } catch (e) {
      print('Error adding Dday: $e');
    }
  }

  Future<void> _editDday(Map<String, dynamic> ddayData) async {
    try {
      final response = await ApiHelper.updateDday(ddayData['id'], ddayData);
      if (response != null) {
        setState(() {
          final index = _ddayList.indexWhere((dday) => dday['id'] == ddayData['id']);
          if (index != -1) {
            _ddayList[index] = ddayData;
          }
        });
        print('Dday edited: $ddayData');
      }
    } catch (e) {
      print('Error editing Dday: $e');
    }
  }

  Future<void> _deleteDday(Map<String, dynamic> ddayData) async {
    try {
      await ApiHelper.deleteDday(ddayData['id']);
      setState(() {
        _ddayList.removeWhere((dday) => dday['id'] == ddayData['id']);
      });
      print('Dday deleted: $ddayData');
    } catch (e) {
      print('Error deleting Dday: $e');
    }
  }

  void _showDdayOptions(BuildContext context, Map<String, dynamic> dday) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('옵션'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DdaydetailPage(
                        initialTitle: dday['title'],
                        initialStartDate: DateTime.parse(dday['startDate']),
                        initialEndDate: DateTime.parse(dday['endDate']),
                      ),
                    ),
                  ).then((result) {
                    if (result != null) {
                      _editDday(result);
                    }
                  });
                },
                child: const Text('수정'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteDday(dday);
                },
                child: const Text('삭제'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '디데이',
      ),
      body: _ddayList.isEmpty
          ? const Center(
        child: Text(
          '디데이를 추가해 보세요',
          style: TextStyle(color: Colors.grey, fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: _ddayList.length,
        itemBuilder: (context, index) {
          final dday = _ddayList[index];
          final title = dday['title'] ?? '디데이 제목';
          final startDate = dday['startDate'] != null
              ? DateTime.parse(dday['startDate'].toString())
              : null;
          final endDate = dday['endDate'] != null
              ? DateTime.parse(dday['endDate'].toString())
              : null;
          final formattedStartDate = startDate != null
              ? DateFormat('yyyy.MM.dd').format(startDate)
              : '시작일 없음';
          final formattedEndDate = endDate != null
              ? DateFormat('yyyy.MM.dd').format(endDate)
              : '종료일 없음';

          return ListTile(
            title: Text(title),
            subtitle: Text('$formattedStartDate ~ $formattedEndDate'),
            onTap: () => _showDdayOptions(context, dday),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DdaydetailPage()),
          );

          if (result != null) {
            _addDday(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
