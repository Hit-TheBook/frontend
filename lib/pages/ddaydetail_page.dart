import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:project1/models/dday_model.dart';
import 'package:project1/utils/dday_api_helper.dart'; // API helper import
import 'package:flutter/material.dart';


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
  DateTime? _selectedStartDate; // Variable to store selected start date
  DateTime? _selectedEndDate; // Variable to store selected end date

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.initialTitle ?? '';
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
                          _selectedEndDate = null;
                        }
                      } else {
                        if (newDate.isBefore(_selectedStartDate ?? newDate)) {
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
              child: const Text('완료'),
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

  Future<void> _saveDday() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('디데이 이름을 입력해주세요.')),
      );
      return;
    }

    // Create a RequestDday object
    final requestDday = RequestDday(
      ddayName: _titleController.text,
      startDate: _selectedStartDate!,
      endDate: _selectedEndDate!,
    );

    try {
      Map<String, dynamic> requsetDday = requestDday.toJson();
      // Convert RequestDday object to JSON and send to API helper
      final response = await ApiHelper.addDday('dday', requsetDday);
      final responseData = jsonDecode(response.body);
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      print(jsonEncode(responseData));
      if (response.statusCode == 200 && responseData['message'] == 'successful') {
        Navigator.of(context).pop(requestDday);
      } else {
        throw Exception('Dday 추가에 실패했습니다.');
      }
    } catch (e) {
      print('Error saving Dday: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('디데이 추가에 실패했습니다.')),
      );
    }
  }

  void _selectStartDate() {
    _showDatePicker(isStartDate: true);
    if (kDebugMode) {
      print('Start Date button clicked');
    }
  }

  void _selectEndDate() {
    if (_selectedStartDate == null) {
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
                  hintStyle: TextStyle(color: Colors.grey),
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
                                  _formatDate(_selectedEndDate),
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
            ],
          ),
        ),
      ),
    );
  }
}
