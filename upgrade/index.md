---
title: Upgrade
upper_level: ../
---

# Upgrade

You can upgrade PGroonga without recreating PGroonga indexes when new version doesn't have any backward incompatible change. If new version has any backward incompatible change, you need to recreate all PGroonga indexes to upgrade PGroonga.

Here is a list of compatibility ("&#x2713;" means "compatible" and "&#x2715;" means "incompatible"):

<table>
  <thead>
    <tr>

      <th scope="col">From</th>

      <th scope="col">To</th>

      <th scope="col">Compatible?</th>

      <th scope="col">Note</th>

    </tr>
  </thead>
  <tbody>
    <tr>
      <td>4.0.0</td>
      <td>4.0.0</td>
      <td>&#x2715;</td>

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

      <td>If you don't use v1 API, this is compatible. So most users must be compatible.</td>

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

        <p>But you need to recreate your PGroonga indexes that use <code>jsonb</code>.</p>

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

        <p>But you need to recreate your PGroonga indexes that use <code>timestamp (without time zone)</code></p>

      </td>
    </tr>
    <tr><td>2.0.4</td><td>2.0.5</td><td>&#x2713;</td><td></td></tr>
    <tr><td>2.0.3</td><td>2.0.4</td><td>&#x2713;</td><td></td></tr>

    <tr>
      <td>2.0.2</td>
      <td>2.0.3</td>
      <td>&#x2713;</td>
      <td>

        <p>But you need to recreate your PGroonga indexes that use <code>timestamp (without time zone)</code></p>

        <p>But you need to recreate your PGroonga indexes that use <a href="../reference/#text-array-full-text-search-ops-v2"><code>pgroonga_text_array_full_text_search_ops_v2</code> operator class</a>.</p>

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

## Incompatible case {#incompatible-case}

Here are steps to upgrade:

  1. Drop all PGroonga indexes.

  1. Drop PGroonga extension.

  1. Upgrade PGroonga binary.

  1. Install PGroonga extension.

  1. Create all PGroonga indexes again.

Here is a SQL that drops all PGroonga indexes and PGroonga extension:

```sql
DROP EXTENSION pgroonga CASCADE;
```

You can upgrade PGroonga binary by package. Or you can upgrade by building new PGroonga and override old PGroonga.

Here is a SQL that install PGroonga extension:

```sql
CREATE EXTENSION pgroonga;
```

Use [`CREATE INDEX USING pgroonga`](../reference/create-index-using-pgroonga.html) to create PGroonga indexes.

## Compatible case {#compatible-case}

Here are steps to upgrade:

  1. Disconnect from all databases that use PGroonga.

  1. Upgrade PGroonga binary.

  1. Connect to a database that uses PGroonga.

  1. Upgrade PGroonga extension.

You can upgrade PGroonga binary by package. Or you can upgrade by building new PGroonga and override old PGroonga.

Here is a SQL that upgrades PGroonga:

```sql
ALTER EXTENSION pgroonga UPDATE;
```

If you're using [`pgroonga_database` module][pgroonga-database], you also need to run the following SQL to upgrade `pgroonga_database` module:

```sql
ALTER EXTENSION pgroonga_database UPDATE;
```

## See also

  * [`CREATE EXTENSION`]({{ site.postgresql_doc_base_url.en }}/sql-createextension.html)

  * [`DROP EXTENSION`]({{ site.postgresql_doc_base_url.en }}/sql-dropextension.html)

  * [`ALTER EXTENSION`]({{ site.postgresql_doc_base_url.en }}/sql-alterextension.html)

  * [`CREATE INDEX USING pgroonga`](../reference/create-index-using-pgroonga.html)

[pgroonga-database]:../reference/modules/pgroonga-database.html
