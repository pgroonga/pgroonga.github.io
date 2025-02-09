---
title: アップグレード
upper_level: ../
---

# アップグレード

新しいバージョンのPGroongaが非互換の変更を含んでいない場合はPGroongaのインデックスを再作成せずにアップグレードできます。新しいバージョンが1つでも非互換の変更を含んでいればPGroongaをアップグレードする際にすべてのPGroongaのインデックスを再作成する必要があります。

以下は互換性のリストです。「&#x2713;」は「互換」、「&#x2715;」は「非互換」という意味です。

<table>
  <thead>
    <tr>

      <th scope="col">アップグレード元バージョン</th>

      <th scope="col">アップグレード先バージョン</th>

      <th scope="col">互換？</th>

      <th scope="col">補足</th>

    </tr>
  </thead>
  <tbody>
    <tr>
      <td>4.0.0</td>
      <td>4.0.0</td>
      <td>&##2715;</td>

      <td>If you don't use <code>pgroonga</code> schema that is deprecated since PGroonga 2.0.0, there is no incompatible change. You can upgrade with the "compatible case" steps. If you're still using <code>pgroonga</code> schema, you must migrate to <code>pgroonga_*</code> API from <code>pgroonga.*</code> API before you upgrade to 4.0.0.</td>

    </tr>
    <tr><td>3.2.4</td><td>3.2.5</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.2.3</td><td>3.2.4</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.2.3</td><td>3.2.4</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.2.2</td><td>3.2.3</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.2.1</td><td>3.2.2</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.2.0</td><td>3.2.1</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.1.9</td><td>3.2.0</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.1.8</td><td>3.1.9</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.1.7</td><td>3.1.8</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.1.6</td><td>3.1.7</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.1.5</td><td>3.1.6</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.1.4</td><td>3.1.5</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.1.3</td><td>3.1.4</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.1.2</td><td>3.1.3</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.1.1</td><td>3.1.2</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.1.0</td><td>3.1.1</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.0.9</td><td>3.1.0</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.0.8</td><td>3.0.9</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.0.7</td><td>3.0.8</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.0.6</td><td>3.0.7</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.0.5</td><td>3.0.6</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.0.4</td><td>3.0.5</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.0.3</td><td>3.0.4</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.0.2</td><td>3.0.3</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.0.1</td><td>3.0.2</td><td>&#x2713;</td><td></td></tr>
    <tr><td>3.0.0</td><td>3.0.1</td><td>&#x2713;</td><td></td></tr>

    <tr class="danger">
      <td>2.4.7</td>
      <td>3.0.0</td>
      <td>&#x2715;</td>

      <td>v1 APIを使っていない場合は互換です。つまり、多くのユーザーは互換なはずです。</td>

    </tr>

    <tr><td>2.4.6</td><td>2.4.7</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.4.5</td><td>2.4.6</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.4.4</td><td>2.4.5</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.4.3</td><td>2.4.4</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.4.2</td><td>2.4.3</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.4.1</td><td>2.4.2</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.4.0</td><td>2.4.1</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.3.9</td><td>2.4.0</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.3.8</td><td>2.3.9</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.3.7</td><td>2.3.8</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.3.6</td><td>2.3.7</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.3.5</td><td>2.3.6</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.3.4</td><td>2.3.5</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.3.3</td><td>2.3.4</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.3.2</td><td>2.3.3</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.3.1</td><td>2.3.2</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.3.0</td><td>2.3.1</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.2.9</td><td>2.3.0</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.2.8</td><td>2.2.9</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.2.7</td><td>2.2.8</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.2.6</td><td>2.2.7</td><td>&#x2713;</td><td></td></tr>
    <tr>
      <td>2.2.5</td>
      <td>2.2.6</td>
      <td>&#x2713;</td>
      <td>

        <p>ただし、<code>jsonb</code>を使ったPGroongaのインデックスがある場合は再作成する必要があります。</p>

      </td>
    </tr>
    <tr><td>2.2.4</td><td>2.2.5</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.2.3</td><td>2.2.4</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.2.2</td><td>2.2.3</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.2.1</td><td>2.2.2</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.2.0</td><td>2.2.1</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.1.9</td><td>2.2.0</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.1.8</td><td>2.1.9</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.1.7</td><td>2.1.8</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.1.6</td><td>2.1.7</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.1.4</td><td>2.1.6</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.1.3</td><td>2.1.4</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.1.2</td><td>2.1.3</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.1.1</td><td>2.1.2</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.1.0</td><td>2.1.1</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.0.9</td><td>2.1.0</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.0.8</td><td>2.0.9</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.0.7</td><td>2.0.8</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.0.6</td><td>2.0.7</td><td>&#x2713;</td><td></td></tr>
    <tr>
      <td>2.0.5</td>
      <td>2.0.6</td>
      <td>&#x2713;</td>
      <td>

        <p>ただし、<code>timestamp (without time zone)</code>を使ったPGroongaのインデックスがある場合は再作成する必要があります。</p>

      </td>
    </tr>
    <tr><td>2.0.4</td><td>2.0.5</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.0.3</td><td>2.0.4</td><td>&#x2713;</td><td></td></tr>

    <tr>
      <td>2.0.2</td>
      <td>2.0.3</td>
      <td>&#x2713;</td>
      <td>

        <p>ただし、<code>timestamp (without time zone)</code>を使ったPGroongaのインデックスがある場合は再作成する必要があります。</p>

        <p>ただし、<a href="../reference/#text-array-full-text-search-ops-v2"><code>pgroonga_text_array_full_text_search_ops_v2</code>演算子クラス</a>を使ったPGroongaのインデックスがある場合は再作成する必要があります。</p>

      </td>
    </tr>
    <tr><td>2.0.1</td><td>2.0.2</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.0.0</td><td>2.0.1</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.2.3</td><td>2.0.0</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.2.2</td><td>1.2.3</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.2.1</td><td>1.2.2</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.2.0</td><td>1.2.1</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.1.9</td><td>1.2.0</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.1.8</td><td>1.1.9</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.1.7</td><td>1.1.8</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.1.6</td><td>1.1.7</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.1.5</td><td>1.1.6</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.1.4</td><td>1.1.5</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.1.3</td><td>1.1.4</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.1.2</td><td>1.1.3</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.1.1</td><td>1.1.2</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.1.0</td><td>1.1.1</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.0.9</td><td>1.1.0</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.0.8</td><td>1.0.9</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.0.7</td><td>1.0.8</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.0.6</td><td>1.0.7</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.0.5</td><td>1.0.6</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.0.4</td><td>1.0.5</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.0.3</td><td>1.0.4</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.0.2</td><td>1.0.3</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.0.1</td><td>1.0.2</td><td>&#x2713;</td><td></td></tr>
    <tr><td>1.0</td><td>1.0.1</td><td>&#x2713;</td><td></td></tr>
    <tr class="danger"><td>0.9</td><td>1.0</td><td>&#x2715;</td><td></td></tr>
    <tr><td>0.8</td><td>0.9</td><td>&#x2713;</td><td></td></tr>
    <tr class="danger"><td>0.7</td><td>0.8</td><td>&#x2715;</td><td></td></tr>
  </tbody>
