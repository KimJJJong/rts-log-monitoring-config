# === 사용자 설정 부분 ===
$elasticUser = "elastic"
$elasticPassword = "your_elastic_password"
$base64Auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$elasticUser`:$elasticPassword"))

# === 읽기 전용 역할 생성 ===
Invoke-RestMethod -Method PUT `
  -Uri "http://localhost:9200/_security/role/log_reader" `
  -Headers @{ Authorization = "Basic $base64Auth" } `
  -ContentType "application/json" `
  -Body '{
    "indices": [
      {
        "names": [ "gameserver-logs-*" ],
        "privileges": [ "read", "view_index_metadata" ]
      }
    ]
  }'

# === 읽기 전용 사용자 생성 ===
Invoke-RestMethod -Method POST `
  -Uri "http://localhost:9200/_security/user/viewer_user" `
  -Headers @{ Authorization = "Basic $base64Auth" } `
  -ContentType "application/json" `
  -Body '{
    "password": "mypassword",
    "roles": [ "log_reader" ],
    "full_name": "Read Only User"
  }'

Write-Host "✅ 사용자 'viewer_user' 생성 완료!"
