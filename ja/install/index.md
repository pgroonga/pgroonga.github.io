---
title: インストール
upper_level: ../
---

# インストール

主要なプラットフォームではパッケージがあります。パッケージを使うことで簡単にPGroongaをインストールできます。

それぞれのプラットフォームごとにドキュメントがあります。それとは別にソースからPGroongaをビルドするためのドキュメントがあります。

サポートしているPostgreSQLのバージョンは次の通りです。

  * 9.4
  * 9.5
  * 9.6
  * 10
  * 11

もし、これより古いPostgreSQLを使っているなら、PGroongaをインストールする前にPostgreSQLをアップグレードしてください。

次の中から自分のプラットフォーム用のドキュメントを選んで参照してください。

  * [Debian GNU/Linux](debian.html)

    * Stretch

  * [Ubuntu](ubuntu.html)

    * 16.04

    * 18.04

    * 18.10

    * 19.04

  * [CentOS](centos.html)

    * 6

    * 7

  * [Amazon Linux](amazon-linux.html)

    * 2

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

[uninstall]:../uninstall/
