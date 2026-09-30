# 🎮 RTS Log Monitoring Config / RTS 로그 모니터링 설정 / RTSログ監視設定

[한국어](README.md) | **日本語** | [English](README.en.md)

ゲームサーバーが出力するJSON Lines形式のログをFilebeatで収集し、Elasticsearchに保存してKibanaで検索・可視化するための設定一式です。

`Filebeat → Elasticsearch → Kibana`

## 構成

| パス | 説明 |
|---|---|
| `filebeat.yml` | JSONログの収集とElasticsearch・Kibanaへの接続設定 |
| `create_log_reader_user.ps1` | `gameserver-logs-*`インデックス用の読み取り専用ロールとユーザーを作成するPowerShellスクリプト |
| `sample_logs/Log_sample.json` | 1行に1つのJSONオブジェクトを記録したサンプルログ |
| `docs/setup_guide_ko.md` | チームメンバー向けKibana接続ガイド（韓国語） |

## 主な設定

- 収集パス: `C:/RTS_Server/logs_json/*.json`
- イベント時刻: JSONの`Timestamp`フィールドを`@timestamp`として処理
- Elasticsearchインデックス: `gameserver-logs-%{+yyyy.MM.dd}`
- Kibana URL: `http://localhost:5601`
- 読み取り専用ロール: `log_reader`
- 読み取り専用ユーザー: `viewer_user`

## クイックスタート

### 1. Filebeatの起動

環境に合わせて`filebeat.yml`のログパスとElasticsearch・Kibanaの接続先を確認してから起動します。

```powershell
filebeat.exe -e -c filebeat.yml
```

### 2. 読み取り専用ユーザーの作成

`create_log_reader_user.ps1`は、Elasticsearchの管理者アカウントを使用して`log_reader`ロールと`viewer_user`ユーザーを作成します。

実行前に、スクリプト内の管理者パスワードと`viewer_user`のパスワードをローカル環境の実際の値に置き換えてください。本文中の`change-me-password`は例示用のプレースホルダーです。実際のパスワードとして使用したり、リポジトリへコミットしたりしないでください。

```powershell
powershell -ExecutionPolicy Bypass -File .\create_log_reader_user.ps1
```

### 3. Kibanaへの接続

ブラウザーで次のURLを開きます。

```text
http://<メインサーバーのIP>:5601
```

- ユーザー: `viewer_user`
- パスワード: スクリプトで設定した値（例: `change-me-password`）

### 4. Data Viewの作成

- Index pattern: `gameserver-logs-*`
- Timestamp field: `@timestamp`

### 5. ログの検索

サーバー起動ログを検索するKQLの例です。

```kql
Message.keyword: "[Server Start]"
```

Discoverの表には`Timestamp`、`Source`、`Message`、`Level`フィールドを追加できます。ログが表示されない場合は、右上のTime pickerで検索範囲を広げてください。

## セキュリティ上の注意

現在の例はローカルHTTP接続を前提としています。外部環境では、TLS、ネットワークアクセス制御、強力なパスワード、適切なシークレット管理を別途適用してください。
