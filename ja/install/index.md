---
title: インストール
upper_level: ../
---

# インストール

主要なプラットフォームではパッケージがあります。パッケージを使うことで簡単にPGroongaをインストールできます。

それぞれのプラットフォームごとにドキュメントがあります。それとは別にソースからPGroongaをビルドするためのドキュメントがあります。

サポートしているPostgreSQLのバージョンは次の通りです。

  * 12
  * 13
  * 14
  * 15
  * 16
  * 17
  * 18

もし、これより古いPostgreSQLを使っているなら、PGroongaをインストールする前にPostgreSQLをアップグレードしてください。

次の中から自分のプラットフォーム用のドキュメントを選んで参照してください。

  * [Debian GNU/Linux](debian.html)

    * trixie

    * bookworm

  * [Ubuntu](ubuntu.html)

    * 24.04

    * 22.04

  * [AlmaLinux](almalinux.html)

    * 10

    * 9

    * 8

  * [FreeBSD](freebsd.html)

  * [macOS](macos.html)

    * Homebrew

  * [Windows](windows.html)

{% for windows_postgresql_version in site.windows_postgresql_versions %}

    * PostgreSQL {{ windows_postgresql_version }}

{% endfor %}

もし、このリストの中に自分のプラットフォームがない場合は、[ソースからビルドしてインストールする](source.html)か[issue](https://github.com/pgroonga/pgroonga/issues/new)にリクエストを送ってください。

## 参考

  * [アンインストール][uninstall]

  * [チューニング][tuning]

[uninstall]:../uninstall/

[tuning]:../how-to/tuning.html
