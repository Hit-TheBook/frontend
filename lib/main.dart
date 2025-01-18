import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project1/colors.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project1/pages/home_screen.dart';
import 'package:project1/pages/main_page.dart';
import 'package:project1/pages/register_page.dart';
import 'package:project1/pages/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project1/pages/study_page.dart';
import 'package:project1/theme.dart'; // Import your theme file
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/pages/agreement_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter의 초기화 보장
  // 현재 작업 디렉토리 출력
  print('--- Debugging Env File ---');
  print('Current working directory: ${Directory.current.path}');

  // .env 파일 존재 여부 확인
  final envFile = File('.env');
  if (await envFile.exists()) {
    print('.env file found at: ${envFile.path}');
  } else {
    print('.env file NOT found at: ${envFile.path}');
  }

  try {
    // .env 파일 로드 시도
    await dotenv.load(fileName: ".env");
    print('.env file successfully loaded');
  } catch (e) {
    print('Error loading .env file: $e');
  }
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
          navigatorKey: navigatorKey,
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
            // 텍스트 추가
            Align(
              alignment: Alignment.centerLeft, // 좌측 정렬
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w), // 좌우 패딩 추가
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 35.sp, // 기본 폰트 크기
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // 기본 색상
                    ),
                    children: [
                      const TextSpan(text: "공부를 게임처럼\n"),
                      TextSpan(
                        text: "\"힛더북\"",
                        style: TextStyle(
                          fontSize: 35.sp, // "힛더북"은 35 크기 유지
                          fontWeight: FontWeight.bold,
                          color: neonskyblue1, // "힛더북" 색상 변경
                        ),
                      ),
                      TextSpan(
                        text: "에선 공부가 즐겁다.",
                        style: TextStyle(
                          fontSize: 22.sp, // "에선 공부가 즐겁다." 부분 크기 변경
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),
            // 로고 이미지 추가
            Image.asset(
              'assets/images/logo.png', // 로고 이미지 경로
              height: 250.h,
              width: 250.w,// 원하는 높이 설정
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
                fixedSize: Size(310.w, 35.h), // 버튼 크기 설정
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // 모서리 둥글기 설정
                ),
              ),
              child: Text(
                '시작하기',
                style: TextStyle(fontSize: 16.sp), // 폰트 크기 설정
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AgreementPage()),
                );
              },
            ),
            SizedBox(height: 20.h), // 로그인 버튼과 시작하기 버튼 사이의 간격
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: neonskyblue1, // 배경색
                foregroundColor: black1, // 텍스트 색
                fixedSize: Size(310.w, 35.h), // 버튼 크기 설정
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // 모서리 둥글기 설정
                ),
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

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _startSplashSequence();
  }

  // 스플래시 화면의 애니메이션과 로직을 동기화
  Future<void> _startSplashSequence() async {
    // 스플래시 화면 표시 시간 설정 (7초)
    const splashDuration = Duration(seconds: 7);

    // 스플래시 애니메이션이 완료될 때까지 대기
    await Future.delayed(splashDuration);

    // 이후 로그인 상태를 확인하고 페이지 이동
    await _checkLoginStatus();
  }

  // 로그인 상태 확인 후 페이지 이동
  Future<void> _checkLoginStatus() async {
    String? refreshToken = await storage.read(key: 'refreshToken');

    // 화면 전환 전에 mounted 상태 확인
    if (!mounted) return;

    if (refreshToken != null && refreshToken.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen(initialIndex: 0)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedSplashScreen에서 nextScreen을 제거하고 화면 전환을 수동 처리
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: Image.asset(
          'assets/images/splash.gif', // 스플래시 이미지 또는 GIF
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.cyanAccent,
        splashIconSize: double.infinity,
        duration: 7000, // 스플래시 애니메이션 지속 시간 (7초)
        splashTransition: SplashTransition.fadeTransition,
        animationDuration: const Duration(seconds: 7),
        nextScreen: Container(), // 화면 전환은 initState에서 처리하므로 빈 화면 유지
      ),
    );
  }
}
