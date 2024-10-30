import 'package:flutter/material.dart';
import 'package:project1/pages/study_page.dart';
import 'package:project1/pages/test_page.dart';
import 'package:project1/widgets/bottom_nav_bar.dart';
import 'package:project1/pages/main_page.dart'; // MainPage 임포트

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var _index = 0;

  final List<Widget> _pages = [
    const MainPage(),
    const StudyPage(),
    const TestPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _index,
        onItemTapped: (value) {
          setState(() {
            _index = value;
          });
        },
      ),
    );
  }
}
