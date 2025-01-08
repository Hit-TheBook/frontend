import 'package:project1/pages/privacy_consent_page.dart';
import 'package:project1/pages/register_page.dart';
import 'package:project1/pages/terms_of_use_page.dart';
import 'package:project1/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // flutter_screenutil 추가
import 'package:project1/colors.dart'; // 앱에서 사용하는 색상 정의된 곳

class AgreementPage extends StatefulWidget {
  const AgreementPage({Key? key}) : super(key: key);

  @override
  _AgreementPageState createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  bool _agreeAll = false;
  bool _agreeTerms = false;
  bool _agreePrivacy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '약관 동의',
        showBackButton: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0.w), // 화면 크기에 맞게 패딩 크기 조정
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Hit The Book 이용약관" 텍스트
            Align(
              alignment: Alignment.centerLeft, // 왼쪽 정렬
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                children: [
                  // 힛더북 텍스트
                  Text(
                    '힛더북',
                    style: TextStyle(
                      fontSize: 24.sp, // 화면 크기에 맞게 폰트 크기 조정
                      color: neonskyblue1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3.h), // 텍스트 간의 간격
                  // 이용약관 텍스트
                  Text(
                    '이용약관',
                    style: TextStyle(
                      fontSize: 24.sp, // 화면 크기에 맞게 폰트 크기 조정
                      color: neonskyblue1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),


            SizedBox(height: 130.h), // 화면 크기에 맞게 높이 조정

            // 체크박스들을 하나의 네모난 상자에 담기
        Align(
          alignment: Alignment.center,
          child: Container(
              decoration: BoxDecoration(
                color: gray1, // 컨테이너 배경 색상
                borderRadius: BorderRadius.circular(5.0.r), // 화면 크기에 맞게 테두리 둥글기 조정
              ),
              padding: EdgeInsets.symmetric(vertical: 3.0.w, horizontal: 5.0.w),
              // 화면 크기에 맞게 패딩 크기 조정
              height: 160.h, // 컨테이너 높이 지정
              width: 290.w, // 컨테이너 너비 지정
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 전체 동의 체크박스
                  CheckboxListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "모두 동의합니다.",
                          style: TextStyle(color: Colors.white, fontSize: 14.sp,fontWeight: FontWeight.bold), // 텍스트 색상 흰색으로
                        ),
                      ],
                    ),
                    value: _agreeAll,
                    onChanged: (bool? value) {
                      setState(() {
                        _agreeAll = value ?? false;
                        // 전체 동의 체크 시 다른 체크박스도 동기화
                        _agreeTerms = _agreeAll;
                        _agreePrivacy = _agreeAll;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading, // 체크박스를 왼쪽에 배치
                    activeColor: neonskyblue1, // 체크박스 색상 설정
                    side: BorderSide(
                      color: _agreeAll ? Colors.transparent : Colors.white, // 비활성화일 때 흰색 테두리
                      width: 1.5, // 테두리 두께
                    ),
                  ),
                  Divider(color: white1, thickness: 2),
                  // 이용약관 동의 체크박스
                  CheckboxListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "[필수] 이용약관 동의",
                          style: TextStyle(color: Colors.white, fontSize: 14.sp,fontWeight: FontWeight.bold),
                        ),

                        IconButton(
                          icon: Icon(Icons.chevron_right, color: Colors.white),
                          onPressed: () {
                            //개인정보 동의 페이지로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TermsOfUsePage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    value: _agreeTerms,
                    onChanged: (bool? value) {
                      setState(() {
                        _agreeTerms = value ?? false;
                        _agreeAll = _agreeTerms && _agreePrivacy;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: neonskyblue1,
                    side: BorderSide(
                      color: _agreeTerms ? Colors.transparent : Colors.white, // 비활성화일 때 흰색 테두리
                      width: 1.5, // 테두리 두께
                    ),
                  ),
                  // 개인정보 동의 체크박스
                  CheckboxListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "[필수] 개인정보 동의",
                          style: TextStyle(color: Colors.white, fontSize: 14.sp,fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.chevron_right, color: Colors.white),
                          onPressed: () {
                            //개인정보 동의 페이지로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PrivacyConsentPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    value: _agreePrivacy,
                    onChanged: (bool? value) {
                      setState(() {
                        _agreePrivacy = value ?? false;
                        _agreeAll = _agreeTerms && _agreePrivacy;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: neonskyblue1,
                    side: BorderSide(
                      color:  _agreePrivacy ? Colors.transparent : Colors.white, // 비활성화일 때 흰색 테두리
                      width: 1.5, // 테두리 두께
                    ),
                  ),
                ],
              ),
            ),
        ),
            SizedBox(height:80.h), // 화면 크기에 맞게 높이 조정

            // 동의 후 버튼
            Center(
              child: SizedBox(
                width: 290.w,
                height: 40.h,
                child: ElevatedButton(
                  onPressed: (_agreeTerms && _agreePrivacy)
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
                      ),
                    );
                  }
                      : null, // 비활성화 상태로 유지
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _agreeTerms && _agreePrivacy
                        ? neonskyblue1 // 활성화 상태
                        : Colors.grey, // 비활성화 상태
                    disabledBackgroundColor: Colors.grey, // 비활성화된 배경 색상 설정
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.r), // 버튼 모서리를 둥글게
                    ),
                  ),
                  child: Text(
                    '동의 하기',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: _agreeTerms && _agreePrivacy
                          ? black1 // 활성화 시 텍스트 색상
                          : white1, // 비활성화 시 텍스트 색상
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}