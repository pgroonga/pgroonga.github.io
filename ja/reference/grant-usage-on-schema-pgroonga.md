---
title: GRANT USAGE ON SCHEME pgroonga
---

# `GRANT USAGE ON SCHEME pgroonga`

PGroongaは`pgroonga`スキーマに関数・演算子・演算子クラスなどを定義します。デフォルトではスーパーユーザーしか`pgroonga`スキーマの機能を使えません。スーパーユーザーはPGroongaを使いたいすべての一般ユーザーに`pgroonga`スキーマの`USAGE`権限を与えなければいけません。

このドキュメントは一般ユーザーに`pgroonga`スキーマの`USAGE`権限を与える方法を説明します。

## 一般ユーザーを作成 {#create-user}

最初に[`CREATE USER`](http://www.postgresql.jp/document/{{ site.postgresql_short_version }}/html/sql-createuser.html)で一般ユーザー`alice`を作成します。

```sql
CREATE USER alice;
```

この時点では、一般ユーザー`alice`は`pgroonga`スキーマのどのオブジェクトにもアクセスできません。例えば、`alice`は[`pgroonga.snippet_html`関数](functions/pgroonga-snippet-html.html)を使うことができません。

```sql
SELECT pgroonga.snippet_html('PGroonga is fast', Array['fast']);
-- ERROR:  permission denied for schema pgroonga
-- LINE 1: SELECT pgroonga.snippet_html('PGroonga is fast', Array['fast...
--                ^
```

`alice`に`pgroonga`スキーマの`USAGE`権限を与える必要があります。

## `pgroonga`スキーマの`USAGE`権限を与える {#grant}

[`GRANT`](http://www.postgresql.jp/document/{{ site.postgresql_short_version }}/html/sql-grant.html)を使って一般ユーザー`alice`に`pgroonga`スキーマの`USAGE`権限を与えることができます。

```sql
GRANT USAGE ON SCHEMA pgroonga TO alice;
```

これで`alice`は`pgroonga`スキーマのすべての機能を使えるようになりました。例えば、`alice`は`pgroonga.snippet_html`関数を使うことができます。

```sql
SELECT pgroonga.snippet_html('PGroonga is fast', Array['fast']);
--                     snippet_html                     
-- -----------------------------------------------------
--  {"PGroonga is <span class=\"keyword\">fast</span>"}
-- (1 row)
```
