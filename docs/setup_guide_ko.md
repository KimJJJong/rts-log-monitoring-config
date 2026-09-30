# 📘 RTS 게임 서버 로그 확인 가이드 (팀원용)

이 문서는 팀원들이 Kibana에서 로그를 확인할 수 있도록 돕는 **접속 가이드**입니다.

---

## ✅ 1. 접속 방법

브라우저에서 다음 주소를 엽니다.

```text
http://<메인 서버 IP>:5601
```

예: `http://192.168.0.100:5601`

---

## ✅ 2. 로그인

- 아이디: `viewer_user`
- 비밀번호: `create_log_reader_user.ps1`에서 설정한 값

> 스크립트의 `change-me-password`는 예시 플레이스홀더입니다. 실행 전에 실제 값으로 교체하고, 실제 비밀번호는 저장소에 커밋하지 마세요.

---

## ✅ 3. Discover 탭 진입

1. 왼쪽 메뉴에서 **Discover**를 클릭합니다.
2. 처음 접속하는 경우 다음 값으로 **Data View**를 생성합니다.
   - Index pattern: `gameserver-logs-*`
   - Timestamp field: `@timestamp`

---

## ✅ 4. 로그 필터 예시

서버 시작 로그를 찾는 KQL 예시입니다.

```kql
Message.keyword: "[Server Start]"
```

## ✅ 5. 필드 추가

Discover 테이블에 다음 필드를 추가할 수 있습니다.

- `Timestamp`
- `Source`
- `Message`
- `Level`

필드 오른쪽의 ➕ 아이콘을 클릭하면 테이블에 추가됩니다.

## ✅ 6. 참고

시간 범위는 오른쪽 위 Time picker에서 "오늘", "마지막 15분" 등으로 조절합니다. 로그가 보이지 않으면 조회 범위를 늘려보세요.
