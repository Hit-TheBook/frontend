import 'package:flutter/material.dart';
import 'package:project1/colors.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project1/pages/main_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project1/pages/register_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project1/theme.dart'; // Import your theme file

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter의 초기화 보장
  await dotenv.load();
  await initializeDateFormatting('ko_KR'); // 'ko_KR' 로케일 데이터 초기화
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme, // Use the custom theme from theme.dart
      home: const SplashScreen(),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: neonskyblue1, // 배경색
                foregroundColor: black1, // 텍스트 색
              ),
              child: const Text('로그인'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              },
            ),
            const SizedBox(height: 20), // 로그인 버튼과 시작하기 버튼 사이의 간격
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: neonskyblue1, // 배경색
                foregroundColor: black1, // 텍스트 색
              ),
              child: const Text('시작하기'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
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
      splash: Lottie.asset('assets/study.json'),
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
