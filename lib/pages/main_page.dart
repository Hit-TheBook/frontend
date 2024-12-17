import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project1/colors.dart';
import 'package:project1/pages/login_page.dart';
import 'package:project1/pages/study_page.dart';
import 'package:project1/pages/test_page.dart';
import 'package:project1/widgets/bottom_nav_bar.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:project1/utils/auth_api_helper.dart';
import 'package:project1/widgets/customdialog.dart';
import 'package:project1/models/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/models/user_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static final List<Widget> pages = <Widget>[
    const MainContent(),
    const StudyPage(),
    const TestPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 뒤로가기 버튼을 눌렀을 때 로그인 화면으로 이동
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false, // 기존 라우트를 모두 제거하고 LoginPage로 이동
        );
        return false; // 기본 뒤로가기 동작을 막음
      },
      child: Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: _selectedIndex == 0 || _selectedIndex == 1 // MainPage와 StudyPage에서만 하단바 표시
            ? BottomNavBar(
          currentIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        )
            : null, // 다른 페이지에서는 하단바 숨김
      ),

    );
  }
}

class MainContent extends StatefulWidget {
  const MainContent({super.key});

  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  String? nickname;
  int? point;
  double progress = 0.66; // 0.0 ~ 1.0 (기본 66%로 설정)
  final AuthApiHelper authApiHelper = AuthApiHelper();
  List<Emblem> emblems = []; // 서버에서 받은 엠블럼 데이터를 저장할 리스트


  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // 사용자 정보를 로드
    _fetchEmblems();
  }
  Future<void> _fetchEmblems() async {
    try {
      // authApiHelper.fetchEmblems() 호출로 엠블럼 리스트 가져오기
      List<Emblem> fetchedEmblems = await authApiHelper.fetchEmblems();

      setState(() {
        // 서버에서 가져온 엠블럼 데이터를 상태에 설정
        emblems = fetchedEmblems;
      });
    } catch (e) {
      print('엠블럼을 가져오는 중 오류 발생: $e');
    }
  }


  Future<void> _loadUserInfo() async {
    try {
      final response = await authApiHelper.findUserName('nickname'); // 엔드포인트 수정
      if (response.statusCode == 200) {
        final userInfo = UserResponse.fromJson(jsonDecode(response.body));
        setState(() {
          nickname = userInfo.nickname;
         // point = userInfo.point;
          //progress = point != null ? (point! / 100) : 0.0; // 경험치 퍼센트 계산
          progress = 0.6; // 경험치 퍼센트 계산
        });
      } else {
        print('사용자 정보를 가져오는 중 오류 발생: ${response.body}');
      }
    } catch (e) {
      print('사용자 정보를 가져오는 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 자동으로 생성되는 뒤로가기 버튼 제거
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), // 상단 10, 좌우 20
          child: nickname != null
              ? Text(
            '$nickname', // 닉네임만 표시
            style: TextStyle(
              fontSize: 14.sp, // 화면 크기에 맞게 텍스트 크기 조정
            ),
          )
              : Text(
            'Loading...', // 닉네임이 로드되지 않았을 때 로딩 표시
            style: TextStyle(
              fontSize: 14.sp, // 기본 텍스트 크기 설정
            ),
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.black, // AppBar 배경색
        actions: [
          IconButton(
            icon: const Icon(
              Icons.mode_edit_outline_outlined,
              size: 25,
            ),
            onPressed: () {
              // 메뉴 아이콘을 눌렀을 때 동작 추가
              print("Menu button pressed");
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_none_outlined,
              size: 25,
            ),
            onPressed: () {
              // 메뉴 아이콘을 눌렀을 때 동작 추가
              print("Menu button pressed");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(
              color: neonskyblue1, // 구분선 색상
              thickness: 1, // 구분선 두께
              indent: 0, // 왼쪽 여백
              endIndent: 0, // 오른쪽 여백
            ),
            Container(
              width: 360.w,
              height: 227.h, // 높이 설정
              color: black1, // 배경색 (짙은 회색)
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    'Blue V',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: neonskyblue1,
                    ),
                  ),
                  //SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w), // 왼쪽에 20.w 만큼 패딩 추가
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // 이미지를 가로로 중앙 정렬
                      children: [
                        Image.asset(
                          'assets/levels/blue_v.png',
                          width: 150.w,
                          height: 150.h,
                          fit: BoxFit.contain,
                        ),
                        //SizedBox(width: 10.w), // 이미지와 아이콘 사이에 여백 추가
                        Padding(
                          padding: EdgeInsets.only(top: 110.h), // 아이콘 위쪽에 10.h 만큼 패딩 추가
                          child: Icon(
                            Icons.help_outline_outlined,
                            size: 15.sp,
                            color: Colors.white, // 아이콘 색상
                          ),
                        ),
                      ],
                    ),
                  ),


                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 160.w),
                        child: Text(
                          '현재 점수',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: neonskyblue1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 45.w),
                        child: Text(
                          '다음 레벨 점수',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 268.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: white1,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: 268.w * progress,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: neonskyblue1,
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),


            const Divider(
              color: neonskyblue1, // 구분선 색상
              thickness: 1, // 구분선 두께
              indent: 0, // 왼쪽 여백
              endIndent: 0, // 오른쪽 여백
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w), // 텍스트 위아래 여백
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '엠블럼 수집함',
                    style: TextStyle(
                      fontSize: 14.sp, // 반응형 텍스트 크기

                      color:neonskyblue1, // 텍스트 색상
                    ),
                  ),
                  SizedBox(height: 5.h), // 위아래 간격 추가
                  Align(
                    alignment: Alignment.centerRight, // 오른쪽 정렬
                    child: Text(
                      '총 수집 개수: ${emblems.isNotEmpty ? emblems.length : 0}',
                      style: TextStyle(
                        fontSize: 10.sp, // 반응형 텍스트 크기
                        color: Colors.white, // 텍스트 색상
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (emblems.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: // MainContent 내부의 GridView.builder 부분 수정
                GridView.builder(
                  shrinkWrap: true, // 스크롤뷰 안에서 작동하도록 설정
                  physics: const NeverScrollableScrollPhysics(), // 내부 스크롤 비활성화
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 한 줄에 3개의 이미지
                    crossAxisSpacing: 5.w, // 이미지 간격
                    mainAxisSpacing: 10.h, // 이미지 세로 간격
                    childAspectRatio: 1, // 이미지의 가로 세로 비율
                  ),
                  itemCount: emblems.length,
                  itemBuilder: (context, index) {
                    final emblem = emblems[index]; // 각 엠블럼 데이터 가져오기
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.asset(
                            'assets/emblem/${emblem.emblemName}.png',  // 동적 이미지 경로
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 5.h), // 이미지와 텍스트 사이 간격
                        Text(
                          emblem.emblemCreateAt, // 생성일 텍스트
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 2.h), // 이미지와 텍스트 사이 간격
                        Text(
                          emblem.emblemContent, // 엠블럼 내용 텍스트
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  },
                ),

              ),
            ] else ...[
              Center(
                child: Text(
                  '엠블럼이 없습니다.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/hitthebook.jpg', // 이미지 경로
                    width: 100.w, // 화면 크기에 맞게 너비 조정
                    height: 100.h, // 화면 크기에 맞게 높이 조정
                  ),
                  if (nickname != null && point != null) ...[
                    Text('닉네임: $nickname', style: TextStyle(fontSize: 18.sp)),
                    Text('포인트: $point', style: TextStyle(fontSize: 18.sp)),
                    const SizedBox(height: 20),
                  ],
                  ElevatedButton(
                    onPressed: () {
                      _showConfirmationDialog(context);
                    },
                    child: const Text('탈퇴하기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
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

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: '탈퇴 확인',
          content: const Text('정말로 탈퇴하시겠습니까?'),
          onConfirm: () async {
            String endpoint = 'member';
            try {
              final response = await authApiHelper.deleteAccount(endpoint);
              if (response.statusCode == 200) {
                print('탈퇴가 완료되었습니다.');
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false,
                );
              } else {
                print('탈퇴 실패: ${response.body}');
                _showErrorDialog(
                    context, '탈퇴 실패', '서버 오류로 탈퇴할 수 없습니다. 나중에 다시 시도해주세요.');
              }
            } catch (e) {
              print('탈퇴 중 오류 발생: $e');
              _showErrorDialog(
                  context, '탈퇴 실패', '탈퇴 중 오류가 발생했습니다. 다시 시도해주세요.');
            }
          },
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
