import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/widgets/custom_appbar.dart';
import 'package:project1/colors.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '이용약관',
        showBackButton: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w), // 화면 크기에 맞게 패딩 조정
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 약관 제목 ---
              Center(
                child: Text(
                  'HitTheBook 이용약관',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: white1,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // --- 약관 본문 ---
              _buildSectionTitle('제 1 장 총칙'),
              _buildSubSection('제1조 (목적)'),
              _buildContent(
                  '이 약관은 HitTheBook이 제공하는 HitTheBook 서비스(이하 "서비스"라 합니다)의 이용조건 및 절차, 권리, 의무, 책임사항 등을 규정함을 목적으로 합니다.'),

              _buildSubSection('제2조 (정의)'),
              _buildContent('1. "서비스"란 HitTheBook서비스에서 제공하는 타이머, 플래너, 디데이 기능 및 '
                  '레벨업과 엠블럼 획득 기능 등을 포함한 스터디 보조 애플리케이션을 의미합니다.'),
              _buildContent('2. "이용자"란 이 약관에 따라 HitTheBook서비스가 제공하는 서비스를 받는 회원을 의미합니다.'),
              _buildContent('3. "회원"이란 서비스를 이용하기 위해 HitTheBook서비스가 정한 절차에 따라 가입하여 '
                  'HitTheBook서비스와 이용계약을 체결한 자를 말합니다.'),
              _buildContent('4. "레벨업" 및 "엠블럼"이란 서비스 이용을 통해 특정 조건을 충족할 경우 제공되는 보상 요소를 의미합니다.'),

              _buildSubSection('제3조 (약관의 효력과 변경)'),
              _buildContent('1. 이 약관은 서비스를 이용하고자 하는 모든 이용자에게 효력을 발생합니다.'),
              _buildContent('2. HitTheBook서비스는 약관을 개정할 경우 적용일자 및 개정 사유를 명시하여 '
                  '서비스 내 공지사항을 통해 사전에 공지합니다.'),

              SizedBox(height: 20.h),

              _buildSectionTitle('제 2 장 서비스 이용계약'),
              _buildSubSection('제4조 (이용계약의 성립)'),
              _buildContent('1. 이용계약은 이용자가 약관의 내용에 동의하고, HitTheBook서비스가 정한 절차에 따라 '
                  '회원가입을 완료함으로써 성립합니다.'),

              _buildSubSection('제5조 (회원정보의 수집 및 보호)'),
              _buildContent('1. HitTheBook서비스는 서비스 제공을 위해 이용자의 이메일 주소를 수집하며, '
                  '이는 회원가입 및 본인확인 목적으로만 사용됩니다.'),
              _buildContent('2. 수집된 이메일은 회원 탈퇴 시 즉시 파기되며, 동일한 이메일로 재가입이 가능합니다.'),
              _buildContent('3. HitTheBook서비스는 이용자의 개인정보를 관련 법령에 따라 보호하며, '
                  '개인정보 보호정책에 따라 처리합니다.'),
              _buildContent('4. HitTheBook서비스는 이용자의 개인정보 유출, 분실, 도난에 대해 보안 조치를 취하지만, '
                  '이용자의 귀책사유로 인한 개인정보 유출에 대해서는 책임을 지지 않습니다.'),

              SizedBox(height: 20.h),

              _buildSectionTitle('제 4 장 책임 제한 및 면책조항'),
              _buildSubSection('제10조 (HitTheBook서비스의 책임 제한)'),
              _buildContent('1. HitTheBook서비스는 천재지변, 비상사태 등 불가항력으로 서비스를 제공할 수 없는 경우 책임을 지지 않습니다.'),
              _buildContent('2. HitTheBook서비스는 이용자의 귀책사유로 인한 서비스 이용 장애에 대해 책임을 지지 않습니다.'),

              SizedBox(height: 20.h),

              _buildSectionTitle('제 5 장 기타'),
              _buildContent('1. 서비스 이용과 관련하여 HitTheBook서비스와 이용자 간에 발생한 분쟁에 관한 소송은 '
                  '민사소송법 등 관련 법령에서 정한 절차에 따른 법원을 관할법원으로 합니다.'),
              _buildContent('2. HitTheBook서비스와 이용자 간에 제기된 소송에는 대한민국 법을 적용합니다.'),

              SizedBox(height: 30.h),

              // 부칙
              Center(
                child: Text(
                  '부칙',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: white1,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              _buildContent('- 이 약관은 2024년 12월 17일에 공지되었습니다.'),
              _buildContent('- 2024년 12월 17일부터 가입한 이용자에게는 즉시 본 약관이 적용됩니다.'),

              SizedBox(height: 50.h), // 하단 여백 추가
            ],
          ),
        ),
      ),
    );
  }

  // 제목 스타일
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: white1,
        ),
      ),
    );
  }

  // 서브 섹션 제목 스타일
  Widget _buildSubSection(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 5.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // 본문 텍스트 스타일
  Widget _buildContent(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.white,
        ),
      ),
    );
  }
}
