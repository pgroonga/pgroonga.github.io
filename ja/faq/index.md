---
title: FAQ
---

# FAQ

## PGroongaが初期化に失敗する {#fail-initialize}

PGroongaが初期化に失敗する理由はいくつかあります。たとえば次の理由です。

  * [SELinux](#selinux)

この問題を修正してもPGroongaがまだ`pgroonga: already tried to initialize and failed`というエラーを出すときは、PostgreSQLを再起動してください。そうすれば壊れた`<data dir>/pgrn*`ファイルが自動で検出され削除されます。

### SELinux {#selinux}

SELinuxを使っている場合はPGroongaのポリシーパッケージが必要です。[ソースからPGroongaをインストール](../install/source.html)セクションにどうやって作るかが書かれています。

ポリシーパッケージをインストールする前はSELinuxのパーミッションが正しくないためPGroongaの初期化に失敗するでしょう。その場合はPostgreSQLを再起動してPGroongaの壊れたファイルを削除しなければいけません。


## PGroongaを含むマネージドサービス {#managed-pgroonga}

There is a DBaaS that includes PGroonga:

### Supabase

[Supabase](https://supabase.com/)はFirebaseのオープンソース実装です。製品開発に開発者が必要とする次のようなすべてのバックエンドの機能を提供します。PostgreSQLデータベース、認証、すぐに使えるAPI、エッジファンクション、リアルタイムサブスクリプション、ストレージ。

PostgreSQLはSupabaseのコアです。PGroongaを含む40以上のPostgreSQLの拡張機能をサポートしています。
