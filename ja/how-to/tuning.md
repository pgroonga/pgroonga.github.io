# チューニングについて

通常、PGroongaはデフォルトで高速に動くため、特別にPGroongaをチューニングする必要はありません。

しかし、非常に大きなデータベースを扱うなどいくつかのケースではPGroongaをチューニングする必要があります。PGroongaはバックエンドとしてGroongaを使っています。つまり、Groonga用のチューニング知識をPGroongaでも使えるということです。


## 基本チューニング

### `nofile`

件数の多いデータを扱うと`pgroonga.log`に下記のようなエラーが出力される場合があります：

```vim
SQLSTATE[58000]: <<Unknown error>>: 7 ERROR:  pgroonga: [insert] failed to set column value: system call error: Too many open files: [io][open] failed to open path: <base/121469/pgrn.00001C4>
```
これはGroongaのプロセスで開けるファイル数が不足している時に発生します。この不具合を防ぐには次のような`/etc/security/limits.d/groonga.conf`設定ファイルを作成します。

```vim
groonga soft nofile 10000
groonga hard nofile 10000
```

この例ではGroongaプロセスが10000以下のファイルを開く前提となります。

必要なファイル数の計算については[7.24.2.1. 1プロセスで開ける最大ファイル数](https://groonga.org/ja/docs/reference/tuning.html#the-max-number-of-open-files-per-process)を参考願います。


### `vm.overcommit_memory`

PGroongaで検索を実行していると`pgroonga.log`に下記のような警告が表示されることがあります。

```vim
vm.overcommit_memory kernel parameter should be 1: <0>: See INFO level log to resolve this
```

この警告を防ぐには `vm.overcommit_memory`カーネルパラメーターを 1 に設定します。具体的には`/etc/sysctl.d/groonga.conf`設定ファイルを作成し次の値を設定してください。

```vim
vm.overcommit_memory = 1
```

設定した内容はシステムを再起動するか、次のコマンドを実行することで反映されます。:
```bash
sudo sysctl --system
```

## より詳しい情報

より詳しいPGroongaのチューニングする場合は以下のGroongaのドキュメントを参照してください。

- [チューニング](https://groonga.org/ja/docs/reference/tuning.html)