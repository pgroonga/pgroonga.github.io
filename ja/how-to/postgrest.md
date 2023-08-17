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

### NOT search

ブラウザを開いて次のURLにアクセスします:

[`http://localhost:3000/rpc/find_title?keywords=nga -pg`](http://localhost:3000/rpc/find_title?keywords=nga%20-pg)

```json
[
  {"id":2,"title":"Groongaは日本語対応の高速な全文検索エンジンです。","content":"スワイショウ"}, 
  {"id":4,"title":"groongaコマンドがあります。","content":"今日はコンバンワこのくにわ"}
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

## Keyword-Based Content Search

At times, you may want to conduct a search solely using keywords, rather than specifying particular fields. Let's explore how you can accomplish this.

Consider a personal library stored in a database table `books`:

```sql
CREATE TABLE books (
  id INTEGER,
  title TEXT,
  author TEXT
);

INSERT INTO books VALUES (1, 'Adventures of Sherlock Holmes', 'Arthur Conan Doyle');
INSERT INTO books VALUES (2, 'The Hound of the Baskervilles', 'Arthur Conan Doyle');
INSERT INTO books VALUES (3, 'The Memoirs of Sherlock Holmes', 'Arthur Conan Doyle');
INSERT INTO books VALUES (4, 'The Lion, the Witch, and the Wardrobe', 'C. S. Lewis');
```

Suppose you want to find books with the author name containing 'Conan Doyle' and titles that include 'Sherlock'. Normally, you would execute the following SQL query:

```sql
SELECT * FROM books WHERE author LIKE '%Conan Doyle%' and title LIKE '%Sherlock%';
-- id |             title              |       author       
-- ----+--------------------------------+--------------------
--   1 | Adventures of Sherlock Holmes  | Arthur Conan Doyle
--   3 | The Memoirs of Sherlock Holmes | Arthur Conan Doyle
-- (2 rows)
```

However, if you're aiming for a Google-like keyword search experience, you would want to achieve the same results with a keyword string such as 'conan doyle sherlock'.

### Creating an Special Index for Keyword-based Search

To create this functionality, you will need to design multiple array indexes. Here's how you can proceed:

```sql
CREATE INDEX pg_multi_book_index on books USING pgroonga
	((ARRAY[title, author]) pgroonga_text_array_full_text_search_ops_v2)
	WITH (
    normalizers = 'NormalizerNFKC150
      (
        "unify_kana", true,
        "unify_to_romaji", true,
        "unify_hyphen_and_prolonged_sound_mark", true
      )',
    tokenizer = 'TokenNgram("unify_symbol", false, "unify_alphabet", false, "unify_digit", false)'
  );
```

### Creating a Stored Function for Keyword-Based Search

To emulate a Google-like search experience within your database, you can create a stored function that accepts a keyword and returns the relevant records from the `books` table:

```sql
CREATE OR REPLACE FUNCTION gsearch(keyword text)
  RETURNS SETOF books
  LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY EXECUTE format('
    SELECT *
    FROM books
    WHERE ARRAY[title, author] &@~ $1
  ') USING keyword;
END;
$$;
```

### Adding New Permission to the books Table

You'll also need to grant the appropriate permissions to allow users to access the books table. Use the following SQL command:

```sql
GRANT SELECT ON books TO web_user;
```

### Search Example Using a Browser

Now, you can perform a keyword-based search directly from your web browser. Simply navigate to the following URL:

[`http://localhost:3000/rpc/gsearch?keyword=conan doyle sherlock`](http://localhost:3000/rpc/gsearch?keyword=conan%20doyle%20sherlock)

```json
[
  {"id":1,"title":"Adventures of Sherlock Holmes","author":"Arthur Conan Doyle"}, 
  {"id":3,"title":"The Memoirs of Sherlock Holmes","author":"Arthur Conan Doyle"}
]
```

This seamless and user-friendly approach to searching through your data with keywords is both practical and exciting. It's a fantastic way to enhance your search capabilities, don't you think?


## Using Keyword Auto Complete

PGroonga has features to implement auto complete which is explained in [the auto complete how to section][auto-complete].

Here we will explore how to implement this using PostgREST and just a simple HTML with JavaScript.

### Create Table for Auto Complete Feature

```sql
CREATE TABLE terms (
  term text,
  readings text[]
);

CREATE INDEX pgroonga_terms_prefix_search ON terms USING pgroonga
  (readings pgroonga_text_array_term_search_ops_v2);

CREATE INDEX pgroonga_terms_full_text_search ON terms USING pgroonga
  (term)
  WITH (tokenizer = 'TokenBigramSplitSymbolAlphaDigit');

INSERT INTO terms (term, readings) VALUES ('牛乳', ARRAY['ギュウニュウ', 'ミルク']);
INSERT INTO terms (term, readings) VALUES ('PostgreSQL', ARRAY['ポスグレ', 'posugure', 'postgres']);
INSERT INTO terms (term, readings) VALUES ('Groonga', ARRAY['guru-nga', 'グルンガ','ぐるんが','gurunga']);
INSERT INTO terms (term, readings) VALUES ('PGroonga', ARRAY['pi-ji-runga', 'ピージールンガ','ぴーじーるんが','pg','ピージー']);
```

### Set Up PostgREST Permission

```sql
GRANT SELECT ON terms TO web_user;
```

### Create Auto Complete End Point

```sql
CREATE OR REPLACE FUNCTION autocomplete(keyword text) RETURNS SETOF text AS $$
DECLARE
  result text[];
BEGIN
  IF keyword = '' THEN
    RETURN QUERY SELECT unnest(result);
  ELSE
    RETURN QUERY SELECT term FROM terms WHERE readings &^~ keyword;
  END IF;
END;
$$ LANGUAGE plpgsql;
```

### Create a HTML with JavaScript

Create following HTML file:

```sh
vi index.html
```

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PGroonga Auto Complete Search</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/@tarekraafat/autocomplete.js@10.2.7/dist/css/autoComplete.min.css">
    <style>
        .center-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
    </style>
  </head>
  <body>
    <div class="center-container">
        <form name="search" id="searchForm">
            <input type="search" size="60" maxlength="60" name="key" id="autoComplete">
        </form>

        <script src="https://cdn.jsdelivr.net/npm/@tarekraafat/autocomplete.js@10.2.7/dist/autoComplete.min.js">
        </script>
        <script type="text/javascript">
            const searchForm = document.getElementById('searchForm');

            searchForm.addEventListener('submit', async (event) => {
                event.preventDefault();
                const query = document.getElementById('autoComplete').value;
                
                if (query.length === 0) {
                    return;
                }

                const params = new URLSearchParams({keywords: query});
                const response = await fetch(`http://localhost:3000/rpc/find_title?${params.toString()}`);
                const result = await response.json();

                const preElement = document.getElementById('output');
                if (result.length > 0) {
                    const formattedValue = JSON.stringify(result, null, 2);
                    preElement.textContent = formattedValue;
                } else {
                    preElement.textContent = 'No results found';
                }
            });

            const dataSource = async (query) => {
                const params = new URLSearchParams({keyword: query});
                const source = await fetch(`http://localhost:3000/rpc/autocomplete?${params.toString()}`);
                return await source.json();
            };

            const autoCompleteJS = new autoComplete({
                placeHolder: "Enter a keyword",
                data: {
                    src: dataSource
                },
                searchEngine: (query, record) => record,
                events: {
                    input: {
                        selection: (event) => {
                            const selection = event.detail.selection.value;
                            autoCompleteJS.input.value = selection;
                        }
                    }
                },
                submit: true
            });
        </script>
        <pre id="output"></pre>
    </div>
  </body>
</html>
```

### Run PostgREST as API backend

Run your PostgREST service using following command:

```sh
postgrest memo.conf
```

### Open html and Try Out

Open `index.html` with your browser. 

![PGroonga Auto Complete1](../images/postgrest/auto-complete1.png)

Type something and it will show the suggestions.

![PGroonga Auto Complete2](../images/postgrest/auto-complete2.png)

When you press `Search` button, it will performe keyword search on memos table title data.

![PGroonga Auto Complete3](../images/postgrest/auto-complete3.png)

[auto-complete]: auto-complete.html
