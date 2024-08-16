import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)), // 왼쪽 메뉴버튼
        title: const Text('Test Page for JIRA'), // 타이틀
        centerTitle: true, // 타이틀 텍스트 위치
        shape: const Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        actions: [
          // 우측의 액션 버튼들
          IconButton(onPressed: () {}, icon: const Icon(FeatherIcons.watch)),
          IconButton(onPressed: () {}, icon: const Icon(FeatherIcons.bell)),
          IconButton(onPressed: () {}, icon: const Icon(FeatherIcons.share2)),
        ],
      ),
      body: const Center(
        child: Text('test'),
      ),
    );
  }
}
