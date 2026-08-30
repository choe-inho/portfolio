# [Iconoding Portfolio]

Flutter Web + Firebase 기반의 서버리스 포트폴리오 웹사이트  
실제 서비스 운영을 가정하여 인증, 데이터 구조, 배포까지 전 과정을 구현했습니다.

---

## 🔗 Demo
- Web: https://[your-project].web.app
- GitHub: https://github.com/choe-inho/portfolio

---

## 🧭 Overview
이 프로젝트는 **서버 관리 없이도 확장 가능한 웹 서비스 구조**를 목표로 설계되었습니다.

- 단일 코드베이스(Flutter)로 Web 서비스 구현
- Firebase 서버리스 아키텍처 활용
- 실제 배포 및 운영을 고려한 구조 설계

---

## 🛠 Tech Stack

### Frontend
- **Flutter (Web)**
    - 단일 코드베이스로 Web 확장
    - UI 컴포넌트 재사용성 극대화
- **State Management**
    - GetX (경량 구조, 빠른 상태 반영)

### Backend (Serverless)
- **Firebase Authentication**
    - 관리자 로그인
- **Cloud Firestore**
    - 실시간 데이터베이스
    - NoSQL 구조 설계
    - 파일형, 사용자 규칙 설정
- **Firebase Storage**
    - 프로젝트 이미지 및 자기소개 사진 저장
    - 접근 규칙 설정

---

## 🏗 Architecture

- **일반 사용자**
    Flutter Web
    ↓
    Cloud Firestore (READ)
    ↓
    UI State Update
- **관리자**
    Flutter Web
    ↓
    Firebase Authentication
    ↓
    Cloud Firestore (WRITE)
    ↓
    UI State Update

### Project Structure
lib/
├─ util/ # 공통 설정 (라우팅, 애니메이션, 테마, 헬퍼, 컨피그)
├─ service/ # 이미지 업로드
├─ controllers/ # 상태 관리
├─ models/ # Firestore 데이터 모델
└─ screen/ # UI 컴포넌트

---

## ✨ Key Features

- **Authentication**
    - Firebase Auth 기반 로그인
    - 인증 상태에 따른 라우팅 제한

- **Data Management**
    - Firestore 실시간 데이터 바인딩
    - 데이터 변경 시 UI 자동 반영

- **Serverless Architecture**
    - 별도 서버 없이 서비스 운영 가능
    - 유지보수 비용 최소화

---

## 🚀 Deployment

- **Git Pages** 사용
- 로컬 빌드 후 배포
- Git Action을 이용한 웹 업데이트 자동화 push -> 자동 빌드

### 🤔 Trouble Shooting

- Flutter Web 초기 로딩 속도
  - index.html 애니메이션을 통한 지연 체감 극소화
  - 이미지 cachedNetwork 라이브러리를 통한 최적화
- Firestore 읽기 비용
  - 일회성 fetch 적용
- ScreenUtil의 한계 -> 모바일 최적화가 안됨
  - context를 이용한 강제 최적화