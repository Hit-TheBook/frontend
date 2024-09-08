import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'mainpage.dart';
import 'studypage.dart';
import 'testpage.dart';

class App extends StatefulWidget {
  const App({super.key});

@override
State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var _index = 0;

  final List _pages = [
    const MainPage(),
    const StudyPage(),
    const TestPage(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('bottomNavigation'),

      ),

      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) {
          setState(() {
            _index = value;
            if (kDebugMode) {
              print(_index);
            }
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'main'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded), label: 'study'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'test'),
        ],),
    );
  }
}