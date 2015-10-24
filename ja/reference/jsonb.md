---
title: jsonbサポート
layout: ja
---

# `jsonb`サポート

PGroongaは`jsonb`型もサポートしています。PGroongaを使うと複数のキー・値に対して条件を指定してJSONデータを検索できます。

JSON内のすべてのテキスト値に対して全文検索をしてJSONデータを検索することもできます。これはPostgreSQL組み込みの機能でも[JsQuery](https://github.com/postgrespro/jsquery)でもサポートしていない機能です。

次のようなJSONを考えてください。

```json
{
  "message": "Server is started.",
  "host": "www.example.com",
  "tags": [
    "web",
  ]
}
```

`search`でも`example`でも`web`でもどの単語で全文検索してもこのJSONを検索することができます。なぜなら、すべてのテキスト値が全文検索対象だからです。

## 演算子

PGroongaは`jsonb`型の値で検索するために次の2つの演算子を提供しています。

  * [`@>`演算子](operators/jsonb-contain.html)
  * [`@@`演算子](operators/jsonb-query.html)

`@>`演算子は`@@`演算子よりもシンプルですが範囲検索のような複雑な条件を指定することはできません。

`@@`演算子は`@>`演算子より複雑ですが、複雑な条件も使えます。JSON内のすべてのテキスト値に対する全文検索もできます。

## GINとの比較

PostgreSQLは組み込みの機能としてGINを使った高速な`jsonb`検索機能を提供しています。

PGroongaとGINの違いは次の通りです。

  * インデックス作成時間：ほぼ同じ
  * 検索時間：PGroongaの方が少し速い
  * 機能：PGroongaの方がより多くの検索機能を提供
