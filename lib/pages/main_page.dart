import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project1/colors.dart';
import 'package:project1/pages/login_page.dart';
import 'package:project1/pages/study_page.dart';
import 'package:project1/pages/planner_page.dart';
import 'package:project1/pages/dday_page.dart';
import 'package:project1/pages/timer.dart';
import 'package:project1/utils/auth_api_helper.dart';
import 'package:project1/widgets/customdialog.dart';
import 'package:project1/models/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/level_images.dart';


// class MainPage extends StatefulWidget {
//   const MainPage({super.key});
//
//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // 뒤로가기 버튼을 눌렀을 때 로그인 화면으로 이동
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginPage()),
//               (route) => false, // 기존 라우트를 모두 제거하고 LoginPage로 이동
//         );
//         return false; // 기본 뒤로가기 동작을 막음
//       },
//       child: Scaffold(
//
//       ),
//     );
//   }
// }

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? nickname;
  int? point;
  String? levelName;
  int? minPoint;
  int? maxPoint;
  int? level;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double calculateProgress() {
    if (minPoint != null && maxPoint != null && point != null) {
      return (point! - minPoint!) / (maxPoint! - minPoint!);
    }
    return 0.0; // null이 있는 경우 기본값 설정
  } // 0.0 ~ 1.0
  final AuthApiHelper authApiHelper = AuthApiHelper();
  List<Emblem> emblems = []; // 서버에서 받은 엠블럼 데이터를 저장할 리스트


  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // 사용자 정보를 로드
    _fetchEmblems();
    _fetchLevel();
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
  bool isLoading = true; // 로딩 상태 추가

  Future<void> _fetchLevel() async {
    print('레벨 데이터를 가져오기 시작');
    try {
      Level level = await authApiHelper.fetchLevel();
      setState(() {
        this.level = level.level;
        levelName = level.levelName;
        point = level.point;
        minPoint = level.minPoint;
        maxPoint = level.maxPoint;
        isLoading = false; // 데이터 로드 완료
      });
      print('레벨 데이터 로드 완료');
    } catch (e) {
      print('레벨 데이터를 가져오는 중 오류 발생: $e');
      setState(() {
        isLoading = false; // 오류 발생 시 로딩 종료
      });
    }
  }




  Future<void> _loadUserInfo() async {
    try {
      final response = await authApiHelper.findUserName('member/nickname'); // 엔드포인트 수정
      if (response.statusCode == 200) {
        final userInfo = UserResponse.fromJson(jsonDecode(response.body));
        setState(() {
          nickname = userInfo.nickname;


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
    return WillPopScope(
        onWillPop: () async {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
      );
      return false;
    },
    child: Scaffold(
    key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false, // 자동으로 생성되는 뒤로가기 버튼 제거
        title: Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 20.0, top: 10.0), // 왼쪽 여백을 0으로 설정
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.menu, // 메뉴 아이콘
                  color: neonskyblue1, // 아이콘 색상
                  size: 25,
                ),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer(); // 사이드바 열기
                },
              ),
              SizedBox(width: 8), // 아이콘과 닉네임 간의 간격
              nickname != null
                  ? Text(
                '$nickname', // 닉네임 표시
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : Text(
                'Loading...', // 닉네임 로딩 중 표시
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ],
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
              print("Edit button pressed");
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_none_outlined,
              size: 25,
            ),
            onPressed: () {
              print("Notification button pressed");
            },
          ),
        ],
      ),


      drawer: Drawer(
        backgroundColor: neonskyblue1,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: black1,
              ),
              child: Text(
                  '$nickname',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.timer_sharp, color: black1),
              title: Text(
                '타이머',
                style: TextStyle(color: black1, fontSize: 18),
              ),
              tileColor: neonskyblue1,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TimerPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.event_outlined, color: black1),
              title: Text(
                '디데이',
                style: TextStyle(color: black1, fontSize: 18),
              ),
              tileColor: neonskyblue1,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DdayPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.check_box_outlined, color: black1),
              title: Text(
                '플래너',
                style: TextStyle(color: black1, fontSize: 18),
              ),
              tileColor: neonskyblue1,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlannerPage()),
                );
              },
            ),


            ListTile(
              leading: Icon(Icons.delete_outline, color: Colors.redAccent),
              title: Text(
                '탈퇴하기',
                style: TextStyle(color: Colors.redAccent, fontSize: 18),
              ),
              tileColor: neonskyblue1,
              onTap: () {
                _showConfirmationDialog(context);
              },
            ),
          ],
        ),
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
                    levelName ?? 'Loading...',
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
                          level != null && levelImages.containsKey(level)
                              ? levelImages[level]!  // level을 사용하여 이미지 경로 가져오기
                              : 'assets/images/hitthebook.jpg', // 기본 이미지
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
                        padding: EdgeInsets.only(left: 165.w),
                        child: Text(
                          '${point ?? 0}',  // point가 null일 경우 0 표시
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: neonskyblue1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 45.w),
                        child: Text(
                          '${maxPoint ?? 0}',  // maxPoint가 null일 경우 0 표시
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                      child: Stack(
                        children: [
                          // 배경: 전체 길이를 보여주는 배경
                          Container(
                            width: 268.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300], // 배경색
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          // 진행 상태: 실제 경험치 바가 채워지는 부분
                          Container(
                            width: (point != null && minPoint != null && maxPoint != null && maxPoint != minPoint)
                                ? 268.w * ((point! - minPoint!) / (maxPoint! - minPoint!)).clamp(0.0, 1.0) // 0~1 범위로 제한
                                : 0,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: neonskyblue1, // 경험치 진행 부분 색상
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(9),
                                bottomLeft: Radius.circular(9),
                              ),
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
                ],
              ),
            ),
          ],
        ),
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
