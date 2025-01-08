import 'package:project1/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class PrivacyConsentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '이용약관',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HitTheBook은 개인정보보호법 등 관련 법령에 따라 이용자의 개인정보를 보호하고, 이와 관련된 고충을 신속하고 원활하게 처리할 수 있도록 다음과 같이 개인정보 처리방침을 수립·공개합니다.\n',
              style: TextStyle(fontSize: 16),
            ),
            _buildSection('제1조 (수집하는 개인정보 항목 및 수집 방법)',
                '1. **수집 항목**\n- 필수 항목: 이메일 주소\n\n'
                    '2. **수집 방법**\n- 회원가입 시 이용자가 직접 입력하는 방식으로 수집됩니다.'),
            _buildSection('제2조 (개인정보의 수집 및 이용 목적)',
                'HitTheBook서비스는 수집한 개인정보를 다음과 같은 목적으로 이용합니다:\n'
                    '1. 회원가입 및 서비스 제공: 이용자 식별 및 본인 확인\n'
                    '2. 서비스 운영: 타이머, 플래너, 디데이 기능 제공 및 레벨업/엠블럼 획득 등 서비스의 정상적인 운영\n'
                    '3. 고객 문의 응대: 이용자의 문의사항 처리 및 불만 처리'),
            _buildSection('제3조 (개인정보의 보유 및 이용 기간)',
                'HitTheBook서비스는 이용자의 개인정보를 회원 탈퇴 시까지 보유하며, 탈퇴 즉시 해당 정보를 파기합니다.'),
            _buildSection('제4조 (개인정보의 파기 절차 및 방법)',
                '1. **파기 절차**\n- 이용자가 회원 탈퇴를 요청하거나 개인정보 수집 및 이용 목적이 달성된 후에는 해당 개인정보를 즉시 파기합니다.\n\n'
                    '2. **파기 방법**\n- 전자적 파일: 복구 및 재생 불가능한 방법으로 삭제'),
            _buildSection('제5조 (개인정보의 제3자 제공)',
                'HitTheBook서비스는 이용자의 개인정보를 원칙적으로 제3자에게 제공하지 않습니다. 다만, 다음의 경우는 예외로 합니다:\n'
                    '1. 이용자가 사전에 동의한 경우\n'
                    '2. 법령에 의거하여 제공해야 할 의무가 발생한 경우'),
            _buildSection('제8조 (개인정보 보호 및 문의처)',
                '1. HitTheBook서비스는 이용자의 개인정보 보호를 위해 적절한 보안 조치를 취하며, 암호화 및 접근 통제를 통해 안전성을 확보합니다.\n'
                    '2. 개인정보와 관련된 문의는 아래 이메일을 통해 접수받습니다:\n'
                    '- 이메일: tobehi42@gmail.com'),
            SizedBox(height: 20),
            Text(
              '부칙\n',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('이 개인정보 처리방침은 관련 법령, HitTheBook서비스 정책에 따라 변경될 수 있으며, 변경 사항은 서비스 내 공지사항을 통해 사전 고지됩니다.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
