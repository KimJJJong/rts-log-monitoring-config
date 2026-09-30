# 🎮 RTS Log Monitoring Config / RTS 로그 모니터링 설정 / RTSログ監視設定

**한국어** | [日本語](README.ja.md) | [English](README.en.md)

게임 서버가 출력하는 JSON Lines 로그를 Filebeat로 수집하고, Elasticsearch에 저장해 Kibana에서 검색·시각화하기 위한 설정 모음입니다.

`Filebeat → Elasticsearch → Kibana`

## 구성

| 경로 | 설명 |
|---|---|
| `filebeat.yml` | JSON 로그 수집과 Elasticsearch·Kibana 연결 설정 |
| `create_log_reader_user.ps1` | `gameserver-logs-*` 인덱스용 읽기 전용 역할과 사용자를 생성하는 PowerShell 스크립트 |
| `sample_logs/Log_sample.json` | 한 줄에 JSON 객체 하나를 기록한 샘플 로그 |
| `docs/setup_guide_ko.md` | 팀원용 Kibana 접속 가이드 |

## 주요 설정

- 수집 경로: `C:/RTS_Server/logs_json/*.json`
- 이벤트 시각: JSON의 `Timestamp` 필드를 `@timestamp`로 처리
- Elasticsearch 인덱스: `gameserver-logs-%{+yyyy.MM.dd}`
- Kibana 주소: `http://localhost:5601`
- 읽기 전용 역할: `log_reader`
- 읽기 전용 사용자: `viewer_user`

## 빠른 시작

### 1. Filebeat 실행

환경에 맞게 `filebeat.yml`의 로그 경로와 Elasticsearch·Kibana 주소를 확인한 뒤 실행합니다.

```powershell
filebeat.exe -e -c filebeat.yml
```

### 2. 읽기 전용 사용자 생성

`create_log_reader_user.ps1`은 Elasticsearch 관리자 계정으로 `log_reader` 역할과 `viewer_user` 사용자를 생성합니다.

실행 전에 스크립트의 관리자 비밀번호와 `viewer_user` 비밀번호를 로컬 환경의 실제 값으로 교체하세요. 문서에서 사용하는 `change-me-password`는 예시 플레이스홀더이므로 실제 비밀번호로 사용하거나 저장소에 커밋하면 안 됩니다.

```powershell
powershell -ExecutionPolicy Bypass -File .\create_log_reader_user.ps1
```

### 3. Kibana 접속

브라우저에서 다음 주소로 접속합니다.

```text
http://<메인 서버 IP>:5601
```

- 사용자: `viewer_user`
- 비밀번호: 스크립트에서 설정한 값(예시: `change-me-password`)

### 4. Data View 생성

- Index pattern: `gameserver-logs-*`
- Timestamp field: `@timestamp`

### 5. 로그 검색

서버 시작 로그를 찾는 KQL 예시입니다.

```kql
Message.keyword: "[Server Start]"
```

Discover 표에는 `Timestamp`, `Source`, `Message`, `Level` 필드를 추가할 수 있습니다. 로그가 보이지 않으면 오른쪽 위 Time picker에서 조회 범위를 늘리세요.

## 보안 주의사항

현재 예시는 로컬 HTTP 주소를 기준으로 합니다. 외부 환경에서는 TLS, 네트워크 접근 제어, 강력한 비밀번호와 비밀정보 관리 방식을 별도로 적용하세요.
