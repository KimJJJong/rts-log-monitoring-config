# 🎮 RTS Log Monitoring Config / RTS 로그 모니터링 설정 / RTSログ監視設定

[한국어](README.md) | [日本語](README.ja.md) | **English**

This repository contains configuration files for collecting game-server JSON Lines logs with Filebeat, storing them in Elasticsearch, and searching and visualizing them in Kibana.

`Filebeat → Elasticsearch → Kibana`

## Contents

| Path | Description |
|---|---|
| `filebeat.yml` | JSON log collection and Elasticsearch/Kibana connection settings |
| `create_log_reader_user.ps1` | PowerShell script that creates a read-only role and user for the `gameserver-logs-*` indices |
| `sample_logs/Log_sample.json` | Sample log with one JSON object per line |
| `docs/setup_guide_ko.md` | Kibana access guide for team members (Korean) |

## Main settings

- Input path: `C:/RTS_Server/logs_json/*.json`
- Event time: the JSON `Timestamp` field is processed as `@timestamp`
- Elasticsearch index: `gameserver-logs-%{+yyyy.MM.dd}`
- Kibana URL: `http://localhost:5601`
- Read-only role: `log_reader`
- Read-only user: `viewer_user`

## Quick start

### 1. Start Filebeat

Check the log path and the Elasticsearch and Kibana endpoints in `filebeat.yml` for your environment, then start Filebeat.

```powershell
filebeat.exe -e -c filebeat.yml
```

### 2. Create the read-only user

`create_log_reader_user.ps1` uses Elasticsearch administrator credentials to create the `log_reader` role and the `viewer_user` account.

Before running it, replace the administrator password and the `viewer_user` password in your local copy of the script. `change-me-password` is an example placeholder only; do not use it as a real password or commit a real secret to the repository.

```powershell
powershell -ExecutionPolicy Bypass -File .\create_log_reader_user.ps1
```

### 3. Open Kibana

Open the following URL in a browser:

```text
http://<main-server-ip>:5601
```

- User: `viewer_user`
- Password: the value configured in the script (example: `change-me-password`)

### 4. Create the Data View

- Index pattern: `gameserver-logs-*`
- Timestamp field: `@timestamp`

### 5. Search the logs

Example KQL query for server-start events:

```kql
Message.keyword: "[Server Start]"
```

You can add the `Timestamp`, `Source`, `Message`, and `Level` fields to the Discover table. If no logs appear, expand the time range with the Time picker in the upper-right corner.

## Security notes

The provided examples use local HTTP endpoints. For external environments, add TLS, network access controls, strong passwords, and appropriate secret management.
