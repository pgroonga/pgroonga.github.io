---
title: "pgroonga.force_match_escalationパラメーター"
upper_level: ../
---

# `pgroonga.force_match_escalation`パラメーター

2.2.8で追加。

## 概要

`pgroonga.force_match_escalation`パラメーターは常にマッチエスカレーションを使うかどうかを制御します。

マッチエスカレーションとは自動で条件のゆるい検索をする機能のことです。このパラメーターが`on`の場合は常にマッチエスカレーションを使います。

デフォルトは`off`です。これは条件次第でマッチエスカレーションを使うということです。

`on`を指定することで常にマッチエスカレーションを使うことができます。

通常、このパラメーターを変更する必要はありません。条件次第で自動で条件のゆるい検索をするのはユーザーにとって適切な挙動だからです。

[`pgroonga.match_escalation_threshold`パラメーター][match-escalation-threshold]も参照してください。

## 構文

SQLの場合：

```sql
SET pgroonga.force_match_escalation = boolean;
```

`postgresql.conf`の場合：

```text
pgroonga.force_match_escalation = boolean
```

`boolean`は真偽値です。真偽値には`on`、`off`、`true`、`false`、`yes`、`no`のようなリテラルがあります。

## 使い方

以下は常にマッチエスカレーションを使うようにするSQLの例です。

```sql
SET pgroonga.force_match_escalation = on;
```

以下は常にマッチエスカレーションを使うようにする設定の例です。

```sql
pgroonga.force_match_escalation = on
```

## 参考

  * [`pgroonga.match_escalation_threshold`パラメーター][match-escalation-threshold]

[match-escalation-threshold]:match-escalation-threshold.html
