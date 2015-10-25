---
title: アップグレード
layout: ja
---

# アップグレード

パッケージでPGroongaをインストールした場合は、パッケージマネージャーを使って新しいPGroongaをインストールしてください。

自分でPGroongaをビルドしてインストールした場合は、新しいPGroongaをビルドして古いPGroongaを上書きしてください。

古いPGroongaのバイナリーを新しいPGroongaのバイナリーで置き換えた後、PGroongaを使っているデータベースで次のSQLを実行してください。

```sql
ALTER EXTENSION pgroonga UPDATE;
```

これはPGroongaの設定をアップグレードします。

## 参考

  * [`ALTER EXTENSION`](http://www.postgresql.jp/document/{{ site.postgresql_short_version }}/html/sql-alterextension.html)
