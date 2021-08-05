---
title: リリース
---

# リリース

## 必要なもの

以下の環境変数を使います。

* `GITHUB_TOKEN`

* `GROONGA_REPOSITORY`

* `LAUNCHPAD_UPLOADER_PGP_KEY`

## バージョンをあげる

```console
$ rake version:update NEW_VERSION=x.x.x
```

## DebianとCentOSのパッケージの変更履歴を更新

```console
$ rake package:version:update
```

## パッケージ作成可能かどうか確認

以下のCIがグリーンかどうかを確認します。

* [GitHub Actions][github-actions-pgroonga]

## リリース用にタグを打つ

```console
$ rake tag
```

## アーカイブを作成・アップロード

```console
$ rake package:source
```

## リリース用パッケージを作成

### Debian GNU/Linux

```console
$ rake package:apt
```

### Ubuntu

Ubuntuの場合、パッケージはlaunchpad.netのPPAで提供されます。

```console
$ rake package:ubuntu
```

パッケージのアップロードに成功すると、パッケージのビルドがlaunchpad.netにて行われます。アップロードに成功するとメールで通知が届きます。ビルドが成功するとパッケージを[Groonga PPA][launchpad-groonga-ppa]経由でインストールできます。

### CentOS

```console
$ rake package:yum
```

### Windows

Windows向けには、 [GitHub Actions][github-actions-pgroonga]の成果物を使っています。

```console
$ rake package:windows:upload
```

## 変更点を記述

新しいリリースをアナウンスするために https://github.com/pgroonga/pgroonga.github.io/ を更新する必要があります。

`news/index.md` に前回のバージョンからの変更をまとめます。

`_config.yml` の以下の項目も更新します。

* `pgroonga_version`:

 * PGroongaの最新バージョン

* `pgroonga_release_date`:

 * 最新版のリリース日

* `postgresql_doc_base_url`:

 * PostgreSQLのバージョンが変わったら更新

* `windows_postgresql_versions`:

 * Windows版のPostgreSQLのバージョンが変わったら更新

* `latest_postgresql_version`:

 * POstgreSQLの最新のメジャーバージョン

* `freebsd_postgresql_version`:

 * FreeBSD版のPostgreSQLの最新バージョン

* `amazon_linux_postgresql_version`:

 * AmazonLinux版のPostgreSQLの最新バージョン

* `development_postgresql_version`:

 * マイナーバージョンを含むPostgreSQLの最新バージョン

## リポジトリーの更新

以下の手順でリポジトリーを更新します。

packages.groonga.orgリポジトリーをクローンします。

```console
$ git clone git@github.com:groonga/packages.groonga.org.git
```

Debian GNU/LinuxとCentOS用にリポジトリーを更新します。

```console
$ cd packages.groonga.org
$ rake apt
$ rake yum
```

## リリースアナウンス

### メーリングリスト

以下のアドレスにリリースアナウンスを送信します。

* groonga-dev（日本語） `groonga-dev@lists.osdn.me`

* groonga-talk（英語） `groonga-talk@lists.sourceforge.net`

### ブログ

https://groonga.org/blog/ と https://groonga.org/ja/blog/ に公開されているブログにリリースアナウンスを記載します。

以下の手順でブログを更新します。

[ブログのソースリポジトリー][groonga-org-repository]をクローン。

[ブログのソースリポジトリー][groonga-org-repository]内に以下のファイルを作成。

* `groonga.org/en/_post/(release-date)-pgroonga-(pgroonga-version).md`

* `groonga.org/ja/_post/(release-date)-pgroonga-(pgroonga-version).md`

以下の手順でブログを確認できます。

必要なライブラリーをインストールします。

```console
$ bundle update
```

Webサーバーを起動します。

```console
$ jekyll serve --watch
```

http://localhost:4000 にWebブラウザーでアクセスします。

### Facebookでリリースアナウンス

Facebookに [Groongaグループ][facebook-groonga] があります。[Groongaグループ][facebook-groonga]のメンバーになると、個人のアカウントではなく、Groongaグループのメンバーとして投稿できます。

ブログやニュースを元にアナウンスを投稿します。

### Twitterでリリースアナウンス

PGroongaのブログエントリには「リンクをあなたのフォロワーに共有する」ためのツイートボタンがあるので、そのボタンを使ってリリースアナウンスします。(画面下部に配置されている)このボタンを経由する場合、ツイート内容に自動的にリリースタイトルとリリースエントリのURLが挿入されます。

この作業はblogroongaの英語版、日本語版それぞれで行います。 あらかじめgroongaアカウントでログインしておくとアナウンスを円滑に行うことができます。

[github-actions-workflow-linux]:https://github.com/pgroonga/pgroonga/actions?query=workflow%3ALinux

[appveyor-pgroonga]:https://ci.appveyor.com/project/groonga/pgroonga

[github-actions-pgroonga]:https://github.com/pgroonga/pgroonga/actions

[launchpad-groonga-ppa]:https://launchpad.net/~groonga/+archive/ubuntu/ppa

[groonga-org-repository]:https://github.com/groonga/groonga.org

[facebook-groonga]:https://www.facebook.com/groonga/
