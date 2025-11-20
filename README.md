📚 Hit The Book

“공부를 게임처럼.”
Hit The Book은 공부 루틴을 만들고 유지하도록 돕는 자기계발 타이머 & 학습 관리 앱입니다.
집중 타이머, D-Day, 플래너, 달력, 통계를 기반으로 학습 루틴을 시각적으로 관리할 수 있습니다.


핵심 기능 (Features)

⏱ 집중 타이머
	•	스탑워치 기반 학습 타이머
	•	일/주 단위 누적시간 기록
	•	화면 꺼짐 방지

📆 스케줄·플래너
	•	D-Day
	•	데일리 / 위클리 플래너
	•	달력 기반 일정 확인

📊 학습 통계
	•	일/주/월 단위 공부량 그래프
	•	경험치(Exp) 시스템
	•	누적 레벨 업 구조

🎮 게이미피케이션 요소
	•	사용자 레벨 시스템
	•	경험치(Exp)
	•	아이콘·엠블럼 보상

🖼 커스텀 UI & 애니메이션
	•	스플래시 → 온보딩 애니메이션
	•	타이머/플래너 인터랙션 효과

🛠 Tech Stack (Frontend – Flutter)

Framework
	•	Flutter 3.x
	•	Dart (Null-safety)
UI / UX
	•	google_fonts – 커스텀 폰트
	•	flutter_feather_icons – 아이콘
	•	animated_splash_screen – 스플래시 애니메이션
	•	page_transition – 화면 전환 효과
	•	flutter_screenutil – 반응형 레이아웃
	•	table_calendar – 캘린더 UI
	•	Custom UI animations (Timer, D-Day 등)
State Management
	•	ChangeNotifier + setState 기반 구조 Networking / Security
	•	http – REST API
	•	JWT 기반 인증
	•	flutter_dotenv – .env 환경변수 관리
	•	flutter_secure_storage – 토큰 암호화 저장
	•	encrypt – 민감 데이터 암호화
Local Storage
	•	shared_preferences
Time / Utility
	•	stop_watch_timer – 집중 타이머
	•	intl – 날짜/시간 처리
	•	wakelock_plus – 화면 꺼짐 방지
	•	win32 – Windows 유틸리티
