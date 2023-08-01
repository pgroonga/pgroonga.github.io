---
title: PostgRESTでPGroongaを使う方法
---

# PostgRESTでPGroongaを使う方法

PostgRESTを使うことによってPostgreSQLで作ったデータの**"検索APIを簡単に公開"**できます。これはそのためのPostgRESTでPGroongaを使うための初心者向けガイドです。

## PostgreSQL側でのデータの準備

ここでは大抵どのご家庭のコンピュータにも入っているPostgreSQLを使います😏

```sh
createdb api
psql api
```

## テーブル作成と適切なインデックス作成

PGroongaの便利な機能を使うには、それらの機能に応じた最適なインデックスを作ることが大変重要となります。

この例では、memoテーブルを作成し、後に続く検索機能に必要なインデックスをそれぞれのカラムに対して作成します。

- ひらがなとカタカナを同一視させます ("あっぷる"でも"あっぷる"と"アップル"がヒット)。

- ひらがなとカタカナとローマ字を同一視させます ("de-tabe-su"で検索しても"de-tabe-su","でーたべーす",そして "データベース"がヒットします)。

- 様々な長音記号を同一視させます ("-˗֊‐‑‒–⁃⁻₋− ﹣－ ー—―─━ｰ,"を同じ文字として扱います)。

早速やってみましょう！

```sql
CREATE EXTENSION IF NOT EXISTS pgroonga;

CREATE TABLE memos (
  id integer,
  title text,
  content text
);

-- Please don't mind the randomness of the sample text 😗
INSERT INTO memos VALUES (1, 'PostgreSQLはリレーショナル・データベース管理システムです。','すごいでしょう');
INSERT INTO memos VALUES (2, 'Groongaは日本語対応の高速な全文検索エンジンです。','スワイショウ');
INSERT INTO memos VALUES (3, 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。','ハバナイスデー');
INSERT INTO memos VALUES (4, 'groongaコマンドがあります。','今日はコンバンワこのくにわ');

CREATE INDEX pgroonga_title_search_index ON memos USING pgroonga (title)
  WITH (
    normalizers = 'NormalizerNFKC150
      (
        "unify_kana", true,
        "unify_to_romaji", true,
        "unify_hyphen_and_prolonged_sound_mark", true
      )',
    tokenizer = 'TokenNgram("unify_symbol", false, "unify_alphabet", false, "unify_digit", false)'
  );

CREATE INDEX pgroonga_content_search_index ON memos USING pgroonga (content)
  WITH (
    normalizers = 'NormalizerNFKC150
      (
        "unify_kana", true,
        "unify_to_romaji", true,
        "unify_hyphen_and_prolonged_sound_mark", true
      )',
    tokenizer = 'TokenBigramSplitSymbolAlphaDigit'
  );
```

## PostgREST権限情報を設定

次の手順に従ってPostgRESTへの権限情報を設定します：

```sql
CREATE ROLE web_user nologin;
GRANT USAGE ON SCHEMA public TO web_user;
GRANT SELECT ON memos TO web_user;

CREATE ROLE authenticator noinherit login password 'mypassword';
GRANT web_user to authenticator;
```

## PostgRESTの設定

```sh
vi memo.conf
```

ファイルの内容:

```vim
db-uri = "postgres://authenticator:mypassword@localhost:5432/api"
db-schemas = "public"
db-anon-role = "web_user"
```

## PostgRESTの起動

```sh
postgrest memo.conf
```

PostgRESTのインストール方法については https://postgrest.org/en/stable/explanations/install.html を参考にしてね😉

## URLにアクセス

ブラウザを開いて次のURLにアクセスします:

http://localhost:3000/memos

結果：

```json
[
  {"id":1,"title":"PostgreSQLはリレーショナル・データベース管理システムです。","content":"すごいでしょう"},
  {"id":2,"title":"Groongaは日本語対応の高速な全文検索エンジンです。","content":"スワイショウ"},
  {"id":3,"title":"PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。","content":"ハバナイスデー"},
  {"id":4,"title":"groongaコマンドがあります。","content":"今日はコンバンワこのくにわ"}
]
```

何ということでしょう！？こんなに簡単にREST APIが動いちゃっていいの？！🤯

(ただし今回の例では権限的に`SELECT`機能しか使えません。なので検索は出来ますがデータの変更や削除は出来ません😏)

## 通常のLIKE検索

ここでは通常のPostgreSQLの `LIKE` 検索を使う方法を紹介します。

(ところで通常のPostgreSQLでは中間一致検索においてインデックスは使われませんが、PGroongaを使うと中間一致でもインデックスが使えます。まるで魔法ですね！ 👀)

### titleを検索

ブラウザを開いて次のURLにアクセスします:

