---
title: "pgroonga.enable_row_level_securityパラメーター"
upper_level: ../
---

# `pgroonga.enable_row_level_security`パラメーター

3.1.6で追加

## 概要

`pgroonga.enable_row_level_security`パラメータは[`pgroonga.log_level`パラメーター][log-level]に従いログを出力するか、`critical`のログのみを出力するかを制御します。

デフォルト値は`on`のため、[行セキュリティポリシー][postgresql-row-security-policies]を設定しているテーブルの場合、PGroongaは`critical`のログのみを出力します。

## 構文

SQLの場合：

```sql
SET pgroonga.enable_row_level_security = boolean;
```

`postgresql.conf`の場合：

```text
pgroonga.log_level = boolean
```

`boolean`は真偽値です。真偽値には`on`、`off`、`true`、`false`、`yes`、`no`のようなリテラルがあります。

## 使い方

以下は[行セキュリティポリシー][postgresql-row-security-policies]が設定されてあるテーブルでも[`pgroonga.log_level`パラメーター][log-level]の設定に従いログを出力するSQLの例です。

```sql
SET pgroonga.enable_row_level_security = off;
```

以下は[行セキュリティポリシー][postgresql-row-security-policies]が設定されてあるテーブルでも[`pgroonga.log_level`パラメーター][log-level]の設定に従いログを出力する設定の例です。

```text
pgroonga.enable_row_level_security = off;
```

## 参考

  * [行セキュリティポリシー][postgresql-row-security-policies]

  * [`pgroonga.log_level`パラメーター][log-level]

[postgresql-row-security-policies]:{{ site.postgresql_doc_base_url.ja }}/ddl-rowsecurity.html

[log-level]:log-level.html
