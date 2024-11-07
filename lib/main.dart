import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project1/colors.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project1/pages/main_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project1/pages/register_page.dart';
import 'package:project1/pages/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project1/theme.dart'; // Import your theme file
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter의 초기화 보장

  await initializeDateFormatting('ko_KR'); // 'ko_KR' 로케일 데이터 초기화
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 640), // 피그마 기준 해상도
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: appTheme, // Use the custom theme from theme.dart
          home: const SplashScreen(),
          // 지역화 설정 추가
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate, // Material Widgets의 지역화
            GlobalWidgetsLocalizations.delegate, // Flutter Widgets의 지역화
            GlobalCupertinoLocalizations.delegate, // Cupertino Widgets의 지역화
          ],
          supportedLocales: [
            Locale('en', 'US'), // 영어 (미국)
            Locale('ko', 'KR'), // 한국어 (한국)
          ],
        );
      },
    );
  }
}

// 로그인 화면
class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black1,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로고 이미지 추가
            Image.asset(
              'assets/images/logo.png', // 로고 이미지 경로
              height: 300.h,
              width: 300.w,// 원하는 높이 설정
            ),
            SizedBox(height: 20.h),
            /*ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: neonskyblue1, // 배경색
                foregroundColor: black1, // 텍스트 색
              ),
              child: Text(
                '메인',
                style: TextStyle(fontSize: 16.sp), // 폰트 크기 설정
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              },
            ),*/
            SizedBox(height: 20.h), // 로그인 버튼과 시작하기 버튼 사이의 간격
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: neonskyblue1, // 배경색
                foregroundColor: black1, // 텍스트 색
              ),
              child: Text(
                '회원가입',
                style: TextStyle(fontSize: 16.sp), // 폰트 크기 설정
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
            ),
            SizedBox(height: 20.h), // 로그인 버튼과 시작하기 버튼 사이의 간격
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: neonskyblue1, // 배경색
                foregroundColor: black1, // 텍스트 색
              ),
              child: Text(
                '로그인',
                style: TextStyle(fontSize: 16.sp), // 폰트 크기 설정
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 메인 화면
class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메인화면'),
        centerTitle: true,
      ),
    );
  }
}

// 스플래쉬 화면 시작
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset('assets/images/hitthebook.jpg'),
      backgroundColor: Colors.cyanAccent,
      nextScreen: const Login(),
      splashIconSize: double.infinity,
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(seconds: 2),
      pageTransitionType: PageTransitionType.leftToRight,
    );
  }
}
// 스플래쉬 끝