[`http://localhost:3000/memos?title=like.*データ*`](http://localhost:3000/memos?title=like.*データ*)

```json
[{"id":1,"title":"PostgreSQLはリレーショナル・データベース管理システムです。","content":"すごいでしょう"}]
```

### contentを検索

ブラウザを開いて次のURLにアクセスします:

[`http://localhost:3000/memos?content=like.*ショウ*`](http://localhost:3000/memos?content=like.*ショウ*)

```json
[{"id":2,"title":"Groongaは日本語対応の高速な全文検索エンジンです。","content":"スワイショウ"}]
```

☝️ 通常の LIKE 検索ではカタカナの'ショウ'ではひらがなの「しょう」はヒットしません

## PGroongaを使った検索

さて、PGroongaで使用する `&@~` 演算子はそのままではPostgRESTで使用することができません。それを利用可能にするためのストアドファンクションを作成します。

```sh
psql api
```

次のSQL文を実行します:

```sql
CREATE FUNCTION find_title(keywords text) RETURNS SETOF memos AS $$
BEGIN
  RETURN QUERY SELECT * FROM memos WHERE title &@~ keywords;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION find_content(keywords text) RETURNS SETOF memos AS $$
BEGIN
  RETURN QUERY SELECT * FROM memos WHERE content &@~ keywords;
END;
$$ LANGUAGE plpgsql;
```

## PostgRESTでPGroongaを使用した検索

PostgRESTでストアドファンクションを使う際には、URLに `/rpc/function_name` を使います。

ブラウザを開いて次のURLにアクセスします:

[`http://localhost:3000/rpc/find_title?keywords=コマンド`](http://localhost:3000/rpc/find_title?keywords=コマンド)

次のような結果が戻って来ます。

```json
[{"id":4,"title":"groongaコマンドがあります。","content":"今日はコンバンワこのくにわ"}]
```

ちなみにブラウザからURLでエンドポイントを叩く方が、文字列のエンコードが不要な分、curlを使うよりも楽です。

```console
$ curl --get --data-urlencode keywords=コマンド http://localhost:3000/rpc/find_title
[{"id":4,"title":"groongaコマンドがあります。","content":"今日はコンバンワこのくにわ"}]
```

### ローマ字検索

ブラウザを開いて次のURLにアクセスします:

[`http://localhost:3000/rpc/find_title?keywords=desu`](http://localhost:3000/rpc/find_title?keywords=desu)

```json
[
  {"id":1,"title":"PostgreSQLはリレーショナル・データベース管理システムです。","content":"すごいでしょう"},
  {"id":2,"title":"Groongaは日本語対応の高速な全文検索エンジンです。","content":"スワイショウ"},
  {"id":3,"title":"PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。","content":"ハバナイスデー"}
]
```

### ひらがな もしくは カタカナ で、ひらがなとカタカナ両方を検索

ブラウザを開いて次のURLにアクセスします:

[`http://localhost:3000/rpc/find_content?keywords=ショウ`](http://localhost:3000/rpc/find_content?keywords=ショウ)

```json
[
  {"id":1,"title":"PostgreSQLはリレーショナル・データベース管理システムです。","content":"すごいでしょう"},
  {"id":2,"title":"Groongaは日本語対応の高速な全文検索エンジンです。","content":"スワイショウ"}
]
```

### AND検索

ブラウザを開いて次のURLにアクセスします:

[`http://localhost:3000/rpc/find_title?keywords=nga です`](http://localhost:3000/rpc/find_title?keywords=nga%20です)

```json
[
  {"id":2,"title":"Groongaは日本語対応の高速な全文検索エンジンです。","content":"スワイショウ"},
  {"id":3,"title":"PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。","content":"ハバナイスデー"}
]
```

### OR検索

ブラウザを開いて次のURLにアクセスします:

[`http://localhost:3000/rpc/find_title?keywords=nga OR です`](http://localhost:3000/rpc/find_title?keywords=nga%20OR%20です)

```json
[
  {"id":2,"title":"Groongaは日本語対応の高速な全文検索エンジンです。","content":"スワイショウ"},
  {"id":3,"title":"PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。","content":"ハバナイスデー"},
  {"id":4,"title":"groongaコマンドがあります。","content":"今日はコンバンワこのくにわ"},
  {"id":1,"title":"PostgreSQLはリレーショナル・データベース管理システムです。","content":"すごいでしょう"}
]
```

## 参考情報

追加の検索項目が欲しい場合にはストアドファンクションを追加して行きましょう。

### 検索対象を動的にするパターン

カラム名をパラメータとして渡して検索させる例です：

```sql
CREATE OR REPLACE FUNCTION search_col(column_name text, keyword text)
  RETURNS SETOF memos
  LANGUAGE plpgsql
AS $$
BEGIN
  IF column_name IN ('title', 'content') THEN -- Check if the column name is valid
    RETURN QUERY EXECUTE format('SELECT * FROM memos WHERE %I &@~ ''%s''', column_name, keyword);
  ELSE
    RAISE EXCEPTION 'Invalid column name'; -- Return an error if the column name is invalid
  END IF;
END;
$$;
CREATE FUNCTION
```

### 全てのカラムを検索

全てのカラムに対してキーワード検索します:

```sql
CREATE OR REPLACE FUNCTION memo_search(keyword text)
  RETURNS SETOF memos
  LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY EXECUTE format('
    SELECT *
    FROM memos
    WHERE title &@~ $1 OR content &@~ $1
  ') USING keyword;
END;
$$;
```
