---
title: pgroonga_normalize関数
upper_level: ../
---

# `pgroonga_normalize`関数

2.0.3で追加

## 概要

`pgroonga_normalize`関数は[Groongaのノーマライザーモジュール][groonga-normalizers]を使ってテキストをノーマライズします。

## 構文

この関数の構文は次の通りです。

```text
text pgroonga_normalize(target)
```

`target`はノーマライズ対象となる`text`型の値です。処理にあたっては、デフォルトでは組み込みの[`NormalizerAuto`][groonga-normalizer-auto]ノーマライザーを使います。

この関数の別の構文は次の通りです。

```text
text pgroonga_normalize(target, normalizer)
```

`normalizer`は`text`型の値です。利用したいノーマライザーモジュールを指定します。

## 使い方

`text`型の値をノーマライズします。

```sql
SELECT pgroonga_normalize('aBcDe 123');
--  pgroonga_normalize 
-- --------------------
--  abcde 123
-- (1 row)
```

ノーマライザーを指定できます。

```sql
SELECT pgroonga_command('plugin_register normalizers/mysql');
SELECT pgroonga_normalize('aBcDe 123', 'NormalizerMySQLGeneralCI');
--  pgroonga_normalize 
-- --------------------
--  ABCDE 123
-- (1 row)
```

[groonga-normalizer-mysql][groonga-normalizer-mysql]を使うために`plugin_register normalizers/mysql`を実行しています。groonga-normalizer-mysqlはMySQL互換のノーマライザーを提供します。

ノーマライザーのオプションも指定できます。

```sql
SELECT pgroonga_normalize('あア', 'NormalizerNFKC130("unify_kana", true)');
--  pgroonga_normalize 
-- --------------------
--  ああ
-- (1 row)
```

複数のノーマライザーを指定することもできます。以下は実用的ではない例です。


```sql
SELECT pgroonga_normalize('あー-ア', 
  '
    NormalizerNFKC130("unify_kana", true),
    NormalizerNFKC130("unify_hyphen_and_prolonged_sound_mark", true)
  '
);
--  pgroonga_normalize 
-- --------------------
--  あ--あ
-- (1 row)
```

## 参考

 * [Groongaのノーマライザーのドキュメント][groonga-normalizers]

[groonga-normalizers]:http://groonga.org/ja/docs/reference/normalizers.html

[groonga-normalizer-auto]:http://groonga.org/ja/docs/reference/normalizers.html#normalizer-auto

[groonga-normalizer-mysql]:https://github.com/groonga/groonga-normalizer-mysql
