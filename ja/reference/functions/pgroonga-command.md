---
title: pgroonga.command関数
---

# `pgroonga.command`関数

## 概要

`pgroonga.command`関数は[Groongaのコマンド](http://groonga.org/ja/docs/reference/command.html)を実行して`text`型の値として結果を返します。

## 構文

この関数の構文は次の通りです。

```text
text pgroonga.command(command)
```

`command`は`text`型の値です。`pgroonga.command`は`command`をGroongaのコマンドとして実行します。

Groongaのコマンドは結果をJSONとして返します。`pgroonga.command`はJSONを`text`型の値として返します。結果を`json`型か`jsonb`型にキャストすると[PostgreSQLが提供するJSON関数・演算](http://www.postgresql.jp/document/{{ site.postgresql_short_version }}/html/functions-json.html)を使うことができます。

## 使い方

[チュートリアルの例](../../tutorial/#groonga)も参照してください。

## Groongaの`select`コマンドに関する注意事項 {#attention}

[Groongaの`select`コマンド](http://groonga.org/ja/docs/reference/commands/select.html)を使うとき、不正なタプルについて注意する必要があります。

詳細は[`pgroonga_tuple_is_alive` Groonga関数](../groonga-functions/pgroonga-tuple-is-alive.html)を参照してください。

## 参考

  * [チュートリアルにある例](../../tutorial/#groonga)

  * [`pgroonga_tuple_is_alive` Groonga関数](../groonga-functions/pgroonga-tuple-is-alive.html)
