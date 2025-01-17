import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/theme.dart';  // 색상 및 스타일 정의 파일
import 'package:project1/colors.dart';

import '../widgets/custom_appbar.dart';
import 'home_screen.dart';  // 색상 정의 파일

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: '도움말',
          showBackButton: true,
          onBackPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(initialIndex: 1), // StudyPage가 보이도록 설정
              ),
                  (route) => false, // 모든 이전 페이지 제거
            );
          },
        ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: <Widget>[
            // 슬라이쇼 부분
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: <Widget>[
                  OnboardingSlide(
                    title: '첫 번째 기능',
                    description: '여기에 첫 번째 기능의 설명이 들어갑니다.',
                    image: 'assets/images/slide1.png', // 이미지 경로를 사용
                  ),
                  OnboardingSlide(
                    title: '두 번째 기능',
                    description: '두 번째 기능의 설명이 들어갑니다.',
                    image: 'assets/images/slide2.png', // 이미지 경로를 사용
                  ),
                  OnboardingSlide(
                    title: '세 번째 기능',
                    description: '세 번째 기능의 설명이 들어갑니다.',
                    image: 'assets/images/slide3.png', // 이미지 경로를 사용
                  ),
                ],
              ),
            ),
            // 페이지 인디케이터
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  height: 8.h,
                  width: 8.w,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? neonskyblue1 : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
            SizedBox(height: 20.h),
            // 완료 버튼
            ElevatedButton(
              onPressed: () {
                // 완료 버튼 클릭 시 원하는 동작 추가 (예: 홈 화면으로 이동)
                Navigator.pop(context);
              },
              child: Text(
                '완료',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: neonskyblue1, // 버튼 배경색
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 50.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class OnboardingSlide extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const OnboardingSlide({
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(image, width: 200.w, height: 200.h), // 이미지
        SizedBox(height: 40.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: white1,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          description,
          style: TextStyle(
            fontSize: 16.sp,
            color: white1,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
