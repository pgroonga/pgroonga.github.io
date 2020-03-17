---
title: テスト
---

# テスト

新しい機能を実装した時・バグを直した時は、リグレッションテストを作ります。

## 概要

リグレッションテストは`sql/`ディレクトリー以下にあります。例えば、`sql/full-text-search/text/single/match-v2/indexscan.sql`は次のケース用のテストです。

  * 全文検索

  * `text`型

  * [`&@`][match-v2]（マッチ演算子v2）

  * インデックススキャン

出力の期待値は`expected/`ディレクトリー以下にあります。ディレクトリー構造は`sql/`と同じですが、拡張子は`.out`になります。たとえば、`expected/full-text-search/text/single/match-v2/indexscan.out`となります。

## リグレッションテストの作成方法

新しいファイルを`sql/`以下に作り、SQLで作ったテストシナリオをそのファイルに書きます。それからこのファイルを次のように実行します。

```console
% PATH=/tmp/local/bin:$PATH test/run-sql-test.sh sql/.../XXX.sql
```

この新しく作ったテストは失敗します。`test/run-sql-test.sh`はこのテストシナリオの出力を表示します。出力が正しければ、出力をコピーして`expected/.../XXX.out`に貼ります。

`expected/.../XXX.out`を更新してテストがパスするようになったかを確認してください。

```console
% PATH=/tmp/local/bin:$PATH test/run-sql-test.sh sql/.../XXX.sql
```

[match-v2]:../reference/operators/match-v2.html
