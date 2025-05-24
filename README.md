# SmartFlow 📊

**소상공인을 위한 간편한 경영 솔루션**

SmartFlow는 OCR 기술을 활용하여 영수증을 사진으로 촬영하면 자동으로 매출/매입 데이터를 디지털화하고 분석해주는 서비스입니다.

## 🚀 프로젝트 개요

기존의 복잡한 경영 관리 플랫폼의 한계를 극복하고, 사진 촬영 한 번만으로 간편하게 매출/매입을 관리할 수 있는 솔루션을 제공합니다.

### 주요 기능
- 📸 **OCR 영수증 인식**: Google Cloud Vision API를 활용한 자동 영수증 데이터 추출
- 📊 **다기간 분석**: 일간/주간/월간/연간 매출 분석 및 시각화
- 📈 **인사이트 제공**: Bar Chart, Line Chart, Pie Chart를 통한 직관적인 데이터 시각화
- 🔒 **보안**: Google OAuth를 통한 안전한 인증
- 📱 **크로스플랫폼**: Flutter 기반 웹/모바일 지원

## 🛠️ 기술 스택

### Backend
- **Framework**: FastAPI (Python)
- **Database**: PostgreSQL
- **OCR**: Google Cloud Vision API
- **Authentication**: Google OAuth
- **Storage**: Google Cloud Storage

### Frontend
- **Framework**: Flutter
- **State Management**: Provider
- **Charts**: fl_chart
- **UI**: Material Design

### Infrastructure
- **Cloud**: Google Cloud Platform
- **Project ID**: smartflow-460806

## 📦 설치 및 실행

### 사전 요구사항
- Python 3.11+
- Flutter SDK
- PostgreSQL
- Google Cloud Project 설정

### Backend 설정

1. 가상환경 생성 및 활성화
```bash
cd backend
python -m venv venv
source venv/bin/activate  # macOS/Linux
# 또는 venv\Scripts\activate  # Windows
```

2. 의존성 설치
```bash
pip install -r requirements.txt
```

3. 환경 변수 설정
```bash
# backend/.env 파일 생성
DATABASE_URL=postgresql://username:password@localhost/smartflow
GOOGLE_APPLICATION_CREDENTIALS=path/to/credentials.json
```

4. 서버 실행
```bash
cd app
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Frontend 설정

1. 의존성 설치
```bash
cd frontend
flutter pub get
```

2. 웹 실행
```bash
flutter run -d web-server --web-port 8080
```

## 🏗️ 프로젝트 구조

```
SmartFlow/
├── backend/
│   ├── app/
│   │   ├── api/              # API 엔드포인트
│   │   ├── core/             # 핵심 설정
│   │   ├── models/           # 데이터베이스 모델
│   │   ├── schemas/          # Pydantic 스키마
│   │   ├── services/         # 비즈니스 로직
│   │   └── main.py           # FastAPI 앱
│   ├── ocr/                  # OCR 서비스
│   ├── tests/                # 테스트
│   └── requirements.txt      # Python 의존성
├── frontend/
│   ├── lib/
│   │   ├── models/           # 데이터 모델
│   │   ├── providers/        # 상태 관리
│   │   ├── screens/          # UI 화면
│   │   ├── services/         # API 서비스
│   │   └── main.dart         # Flutter 앱
│   └── pubspec.yaml          # Flutter 의존성
└── docker/                   # Docker 설정
```

## 📊 주요 화면

### 일간 분석
- 오늘의 영수증 내역
- 매출/지출 요약
- 실시간 업데이트

### 주간 분석
- 일별 매출 Bar Chart
- 주요 인사이트 제공
- 전주 대비 성장률

### 월간 분석
- 주별 Line Chart
- 카테고리별 Pie Chart
- 월간 리포트

### 연간 분석
- 월별 Bar Chart
- 계절별 분석
- 성과 리포트
- 2025년 목표 설정

## 🔧 개발 환경

### API 문서
- FastAPI 자동 생성 문서: http://localhost:8000/docs
- ReDoc 문서: http://localhost:8000/redoc

### 테스트
```bash
# Backend 테스트
cd backend
python -m pytest

# Frontend 테스트
cd frontend
flutter test
```

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 라이선스

이 프로젝트는 MIT 라이선스를 따릅니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

## 👥 팀

**Smart Flow Team**
- 대표: 최근우
- 개발: AI Assistant

## 📞 연락처

프로젝트에 대한 문의사항이나 제안사항이 있으시면 언제든지 연락해주세요.

---

*소상공인의 경영을 더 스마트하게, SmartFlow와 함께하세요! 🚀* 