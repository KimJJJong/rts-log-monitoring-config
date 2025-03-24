# 🎮 RTS Log Monitoring Config

게임 서버의 JSON 로그를 수집하고 Kibana로 시각화하기 위한 통합 설정 템플릿입니다.  
Filebeat → Elasticsearch → Kibana 구조를 사용하며, 팀원들은 Kibana를 통해 실시간으로 로그를 열람하고 필터링할 수 있습니다.

---

## 📦 구성 요소

| 구성 요소      | 설명 |
|----------------|------|
| `filebeat.yml` | 로그 수집기 설정 파일 |
| `create_log_reader_user.ps1` | 읽기 전용 사용자 생성 스크립트 |
| `sample_logs/Log_sample.json` | 로그 포맷 테스트용 샘플 |
| `docs/setup_guide_ko.md` | 팀원용 Kibana 접속 가이드 (한글) |

---

## 🔧 주요 기능

- `.json` 로그 라인 자동 수집
- `Timestamp` 필드를 기준으로 정렬
- `@timestamp` 자동 매핑
- Kibana에서 시각화/검색
- 팀원용 **읽기 전용 계정** 생성 스크립트 포함

---

## 🚀 사용법 요약

1. `filebeat.yml`을 메인 서버에 복사
2. Filebeat 실행:
   ```bash
   filebeat.exe -e -c filebeat.yml
PowerShell로 읽기 전용 사용자 생성:

bash
복사
편집
powershell -ExecutionPolicy Bypass -File create_log_reader_user.ps1
팀원은 브라우저에서 Kibana 접속:

cpp
복사
편집
http://<메인 서버 IP>:5601
👤 기본 로그인 계정 (읽기 전용)
ID: viewer_user

PW: mypassword