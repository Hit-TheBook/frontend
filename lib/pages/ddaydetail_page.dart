import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 필요한 패키지

class DdaydetailPage extends StatefulWidget {
  final String? initialTitle;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const DdaydetailPage({
    super.key,
    this.initialTitle,
    this.initialStartDate,
    this.initialEndDate,
  });

  @override
  DdaydetailPageState createState() => DdaydetailPageState();
}

class DdaydetailPageState extends State<DdaydetailPage> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedStartDate; // 선택된 시작일을 저장할 변수
  DateTime? _selectedEndDate; // 선택된 종료일을 저장할 변수

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.initialTitle ?? '';
    // 오늘 날짜로 기본값 설정
    _selectedStartDate = widget.initialStartDate ?? DateTime.now();
    _selectedEndDate = widget.initialEndDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _showDatePicker({required bool isStartDate}) {
    DateTime? minimumDate;
    DateTime? initialDate = DateTime.now();

    // 시작일이 설정된 경우 종료일 선택 시 최소 날짜 설정
    if (!isStartDate && _selectedStartDate != null) {
      minimumDate = _selectedStartDate;
      initialDate = _selectedEndDate ?? minimumDate;
    }

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                height: 160,
                child: CupertinoDatePicker(
                  initialDateTime: initialDate,
                  mode: CupertinoDatePickerMode.date,
                  minimumDate: minimumDate,
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      if (isStartDate) {
                        _selectedStartDate = newDate;
                        if (_selectedEndDate != null && newDate.isAfter(_selectedEndDate!)) {
                          _selectedEndDate = null; // 시작일이 종료일 이후로 변경된 경우 종료일을 초기화
                        }
                      } else {
                        if (newDate.isBefore(_selectedStartDate ?? newDate)) {
                          // 종료일이 시작일 이전으로 선택된 경우
                          return;
                        }
                        _selectedEndDate = newDate;
                      }
                    });
                  },
                ),
              ),
            ),
            CupertinoButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void _selectStartDate() {
    _showDatePicker(isStartDate: true);
    if (kDebugMode) {
      print('Start Date button clicked');
    }
  }

  void _selectEndDate() {
    if (_selectedStartDate == null) {
      // 시작일이 설정되지 않은 경우
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('먼저 시작일을 선택해주세요.')),
      );
      return;
    }
    _showDatePicker(isStartDate: false);
    if (kDebugMode) {
      print('End Date button clicked');
    }
  }

  void _saveDday() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('디데이 이름을 입력해주세요.')),
      );
      return;
    }

    Navigator.of(context).pop({
      'title': _titleController.text,
      'startDate': _selectedStartDate,
      'endDate': _selectedEndDate,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('디데이 추가'),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            onPressed: _saveDday,
            child: const Text(
              '완료',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  hintStyle: TextStyle(color: Colors.grey), // 힌트 텍스트 색상
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _selectStartDate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '시작일',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  _formatDate(_selectedStartDate),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 1, color: Colors.white),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _selectEndDate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '종료일',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  _formatDate(_selectedEndDate).isEmpty ? '종료일' : _formatDate(_selectedEndDate),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16), // 여유 공간 추가
            ],
          ),
        ),
      ),
    );
  }
}
