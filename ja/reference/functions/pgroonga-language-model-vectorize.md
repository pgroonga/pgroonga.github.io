---
title: pgroonga_language_model_vectorize 関数
upper_level: ../
---

# `pgroonga_language_model_vectorize` 関数

4.0.5で追加

## 概要

`pgroonga_language_model_vectorize`関数は指定されたテキストの正規化されたエンべディングを返します。

## 構文

この関数の構文は次の通りです。

```text
float4[] pgroonga_language_model_vectorize(model_name, target)
```

`model_name`は使用する言語モデルの名前です。型は`text`です。

`model_name`にはHugging FaceのURIが指定できます。Hugging FaceのURIを指定するとモデルのダウンロードと配置を自動で行うのでおすすめです。モデルはPostgreSQLのデータベースのデータディレクトリに保存されます。

初回実行時にはモデルをダウンロードします。そのため時間がかかります。2回目以降は、ダウンロード済のローカルモデルファイルを使うため、ダウンロードの時間はかかりません。

`target`は入力テキストです。型は`text`です。

`pgroonga_language_model_vectorize`は正規化されたエンべディング（`float4`の配列）を返します。

## 使い方

Hugging FaceのURI（`hf:///groonga/bge-m3-Q4_K_M-GGUF`）を指定して、エンベディングを生成する例です。

```sql
CREATE TABLE memos (
  content text
);

INSERT INTO memos VALUES ('I am a king.');
INSERT INTO memos VALUES ('I am a queen.');

SELECT (pgroonga_language_model_vectorize(
  'hf:///groonga/bge-m3-Q4_K_M-GGUF',
  content))[1:3]
FROM memos;

--    pgroonga_language_model_vectorize   
-- ---------------------------------------
--  {0.008148969,0.009139845,-0.01644061}
--  {0.0088241,0.00544599,-0.044706207}
-- (2 rows)
```

エンベディングのすべてを表示するとかなり長いので `[1:3]` で先頭の3つのみ表示していています。

## 参考

* [Groongaの`language_model_vectorize`関数][groonga-language-model-vectorize]

[groonga-language-model-vectorize]:https://groonga.org/ja/docs/reference/functions/language_model_vectorize.html
