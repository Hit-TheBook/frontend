import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/colors.dart';
import 'package:project1/utils/alert_api_helper.dart';

import '../widgets/custom_appbar.dart';
import 'home_screen.dart';

class AlertPage extends StatefulWidget {
  @override
  _AlertPageState createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  late Future<Map<String, List<Map<String, String>>>> _alertsFuture;
  String selectedCategory = "공지"; // 기본 선택된 카테고리
  final AlertApiHelper alertApiHelper = AlertApiHelper(); // 인스턴스 생성

  // Expansion 상태를 저장하는 리스트
  final Map<int, bool> _expansionState = {};

  @override
  void initState() {
    super.initState();
    _alertsFuture = alertApiHelper.getAlerts(); // API 호출
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '알림',
        showBackButton: true,
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(initialIndex: 0), // StudyPage가 보이도록 설정
            ),
          );
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // 카테고리 버튼 3개
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
              children: [
                SizedBox(width: 15.w),
                _buildCategoryButton("공지"),
                SizedBox(width: 5.w), // 첫 번째와 두 번째 버튼 사이에 5.w 여백
                _buildCategoryButton("레벨/엠블럼"),
                SizedBox(width: 5.w), // 두 번째와 세 번째 버튼 사이에 5.w 여백
                _buildCategoryButton("나의 스터디"),
              ],
            ),

            SizedBox(height: 5.h),
            Divider(color: white1, thickness: 1.h),
            // API 데이터 가져오기
            Expanded(
              child: FutureBuilder<Map<String, List<Map<String, String>>>>(
                future: _alertsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator()); // 로딩 인디케이터
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("데이터를 불러오는 중 오류가 발생했습니다."));
                  }

                  // 현재 선택된 카테고리에 해당하는 리스트 가져오기
                  List<Map<String, String>> alertList = [];
                  switch (selectedCategory) {
                    case "공지":
                      alertList = snapshot.data?["alertNoticeList"] ?? [];
                      break;
                    case "레벨/엠블럼":
                      alertList = snapshot.data?["alertLevelEmblemList"] ?? [];
                      break;
                    case "나의 스터디":
                      alertList = snapshot.data?["alertStudyList"] ?? [];
                      break;
                  }

                  if (alertList.isEmpty) {
                    return Center(
                      child: Text(
                        "새로운 알림이 없습니다.",
                        style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: alertList.length,
                    separatorBuilder: (context, index) => Divider(
                      color: white1,
                      thickness: 1.h, // 구분선 두께 설정
                    ), // 구분선 추가
                    itemBuilder: (context, index) {
                      String title = alertList[index]["title"] ?? "제목 없음";
                      String text = (alertList[index]["text"] != null && alertList[index]["text"]!.isNotEmpty && alertList[index]["text"] != "null")
                          ? alertList[index]["text"]!
                          : "내용 없음"; // null, 빈 문자열, "null"일 경우 "내용 없음"

                      return StatefulBuilder(
                        builder: (context, setState) {
                          bool isExpanded = _expansionState[index] ?? false;
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 0.h),
                            color: Colors.black, // 카드의 기본 배경을 검정색으로 설정
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.black, // 제목 영역의 배경을 검정색으로 유지
                                  child: ListTile(
                                    title: Text(
                                      title,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white, // 기본적으로 흰색 글자
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        isExpanded
                                            ? Icons.keyboard_arrow_up // 펼쳐진 경우 ^
                                            : Icons.keyboard_arrow_down, // 기본은 v
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _expansionState[index] = !isExpanded;
                                        });
                                      },
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _expansionState[index] = !isExpanded;
                                      });
                                    },
                                  ),
                                ),
                                // 펼쳐졌을 때만 내용 표시
                                if (isExpanded)
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(12.w),
                                    color: Colors.white, // 펼쳐진 내용 배경을 흰색으로 설정
                                    child: Text(
                                      text,
                                      style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 카테고리 버튼 위젯
  Widget _buildCategoryButton(String category) {
    // 버튼 크기 설정
    Size buttonSize = category == "공지" ? Size(46.w, 20.h) : Size(90.w, 20.h);

    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = category;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: black1,
        backgroundColor: selectedCategory == category ? neonskyblue1 : white1,
        minimumSize: buttonSize, // 동적으로 크기 설정
        padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 0.w), // 버튼 내 여백 설정
      ),
      child: Text(category),
    );
  }

}
