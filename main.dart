import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project1/mainpage.dart';
import 'package:intl/date_symbol_data_local.dart'; // 추가된 import


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter의 초기화 보장
  await initializeDateFormatting('ko_KR'); // 'ko_KR' 로케일 데이터 초기화
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

//로그인 화면
class Login extends StatelessWidget {
  const Login({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
backgroundColor: Colors.blue,
      body: Center(
        child: ElevatedButton(
          child: const Text('로그인'),
          onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage()));
          } ,
        ),
      )
    );
  }
}
//로그인 화면 끝

//메인 화면
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
// 메인화면 끝

//스플래쉬 화면시작
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset('assets/study.json'),

      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       SizedBox(
      //         width: MediaQuery.of(context).size.width * 0.6,
      //         height: MediaQuery.of(context).size.width * 0.6,
      //         child: Image.asset('assets/images/demo2.png'),
      //       ),
      //       const SizedBox(height: 20),
      //       const Text(
      //         'Study app',
      //         style: TextStyle(
      //           fontSize: 20,
      //           fontWeight: FontWeight.bold,
      //           color: Colors.white,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
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
//스플래쉬 끝
