---
title: "pgroonga.match_escalation_thresholdパラメーター"
upper_level: ../
---

# `pgroonga.match_escalation_threshold`パラメーター

## 概要

`pgroonga.match_escalation_threshold`パラメーターはいつマッチエスカレーションが実行されるかを制御します。

マッチエスカレーションとは自動で条件のゆるい検索をする機能のことです。ヒット数が`pgroonga.match_escalation_threshold`パラメーターで指定した閾値よりも小さい時、自動で条件のゆるい検索をします。これがマッチエスカレーションです。

デフォルトの閾値は`0`です。これは1件もヒットしない時は自動で条件のゆるい検索をするという意味です。

`-1`を指定することでマッチエスカレーションを無効にできます。

通常、このパラメーターを変更する必要はありません。自動で条件のゆるい検索をするとユーザーは便利になるからです。

## 構文

SQLの場合：

```sql
SET pgroonga.match_escalation_threshold = threshold;
```

`postgresql.conf`の場合：

```text
pgroonga.match_escalation_threshold = threshold
```

`threshold`は数値です。

## 使い方

以下はマッチエスカレーションを無効にする例です。

```sql
SET pgroonga.match_escalation_threshold = -1;
```
