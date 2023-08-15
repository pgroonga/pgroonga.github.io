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

PGroonga has features to implement auto complete which is explained in [this how to section](https://pgroonga.github.io/how-to/auto-complete.html).

Here we will explor how to implement this using PostgREST and Svelte.

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
RANT SELECT ON terms TO web_user;
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

### Create a Frontend

We are using Svelte to create our frontend using Svelte.

#### Create Svelte

```bash
npm create vite@latest pgautocomplete -- --template svelte
cd pgautocomplete
npm install
```

#### Add Search Page with Auto Complete Feature

1. Add Search Icon by creating `public/search.svg`

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
  <circle cx="7" cy="7" r="6" stroke="#FFA07A" stroke-width="1" fill="none" />
  <line x1="11" y1="11" x2="15" y2="15" stroke="#FFA07A" stroke-width="1"/>
</svg>
```

2. Create Search Page just replace entire `src/App.svelte`

```html
<script>

  let keyword = '';
  let autosuggest = [];
  let searchResults = [];

  const fetchSuggestions = async () => {
      const response = await fetch(`http://localhost:3000/rpc/autocomplete?keyword=${keyword}`);
      const data = await response.json();
      autosuggest = data;
  }

  $: keywordEntered(keyword);

  function keywordEntered(keyword) {
      fetchSuggestions();
  }

  function selectSuggestion(suggestion) {
      keyword = suggestion;
      autosuggest = [];
  }

  async function gsearch(event) {
      event.preventDefault();
      if (keyword.trim() === '') {
        searchResults = []; // clear search results if keyword is empty
        return;
      }
      const response = await fetch(`http://localhost:3000/rpc/find_title?keywords=${keyword}`);
      const data = await response.json();
      searchResults = data;
  }

</script>

<main>
  <form on:submit={gsearch}>
    <div class="autoComplete_wrapper">
      <input id="autoComplete" type="text" bind:value={keyword} placeholder="Enter keyword" />
      <div>
          {#each autosuggest as suggestion}
              <button type="submit" on:click={() => selectSuggestion(suggestion)}>{suggestion}</button>
          {/each}
      </div>
    </div>
  </form>

  {#if searchResults.length > 0}
    <h2>Search Results</h2>
    {#each searchResults as result}
      <div class="result">
        <p>Title: {result.title}</p>
        <p>Content: {result.content}</p>
      </div>
    {/each}
  {/if}
</main>


<style>
  .result {
    margin: 0.25rem;
    display: flex;
  }

  .autoComplete_wrapper {
    display: inline-block;
    position: relative;
    }

  .autoComplete_wrapper > input {
    height: 3rem;
    width: 370px;
    margin: 0;
    padding: 0 2rem 0 3.2rem;
    box-sizing: border-box;
    -moz-box-sizing: border-box;
    -webkit-box-sizing: border-box;
    font-size: 1rem;
    text-overflow: ellipsis;
    color: rgba(255, 122, 122, 0.3);
    outline: none;
    border-radius: 10rem;
    border: 0.05rem solid rgba(255, 122, 122, 0.5);
    background-image: url('/search.svg');
    background-size: 1.4rem;
    background-position: left 1.05rem top 0.8rem;
    background-repeat: no-repeat;
    background-origin: border-box;
    background-color: #fff;
    transition: all 0.4s ease;
    -webkit-transition: all -webkit-transform 0.4s ease;
  }

  .autoComplete_wrapper > input::placeholder {
    color: rgba(255, 122, 122, 0.5);
    transition: all 0.3s ease;
    -webkit-transition: all -webkit-transform 0.3s ease;
  }

  .autoComplete_wrapper > input:hover::placeholder {
    color: rgba(255, 122, 122, 0.6);
    transition: all 0.3s ease;
    -webkit-transition: all -webkit-transform 0.3s ease;
  }

  .autoComplete_wrapper > input:focus::placeholder {
    padding: 0.1rem 0.6rem;
    font-size: 0.95rem;
    color: rgba(255, 122, 122, 0.4);
  }

  .autoComplete_wrapper > input:focus::selection {
    background-color: rgba(255, 122, 122, 0.15);
  }

  .autoComplete_wrapper > input::selection {
    background-color: rgba(255, 122, 122, 0.15);
  }

  .autoComplete_wrapper > input:hover {
    color: rgba(255, 122, 122, 0.8);
    transition: all 0.3s ease;
    -webkit-transition: all -webkit-transform 0.3s ease;
  }

  .autoComplete_wrapper > input:focus {
    color: rgba(255, 122, 122, 1);
    border: 0.06rem solid rgba(255, 122, 122, 0.8);
  }

  .autoComplete_wrapper > div {
    position: absolute;
    max-height: 226px;
    overflow-y: scroll;
    box-sizing: border-box;
    left: 0;
    right: 0;
    margin: 0.5rem 0 0 0;
    padding: 0;
    z-index: 1;
    border-radius: 0.6rem;
    background-color: #fff;
    border: 1px solid rgba(33, 33, 33, 0.07);
    box-shadow: 0 3px 6px rgba(149, 157, 165, 0.15);
    outline: none;
    transition: opacity 0.15s ease-in-out;
    -moz-transition: opacity 0.15s ease-in-out;
    -webkit-transition: opacity 0.15s ease-in-out;
  }

  .autoComplete_wrapper > div:empty {
    display: block;
    opacity: 0;
    transform: scale(0);
  }

  .autoComplete_wrapper > div > button {
    display: block;
    margin: 0.3rem;
    padding: 0.3rem 0.5rem;
    text-align: left;
    font-size: 1rem;
    color: #212121;
    border-radius: 0.35rem;
    background-color: rgba(255, 255, 255, 1);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    border: none;
    transition: all 0.2s ease;
  }

  .autoComplete_wrapper > div > button:hover {
    cursor: pointer;
    background-color: rgba(255, 122, 122, 0.15);
  }

  @media only screen and (max-width: 600px) {
    .autoComplete_wrapper > input {
      width: 18rem;
    }
  }
</style>
```

### Run PostgREST as API backend

Run your PostgREST service using following command:

```sh
postgrest memo.conf
```

### Run Svelte and Try Out

Run your Svelte frontend using following command:

```sh
npm run dev
```

Now, access to http://localhost:5173 and test the auto complete feature.

![PGroonga Auto Complete1](../images/postgres/pgautocomplete1.png)

Hit Enter key to search.

![PGroonga Auto Complete2](../images/postgres/pgautocomplete2.png)