</table>

## 非互換の場合 {#incompatible-case}

アップグレード手順は次の通りです。

  1. すべてのPGroongaを使ったインデックスを削除します。

  1. PGroonga拡張を削除します。

  1. PGroongaのバイナリーをアップグレードします。

  1. PGroonga拡張をインストールします。

  1. すべてのPGroongaのインデックスを作り直します。

すべてのPGroongaのインデックスを削除して、PGroonga拡張も削除するSQLは次の通りです。

```sql
DROP EXTENSION pgroonga CASCADE;
```

PGroongaのバイナリーはパッケージでアップグレードできます。あるいは、新しいPGroongaをビルドして古いPGroongaに上書きすることでもアップグレードできます。

PGroonga拡張をインストールするSQLは次の通りです。

```sql
CREATE EXTENSION pgroonga;
```

PGroongaを使ってインデックスを作るには[`CREATE INDEX USING pgroonga`](../reference/create-index-using-pgroonga.html)を使ってください。

## 互換性がある場合 {#compatible-case}

アップグレード手順は次の通りです。

  1. PGroongaを使っているすべてのデータベースへの接続を切断します。

  1. PGroongaのバイナリーをアップグレードします。

  1. PGroongaを使っているデータベースに接続します。

  1. PGroonga拡張をアップグレードします。

PGroongaのバイナリーはパッケージでアップグレードできます。あるいは、新しいPGroongaをビルドして古いPGroongaに上書きすることでもアップグレードできます。

PGroongaをアップグレードするSQLは次の通りです。

```sql
ALTER EXTENSION pgroonga UPDATE;
```

もし[`pgroonga_database`モジュール][pgroonga-database]を使っているなら、次のSQLを実行して`pgroonga_database`モジュールをアップグレードする必要があります。

```sql
ALTER EXTENSION pgroonga_database UPDATE;
```

## 参考

  * [`CREATE EXTENSION`]({{ site.postgresql_doc_base_url.ja }}/sql-createextension.html)

  * [`DROP EXTENSION`]({{ site.postgresql_doc_base_url.ja }}/sql-dropextension.html)

  * [`ALTER EXTENSION`]({{ site.postgresql_doc_base_url.ja }}/sql-alterextension.html)

  * [`CREATE INDEX USING pgroonga`](../reference/create-index-using-pgroonga.html)

[pgroonga-database]:../reference/modules/pgroonga-database.html
