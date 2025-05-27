# 헬스장 웹사이트

이 프로젝트는 헬스장 웹사이트의 프론트엔드와 백엔드를 구현한 것입니다. GitHub Pages를 사용하여 프론트엔드를 호스팅하고, Supabase를 사용하여 백엔드 서비스를 제공합니다.

## 기술 스택

- 프론트엔드: HTML, CSS, JavaScript
- 백엔드: Supabase (PostgreSQL, Authentication, Storage)
- 배포: GitHub Pages

## 주요 기능

- 사용자 인증 (회원가입/로그인)
- 수업 예약 시스템
- 트레이너 정보 및 리뷰
- 문의하기
- 반응형 디자인

## 시작하기

1. 저장소 클론
```bash
git clone [repository-url]
cd new_project
```

2. Supabase 설정
- Supabase 프로젝트 생성
- `schema.sql` 파일의 내용을 Supabase SQL 에디터에서 실행
- 프로젝트 URL과 anon key를 `js/main.js`에 설정

3. 로컬에서 실행
```bash
# 간단한 HTTP 서버 실행
python -m http.server 8000
```

4. GitHub Pages 배포
- GitHub 저장소 생성
- main 브랜치에 코드 푸시
- GitHub Actions가 자동으로 배포를 수행

## 프로젝트 구조

```
new_project/
├── index.html          # 메인 페이지
├── styles/            # CSS 파일
├── js/               # JavaScript 파일
├── images/          # 이미지 파일
├── supabase/       # Supabase 설정
└── .github/        # GitHub Actions 설정
```

## 라이선스

MIT License 