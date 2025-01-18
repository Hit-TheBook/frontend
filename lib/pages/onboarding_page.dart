import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/theme.dart'; // 색상 및 스타일 정의 파일
import 'package:project1/colors.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final PageController _timerController = PageController();
  final PageController _ddayController = PageController();
  final PageController _plannerController = PageController();

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentPage = 0; // 페이지 인디케이터 초기화
        });

        // 각 탭의 PageController가 연결된 경우만 페이지 초기화
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_tabController.index == 0 && _timerController.hasClients) {
            _timerController.jumpToPage(0);
          } else if (_tabController.index == 1 && _ddayController.hasClients) {
            _ddayController.jumpToPage(0);
          } else if (_tabController.index == 2 && _plannerController.hasClients) {
            _plannerController.jumpToPage(0);
          }
        });
      }
    });
  }


  @override
  void dispose() {
    _tabController.dispose();
    _timerController.dispose();
    _ddayController.dispose();
    _plannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '도움말',
            style: TextStyle(color: white1),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: neonskyblue1,
            labelColor: white1,
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(text: '타이머'),
              Tab(text: '디데이'),
              Tab(text: '플래너'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildSection(_timerController, _timerPages),
            _buildSection(_ddayController, _ddayPages),
            _buildSection(_plannerController, _plannerPages),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(PageController controller, List<PageData> pages) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: controller,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final page = pages[index];
              return Stack(
                children: [
                  // 배경 이미지 추가
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.2, // 배경 이미지 투명도 설정
                      child: Image.asset(
                        page.image,
                        fit: BoxFit.cover, // 화면 전체를 덮도록 설정
                      ),
                    ),
                  ),
                  // 콘텐츠
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            page.image,
                            width: 300.w, // 슬라이드 이미지의 가로 크기
                            height: 280.h, // 슬라이드 이미지의 세로 크기
                            fit: BoxFit.contain, // 이미지를 원본 비율 그대로 표시
                          ),
                        ),
                        SizedBox(height: 20.h),
                        _buildPageIndicator(pages.length),
                        SizedBox(height: 20.h),
                        Text(
                          page.title,
                          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          page.description,
                          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),

                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }



  Widget _buildPageIndicator(int pageCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: _currentPage == index ? 12.w : 8.w,
          height: _currentPage == index ? 12.w : 8.w,
          decoration: BoxDecoration(
            color: _currentPage == index ? neonskyblue1 : Colors.grey,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

class PageData {
  final String title;
  final String description;
  final String image;

  PageData({required this.title, required this.description, required this.image});
}

// 데이터 정의
final List<PageData> _timerPages = [
  PageData(
    title: '타이머',
    description: '오늘 공부한 총 시간, 획득한 총 점수, 과목별 공부 시간, 과목별 획득한 점수를 확인해보세요.',
    image: 'assets/images/timerpage.png',
  ),
  PageData(
    title: '통계 보기',
    description: '일간,주간 버튼을 선택하고 달력을 이용해 해당 날짜의 공부 시간을 확인해보세요',
    image: 'assets/images/timergraph.png',
  ),
  PageData(
    title: '과목별 통계 보기',
    description: '일간,주간 버튼을 선택하고 달력을 이용해 해당 날짜의 공부 시간, 과목별 공부 시간을 확인해보세요.',
    image: 'assets/images/subjecttimer.png',
  ),
];

final List<PageData> _ddayPages = [
  PageData(
    title: '디데이 관리',
    description: '중요한 날을 놓치지 않도록 디데이를 추가하고 대표 디데이로 설정해보세요.',
    image: 'assets/images/ddaypage.png',
  ),
  PageData(
    title: '디데이 추가',
    description: '디데이를 추가해보세요.',
    image: 'assets/images/ddayadd.png',
  ),
];

final List<PageData> _plannerPages = [
  PageData(
    title: '플래너',
    description: '오늘의 총평, 달력을 이용해 날짜 선택,공부,일정으로 나눠 계획을 체계적으로 관리해보세요.',
    image: 'assets/images/plannerpage.png',
  ),
  PageData(
    title: '피드백 체크',
    description: '계획의 피드백을 편리하게 관리하기',
    image: 'assets/images/plannerfeedback.png',
  ),
  PageData(
    title: '원시간표',
    description: '여러가지 계획들을 원시간표로 알기쉽게 한눈에 확인하기',
    image: 'assets/images/timecirclepage.png',
  ),
  PageData(
    title: '플랜 추가하기',
    description: '여러가지 계획들을 공부,일정으로 나눠 체계적으로 관리하기',
    image: 'assets/images/planneradd.png',
  ),
];
