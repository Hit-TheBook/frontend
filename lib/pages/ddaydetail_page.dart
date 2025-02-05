import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/src/response.dart';
import 'package:intl/intl.dart';
import 'package:project1/colors.dart';
import 'package:project1/models/dday_model.dart';
import 'package:project1/pages/dday_page.dart';
import 'package:project1/utils/dday_api_helper.dart'; // API helper import

class DdaydetailPage extends StatefulWidget {
  final String? initialTitle;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final bool isEditing;  // 플래그 추가
  final String? ddayId;

  const DdaydetailPage({
    super.key,
    this.initialTitle,
    this.initialStartDate,
    this.initialEndDate,
    this.isEditing = false,  // 기본값 false
    this.ddayId,  // 디데이 ID
  });

  @override
  DdaydetailPageState createState() => DdaydetailPageState();
}

class DdaydetailPageState extends State<DdaydetailPage> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

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

    if (_selectedStartDate == null || _selectedEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('시작일과 종료일을 모두 선택해주세요.')),
      );
      return;
    }

    if (_selectedEndDate!.isBefore(_selectedStartDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('종료일은 시작일 이후여야 합니다.')),
      );
      return;
    }

    final dday = RequestDday(
      ddayName: _titleController.text,
      startDate: _selectedStartDate!,
      endDate: _selectedEndDate!,
    );

    try {
      Map<String, dynamic> requestDday = dday.toJson();
      late final Response response;

      if (widget.isEditing) {
        // 수정일 때 modifyDday 호출
        final apiHelper = ApiHelper();
        response = await await apiHelper.modifyDday(widget.ddayId!, requestDday);
      } else {
        // 추가일 때 addDday 호출
        final apiHelper = ApiHelper();
        response = await apiHelper.addDday('dday', requestDday);
      }

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DdayPage()),
        );
      } else {
        throw Exception(widget.isEditing ? 'Dday 수정에 실패했습니다.' : 'Dday 추가에 실패했습니다.');
      }
    } catch (e) {
      print('Error saving Dday: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.isEditing ? '디데이 수정에 실패했습니다.' : '디데이 추가에 실패했습니다.')),
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
        automaticallyImplyLeading: false,
        title: Text(widget.isEditing ? '디데이 수정' : '디데이 추가'),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              await _saveDday();
            },
            child:  Text(
              '완료',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new), // 원하는 아이콘으로 변경
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기 버튼 동작
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '디데이 이름',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: _titleController,
                decoration:  InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '디데이 이름을 입력하세요',
                  hintStyle: TextStyle(color: Colors.grey,fontSize: 14.sp),
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
                              backgroundColor: gray1,
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
                                Text(
                                  '시작일',
                                  style: TextStyle(color: Colors.white,fontSize: 12.sp),
                                ),
                                Text(
                                  _formatDate(_selectedStartDate),
                                  style: TextStyle(color: neonskyblue1,fontSize: 12.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 1.h, color: Colors.white),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _selectEndDate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: gray1,
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
                                Text(
                                  '종료일',
                                  style: TextStyle(color: Colors.white,fontSize: 12.sp),
                                ),
                                Text(
                                  _formatDate(_selectedEndDate),
                                  style: TextStyle(color: neonskyblue1,fontSize: 12.sp),
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
