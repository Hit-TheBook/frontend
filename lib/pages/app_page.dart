
import 'package:flutter/material.dart';
import 'package:project1/colors.dart';
import 'package:project1/widgets/custom_appbar.dart';
import 'package:project1/pages/study_page.dart';
import 'package:project1/pages/test_page.dart';

import 'main_page.dart'; // CustomAppBar 파일을 임포트

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
      appBar: CustomAppBar(
        title: _getAppBarTitle(_index),
      ),
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) {
          setState(() {
            _index = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'main'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded), label: 'study'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'test'),
        ],
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Main Page';
      case 1:
        return 'Study Page';
      case 2:
        return 'Test Page';
      default:
        return 'App';
    }
  }
}
