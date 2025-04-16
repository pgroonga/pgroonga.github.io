---
title: PGroongaのチューニング方法
---

# PGroongaのチューニング方法

通常、PGroongaはデフォルトで高速に動くため、特別にPGroongaをチューニングする必要はありません。

しかし、非常に大きなデータベースを扱う必要がある場合など、PGroongaをチューニングする必要がある場合がいくつかあります。PGroongaのバックエンドはGroongaです。つまり、Groongaのチューニング方法はPGroongaにも適用できます。PGroongaをチューニングするには[Groongaのチューニングドキュメント][groonga-tuning]も参考にしてください。

## 基本的なチューニング

### `nofile`

PGroongaを使って大量のデータを挿入・更新しているとき、`pgroonga.log`に次のようなエラーが出力されていることがあります。

```text
SQLSTATE[58000]: <<Unknown error>>: 7 ERROR:  pgroonga: [insert] failed to set column value: system call error: Too many open files: [io][open] failed to open path: <base/121469/pgrn.00001C4>
```

PGroongaを使っているPostgreSQLプロセスが大量のファイルを開く必要があったのにシステムの設定で許可されていません。これを解決するには次のような内容の`/etc/security/limits.d/postgresql.conf`を作成します。

```vim
postgres soft nofile 65535
postgres hard nofile 65535
```

この例では1つのPostgreSQLプロセスは最大で65535個のファイルを開けます。

何個のファイルを開ければ十分かを計算するには[Groonga：チューニング：1プロセスで開ける最大ファイル数][groonga-tuning-nofile]を参照してください。


### `vm.overcommit_memory`

PGroongaで検索するとき、`pgroonga.log`に次のような警告が出力されていることがあります。

```text
vm.overcommit_memory kernel parameter should be 1: <0>: See INFO level log to resolve this
```

この警告を抑制するには`vm.overcommit_memory`カーネルパラメーターを`1`にする必要があります。これは次の内容の`/etc/sysctl.d/groonga.conf`を作ることで設定できます。

```vim
vm.overcommit_memory = 1
```

この設定はシステムを再起動するか次のコマンドを実行することで適用できます。

```bash
sudo sysctl --system
```

## 参考

  * [Groonga：チューニング][groonga-tuning]

[groonga-tuning]:https://groonga.org/ja/docs/reference/tuning.html

[groonga-tuning-nofile]:https://groonga.org/ja/docs/reference/tuning.html#the-max-number-of-open-files-per-process
