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
CREATE ROLE web_user nologin;
GRANT USAGE ON SCHEMA public TO web_user;
GRANT SELECT ON memos TO web_user;

CREATE ROLE authenticator noinherit login password 'mypassword';
GRANT web_user to authenticator;
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
[
  {"id":1,"title":"PostgreSQLはリレーショナル・データベース管理システムです。","content":"すごいでしょう"},
  {"id":2,"title":"Groongaは日本語対応の高速な全文検索エンジンです。","content":"スワイショウ"},
  {"id":3,"title":"PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。","content":"ハバナイスデー"},
  {"id":4,"title":"groongaコマンドがあります。","content":"今日はコンバンワこのくにわ"}
]
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

```console
$ curl --get --data-urlencode keywords=コマンド http://localhost:3000/rpc/find_title
[{"id":4,"title":"groongaコマンドがあります。","content":"今日はコンバンワこのくにわ"}]
```

### Search in romaji

Open your browser and access the following:

[`http://localhost:3000/rpc/find_title?keywords=desu`](http://localhost:3000/rpc/find_title?keywords=desu)

```json
[
  {"id":1,"title":"PostgreSQLはリレーショナル・データベース管理システムです。","content":"すごいでしょう"},
  {"id":2,"title":"Groongaは日本語対応の高速な全文検索エンジンです。","content":"スワイショウ"},
  {"id":3,"title":"PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。","content":"ハバナイスデー"}
]
```

### Searching hiragana and katakana in hiragana or katakana

Open your browser and access the following:

[`http://localhost:3000/rpc/find_content?keywords=ショウ`](http://localhost:3000/rpc/find_content?keywords=ショウ)

```json
[
  {"id":1,"title":"PostgreSQLはリレーショナル・データベース管理システムです。","content":"すごいでしょう"},
  {"id":2,"title":"Groongaは日本語対応の高速な全文検索エンジンです。","content":"スワイショウ"}
]
```

### AND search

Open your browser and access the following:

[`http://localhost:3000/rpc/find_title?keywords=nga です`](http://localhost:3000/rpc/find_title?keywords=nga%20です)

```json
[
  {"id":2,"title":"Groongaは日本語対応の高速な全文検索エンジンです。","content":"スワイショウ"},
  {"id":3,"title":"PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。","content":"ハバナイスデー"}
]
```

### OR search

Open your browser and access the following:

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

Open your browser and access the following:

[`http://localhost:3000/rpc/find_title?keywords=nga -pg`](http://localhost:3000/rpc/find_title?keywords=nga%20-pg)

```json
[
  {"id":2,"title":"Groongaは日本語対応の高速な全文検索エンジンです。","content":"スワイショウ"}, 
  {"id":4,"title":"groongaコマンドがあります。","content":"今日はコンバンワこのくにわ"}
]
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
                
                if(query.length === 0) {
                    return;
                }

                const response = await fetch(`http://localhost:3000/rpc/find_title?keywords=${query}`);
                const result = await response.json();

                const preElement = document.getElementById('output');
                if(result.length > 0) {
                    const formattedValue = JSON.stringify(result, null, 2);
                    preElement.textContent = formattedValue;
                } else {
                    preElement.textContent = 'No results found';
                }
            });

            const dataSource = async (query) => {
                const source = await fetch(`http://localhost:3000/rpc/autocomplete?keyword=${query}`);
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