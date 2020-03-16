---
title: リリース方法
---

# リリース方法

## 必要なもの

以下の環境変数を使います。

* APACHE_ARROW_REPOSITORY

* GITHUB_TOKEN

* GROONGA_REPOSITORY

* LAUNCHPAD_UPLOADER_PGP_KEY

Docker上でCentOS6を実行するため、以下の手順でGRUBのオプションを更新します。

1. `/etc/default/grub.d/vsyscall-emulate.cfg` を作成して、以下の内容を書きます。

    ```
    GRUB_CMDLINE_LINUX_DEFAULT="${GRUB_CMDLINE_LINUX_DEFAULT} vsyscall=emulate"
    ```

2. `update-grub` を実行します。

3. `reboot` を実行します。

## バージョンをあげる

```shell
% rake version:update NEW_VERSION=x.x.x
```

## DebianとCentOSのパッケージの変更履歴を更新

```shell
% cd package
% rake package:version:update
```

## AppVeyorのPostgreSQLのバージョンを更新

`appveyor.yml` のPostgreSQLのバージョンを更新します。

## パッケージ作成可能かどうか確認

以下のCIがグリーンかどうかを確認します。

* [GitHub Actions Workflow for Linux](https://github.com/pgroonga/pgroonga/actions?query=workflow%3ALinux)

* [AppVeyor CI](https://ci.appveyor.com/project/groonga/pgroonga)

## リリース用にタグを打つ

```shell
% cd package
% rake tag
```

## アーカイブを作成・アップロード

```shell
% cd package
% rake package:source
```

## リリース用パッケージを作成

### Debian

```shell
% cd package
% rake package:apt
```

### Ubuntu

Ubuntuの場合、パッケージはlaunchpad.netのPPAで提供されます。

```shell
% cd package
% rake package:ubuntu
```

パッケージのアップロードに成功すると、パッケージのビルドがlaunchpad.netにて行われます。アップロードに成功するとメールで通知が届きます。ビルドが成功するとパッケージを[Groonga PPA](https://launchpad.net/~groonga/+archive/ubuntu/ppa)経由でインストールできます。

### CentOS

```shell
% cd package
% rake package:yum
```

### Windows

Windows向けには、 [AppVeyor CI](https://ci.appveyor.com/project/groonga/pgroonga) の成果物を使っています。

```shell
% cd package
% rake package:windows:upload
```

## 変更点を記述

`news/index.md` に前回のバージョンからの変更をまとめます。

`_config.yml` の以下の項目も更新します。

* pgroonga_version:

 * PGroongaの最新バージョン

* pgroonga_release_date:

 * 最新版のリリース日

* copyright_year:

 * 年が変わったら更新

* postgresql_doc_base_url:

 * PostgreSQLのバージョンが変わったら更新

* windows_postgresql_versions:

 * Windows版のPostgreSQLのバージョンが変わったら更新

* latest_postgresql_version:

 * POstgreSQLの最新のメジャーバージョン

* freebsd_postgresql_version:

 * FreeBSD版のPostgreSQLの最新バージョン

* amazon_linux_postgresql_version:

 * AmazonLinux版のPostgreSQLの最新バージョン

* development_postgresql_version:

 * マイナーバージョンを含むPostgreSQLの最新バージョン

## リポジトリーの更新

以下の手順でリポジトリーを更新します。

```shell
# Clone packages.groonga.org repository
% git clone git@github.com:groonga/packages.groonga.org.git

# Update repositories for Debian and CentOS.
% cd packages.groonga.org
% rake apt
% rake yum
```

## リリースアナウンス

### メーリングリスト

以下のアドレスにリリースアナウンスを送信します。

* groonga-dev(Japanese) groonga-dev@lists.osdn.me.

* groonga-talk(English) groonga-talk@lists.sourceforge.net.

### ブログ

http://groonga.org/blog/ と http://groonga.org/blog/ に公開されているブログにリリースアナウンスを記載します。

以下の手順でブログを更新します。

1. [blog source repository](https://github.com/groonga/groonga.org) をクローン。

2. [blog source repository](https://github.com/groonga/groonga.org) 内に以下のファイルを作成。

   * groonga.org/en/_post/(release-date)-pgroonga-(pgroonga-version).md

   * groonga.org/ja/_post/(release-date)-pgroonga-(pgroonga-version).md

3. ブログを確認

 以下の手順でブログを確認できます。

 1. Jekyllのインストール

     ```shell
     % sudo gem install jekyll jekyll-paginate RedCloth rdiscount therubyracer
     ```

 2. Webサーバーの開始

     ```shell
     % jekyll serve --watch
     ```

 3. http://localhost:4000 にブラウザーでアクセス

### Facebook

Facebookに [Groongaグループ](https://www.facebook.com/groonga/) があります。Groongaグループのメンバーになると、個人のアカウントではなく、Groongaグループのメンバーとして投稿できます。

ブログやニュースを元にアナウンスを投稿します。

### Twitter

PGroongaのブログエントリには「リンクをあなたのフォロワーに共有する」ためのツイートボタンがあるので、そのボタンを使ってリリースアナウンスします。(画面下部に配置されている)このボタンを経由する場合、ツイート内容に自動的にリリースタイトルとリリースエントリのURLが挿入されます。

この作業はblogroongaの英語版、日本語版それぞれで行います。 あらかじめgroongaアカウントでログインしておくとアナウンスを円滑に行うことができます。
