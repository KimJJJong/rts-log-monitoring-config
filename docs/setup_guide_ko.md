# 📘 RTS 게임 서버 로그 확인 가이드 (팀원용)

이 문서는 팀원들이 Kibana에서 로그를 확인할 수 있도록 돕는 **접속 가이드**입니다.

---

## ✅ 1. 접속 방법

- 브라우저를 열고 다음 주소 입력:
http://<메인 서버 IP>:5601

예: `http://192.168.0.100:5601`

---

## ✅ 2. 로그인

- 아이디: `viewer_user`  
- 비밀번호: `mypassword`

(읽기 전용 계정입니다.)

---

## ✅ 3. Discover 탭 진입

1. 왼쪽 메뉴에서 **Discover** 클릭  
2. 처음 접속 시 **Data View 생성** 필요할 수 있음:
Index pattern: gameserver-logs-* Timestamp field: @timestamp

---

## ✅ 4. 로그 필터 예시

- **서버 시작 로그 보기**
```kql
Message.keyword: "[Server Start]"

✅ 5. 필드 추가
Discover 테이블에 표시할 필드:
Timestamp
Source
Message
Level

필드 오른쪽 ➕ 아이콘 클릭하면 테이블에 추가됩니다.

✅ 6. 참고
시간 범위 조절은 오른쪽 위 Time picker에서 "오늘", "마지막 15분" 등을 선택하세요.

로그가 안 보이면 시간 범위를 늘려보세요.