---
title: "pgroonga.log_type"
layout: ja
---

# `pgroonga.log_type`パラメータ

## 概要

ログの出力方法を変更する変数を追加しました。ファイル、Windowsイベントログ、PostgreSQLのログ出力機構、のどれかを選べます。

## 構文

```sql
set pgroonga.log_type = type
```

`type`はログの種類です。次の種類を設定できます。未指定時の値は`file`です。

* file: ファイル
* windows_event_log: Windowsイベントログ
* postgresql: PostgreSQLのログ出力機構

### `pgroonga.log_type`のWindowsイベントログ出力

次のように設定するとWindowsイベントログとしてログを出力できます。

```
SET pgroonga.log_type = 'windows_event_log';
```

これだけでWindowsイベントログに記録されるのですが、この状態でイベントビューアーで表示すると警告メッセージがでてログを確認しづらいです。

次のようにコマンドプロンプトから「PGroonga」というイベントを登録することで、警告メッセージが消えて確認しやすくなります。Windowsイベントログを使うときは設定することをオススメします。

```
> regsvr32 /n /i:PGroonga ${PostgreSQLをインストールしたフォルダ}\lib\pgevent.dll
```

なお、この手順はPostgreSQLでWindowsイベントログを利用する場合の手順と同様です。参考: [WindowsにおけるEvent Logの登録](https://www.postgresql.jp/document/9.4/html/event-log-registration.html)

### postgresql.confに記述する例

通常は上記のように設定をおこなわずに次のようにpostgresql.confに記述をします。

```
pgroonga.log_type = 'windows_event_log';
```

設定をおこなったあとは、リロードが必要です。
