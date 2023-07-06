---
title: How to use PGroonga with PostgREST
---

# How to use PGroonga with PostgREST

Create data in PostgreSQL, provide it as an API using PostgREST, and then easily create an **"API for convenient data search"**. This is a beginner's guide to PostgREST with PGroonga.

## Prepare data on the PostgreSQL side
Here, we will use PostgreSQL, which is usually available on most computers😏

```sh
createdb api
psql api
```

## Create a table and create suitable indexes
To make use of the convenient features of PGroonga, creating indexes that match the features is crucial.

In this example, we will create a memo table and create indexes that enable the following search functionalities for each column:

- Treating hiragana and katakana as equivalent (searching for "あっぷる" will match both "あっぷる" and "アップル").
- Treating hiragana, katakana, and romaji as equivalent (searching for "de-tabe-su" will match "de-tabe-su," "でーたべーす," and "データベース").
- Treating various long vowel marks as equivalent (treating similar long vowel marks, such as "-˗֊‐‑‒–⁃⁻₋− ﹣－ ー—―─━ｰ," as the same for easier searching).

Now, let's try it out!

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

## Prepare PostgREST permissions

To create the necessary permissions for PostgREST, you can follow these steps:

```sql
create role web_user nologin;
grant usage on schema public to web_user;
grant select on memos to web_user;

create role authenticator noinherit login password 'mypassword';
grant web_user to authenticator;
```

## Configure PostgREST
```sh
vi memo.conf
```

Inside of the file:
```vim
db-uri = "postgres://authenticator:mypassword@localhost:5432/api"
db-schemas = "public"
db-anon-role = "web_user"
```

## Start PostgREST

```sh
postgrest memo.conf
```

Oh, for the installation method of PostgREST, please refer to https://postgrest.org/en/stable/explanations/install.html 😉

## Access the URL
Open your browser and access the following:

http://localhost:3000/memos

Result:

```json
[{"id":1,"title":"PostgreSQLはリレーショナル・データベース管理システムです。","content":"すごいでしょう"}, 
 {"id":2,"title":"Groongaは日本語対応の高速な全文検索エンジンです。","content":"スワイショウ"}, 
 {"id":3,"title":"PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。","content":"ハバナイスデー"}, 
 {"id":4,"title":"groongaコマンドがあります。","content":"今日はコンバンワこのくにわ"}]
```

What? Is it really this easy to have a working REST API endpoint? It's too convenient! 🤯

(However, please note that due to the permissions set up in this case, you can only perform `SELECT` operations. So, you can search but not add, modify, or delete data. 😏)

## Regular LIKE search
This is the method to perform a `LIKE` search using the standard functionality of PostgreSQL.

(By the way, normally, indexes do not work for PostgreSQL's partial match, but if you create an index with PGroonga, it will work. It's like magic! 👀)

### Search by title

Open your browser and access the following:

[`http://localhost:3000/memos?title=like.*データ*`](http://localhost:3000/memos?title=like.*データ*)

```json
[{"id":1,"title":"PostgreSQLはリレーショナル・データベース管理システムです。","content":"すごいでしょう"}]
```

### Search by content

Open your browser and access the following:

[`http://localhost:3000/memos?content=like.*ショウ*`](http://localhost:3000/memos?content=like.*ショウ*)

```json
[{"id":2,"title":"Groongaは日本語対応の高速な全文検索エンジンです。","content":"スワイショウ"}]
```
☝️ With the standard LIKE search functionality, searching for 'ショウ' in katakana will not match hiragana.

## Searching with PGroonga

Now, since the operators `&@~` required for searching with PGroonga are not directly available in PostgREST, we will create a stored function to enable their usage.

```sh
psql api
```

Execute the following SQL statement:

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

## Searching with PGroonga in PostgREST
When calling stored functions in PostgREST, the URL format is `/rpc/function_name`.

Open your browser and access the following:

[`http://localhost:3000/rpc/find_title?keywords=コマンド`](http://localhost:3000/rpc/find_title?keywords=コマンド)

The following results will be returned.
```json
[{"id":4,"title":"groongaコマンドがあります。","content":"今日はコンバンワこのくにわ"}]
```

By the way, using a browser to hit the URL is easier than using curl because dealing with encoding can be cumbersome.

```sh
curl --get --data-urlencode keywords=コマンド http://localhost:3000/rpc/find_title

[{"id":4,"title":"groongaコマンドがあります。","content":"今日はコンバンワこのくにわ"}]
```

### Search in romaji

Open your browser and access the following:

[`http://localhost:3000/rpc/find_title?keywords=desu`](http://localhost:3000/rpc/find_title?keywords=desu)

```json
[{"id":1,"title":"PostgreSQLはリレーショナル・データベース管理システムです。","content":"すごいでしょう"}, 
 {"id":2,"title":"Groongaは日本語対応の高速な全文検索エンジンです。","content":"スワイショウ"}, 
 {"id":3,"title":"PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。","content":"ハバナイスデー"}]
```

### Searching hiragana and katakana in hiragana or katakana

Open your browser and access the following:

[`http://localhost:3000/rpc/find_content?keywords=ショウ`](http://localhost:3000/rpc/find_content?keywords=ショウ)

```json
[{"id":1,"title":"PostgreSQLはリレーショナル・データベース管理システムです。","content":"すごいでしょう"}, 
 {"id":2,"title":"Groongaは日本語対応の高速な全文検索エンジンです。","content":"スワイショウ"}]
```

### AND search

Open your browser and access the following:

[`http://localhost:3000/rpc/find_title?keywords=nga です`](http://localhost:3000/rpc/find_title?keywords=nga%20です)

```json
[{"id":2,"title":"Groongaは日本語対応の高速な全文検索エンジンです。","content":"スワイショウ"}, 
 {"id":3,"title":"PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。","content":"ハバナイスデー"}]
```

### OR search

Open your browser and access the following:

[`http://localhost:3000/rpc/find_title?keywords=nga OR です`](http://localhost:3000/rpc/find_title?keywords=nga%20OR%20です)

```json
[{"id":2,"title":"Groongaは日本語対応の高速な全文検索エンジンです。","content":"スワイショウ"}, 
 {"id":3,"title":"PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。","content":"ハバナイスデー"}, 
 {"id":4,"title":"groongaコマンドがあります。","content":"今日はコンバンワこのくにわ"}, 
 {"id":1,"title":"PostgreSQLはリレーショナル・データベース管理システムです。","content":"すごいでしょう"}]
```

## Bonus
When you want to allow various additional searches, you can create multiple stored functions.

### Make target column customizable

Here is an example of a stored function that performs a dynamic search by passing the column name:

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

###  Search all columns

Stored function to search all columns with a keyword:

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
