---
title: pgroonga_normalize関数
upper_level: ../
---

# `pgroonga_normalize`関数

2.0.3で追加

## 概要

`pgroonga_normalize`関数は[Groongaのノーマライザー](http://groonga.org/ja/docs/reference/normalizers.html)を利用してテキストを正規化された形式に変換します。
この関数を使うことで、Groongaがトークナイズの前段階で施している処理を利用することができます。

## 構文

この関数の構文は次の通りです。

```text
text pgroonga_normalize(target)
```

`target`は正規化処理の対象となる`text`型の値です。処理にあたっては、デフォルトでは組み込みの[NormalizerAuto](http://groonga.org/ja/docs/reference/normalizers.html#normalizerauto)モジュールが使われます。

第二引数を利用すると、他のノーマライザーモジュールを使うことができます。

```text
text pgroonga_normalize(target, normalizerName)
```

`normalizerName`は`text`型の値で、利用したいノーマライザーモジュールを指定します。

## 使い方

以下は`pgroonga_normalize`関数の利用例です。

```sql
SELECT pgroonga_normalize('aBcDe 123');
--  pgroonga_normalize 
-- --------------------
--  abcde 123
-- (1 row)
```

その他のノーマライザーも（システムにインストールされていれば）使うことができます。

```sql
SELECT pgroonga_normalize('Àá', 'NormalizerMySQLGeneralCI');
--  pgroonga_normalize 
-- --------------------
--  AA
-- (1 row)
```

## 参考

 * [Groongaのノーマライザに関するドキュメント](http://groonga.org/ja/docs/reference/normalizers.html)
