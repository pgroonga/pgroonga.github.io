---
title: リリース
---

# リリース

## 必要なもの

以下の環境変数を使います。

* `GROONGA_REPOSITORY`

最新のGroongaのリポジトリーへのパスを指定します。

リリースごとにGroongaのリポジトリーをcloneすることを推奨します。

以下は、 `$HOME/work/groonga/groonga.clean` を `GROONGA_REPOSITORY` に指定する例です。

  ```console
  $ mkdir -p ~/work/groonga
  $ rm -rf ~/work/groonga/groonga.clean
  $ git clone --recursive git@github.com:groonga/groonga.git ~/work/groonga/groonga.clean
  $ export GROONGA_REPOSITORY=$HOME/work/groonga/groonga.clean
  ```

* `LAUNCHPAD_UPLOADER_PGP_KEY`

GroongaのPPAのキーを指定します。

[Groonga release document about PPA](https://groonga.org/ja/docs/contribution/development/release.html#ppa)を参照してください。

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

## aunchpad.netの `nightly` リポジトリーでビルドができるか確認

Ubuntuの場合、パッケージはlaunchpad.netのPPAで提供されます。

launchpad.netには[nightly][launchpad-groonga-nightly]リポジトリーと[ppa][launchpad-groonga-nightly]リポジトリーがあります。
`nightly` はテスト用で、 `ppa` は配布用です。

タグを打つ前に、 `nightly` リポジトリーを使って、Ubuntu向けのビルドができるかどうかを確認します。

* テスト用のアーカイブファイルをローカルで作成します。

  ```console
  $ rake dist
  ```

* `~/.dput.cf` を `nightly` リポジトリーにアップロードするように変更

  以下のように `[groonga-ppa]` エントリーを変更または追加します。

  ```console
  $ vi ~/.dput.cf
  [groonga-ppa]
  fqdn = ppa.launchpad.net
  method = ftp
  incoming = ~groonga/ubuntu/nightly
  login = anonymous
  allow_unsigned_uploads = 0
  ```

  `incoming = ~groonga/ubuntu/nightly` が重要な部分です。

  もし、 `~/.dput.cf` がなければ手動で作成してください。

* `nightly` リポジトリーにアップロード

  ```console
  $ rake package:ubuntu
  ```

* ビルド結果の確認

 `nightly` リポジトリーへのアップロードが成功すると、パッケージのビルド がlaunchpad.net上で実行されます。
 パッケージのビルドに失敗した場合、ビルド結果がメールで通知されます。

## リリース用にタグを打つ

```console
$ rake tag
```

## アーカイブファイルのダウンロード

アーカイブファイル (`pgroonga-x.x.x.tar.gz`) を [GitHub release page](https://github.com/pgroonga/pgroonga/releases/latest)からダウンロードし、それをローカルのPGroongaのリポジトリーのワーキングディレクトリーに移動します。

## アーカイブファイルのアップロード

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

* `~/.dput.cf` を `ppa` リポジトリーにアップロードするように変更

  以下のように `[groonga-ppa]` エントリーを変更します。

  ```console
  $ vi ~/.dput.cf
  [groonga-ppa]
  fqdn = ppa.launchpad.net
  method = ftp
  incoming = ~groonga/ubuntu/ppa
  login = anonymous
  allow_unsigned_uploads = 0
  ```

  `incoming = ~groonga/ubuntu/ppa` が重要な部分です。

* `ppa` リポジトリーにアップロード

  ```console
  $ rake package:ubuntu
  ```

* ビルド結果の確認

パッケージのアップロードに成功すると、パッケージのビルドがlaunchpad.netにて行われます。アップロード後、ビルドに失敗するとメールで通知されます。ビルドが成功するとパッケージを[Groonga PPA][launchpad-groonga-ppa]経由でインストールできます。

### CentOS

```console
$ rake package:yum
```

### Windows

Windowsパッケージについては、何もする必要はありません。

Windowsパッケージは [GitHub Actions][github-actions-pgroonga] のアクションで自動でアップロードされます。

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

 * PostgreSQLの最新のメジャーバージョン

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

### Dockerイメージ

[Docker Hub][pgroonga-docker-hub] のDockerイメージを更新します。

[Pgroonga Docker repository][pgroonga-docker-repository] をクローンし、Dockerfileを更新します。

以下は、PGroongaのバージョンが `2.4.1` 、Groongaのバージョンが `12.0.9` の場合の例です。

```
$ mkdir -p ~/work/pgroonga
$ rm -rf ~/work/pgroonga/docker.clean
$ git clone --recursive git@github.com:pgroonga/docker.git ~/work/pgroonga/docker.clean
$ cd ~/work/pgroonga/docker.clean
$ ./update.sh 2.4.1 12.0.9 #Automatically update Dockerfiles and commit changes and create a tag.
$ git push
```

作業時には最新のバージョンを指定してください。

変更をpushすると、 [GitHub Actions of Pgroonga Docker repository][github-actions-pgroonga-docker]が [Docker Hub][pgroonga-docker-hub] のDockerイメージを自動で更新します。

## リリースアナウンス

### メーリングリスト

大きなニュースがある場合、PostgreSQLのメーリングリストにアナウンスします。

アナウンスするにはPostgreSQLのアカウントが `PGroonga project` に所属している必要があります。
`PGroonga project` への入り方は、プロジェクトメンバーに確認してください。

* https://www.postgresql.org/list/
* https://www.postgresql.org/search/?m=1&ln=pgsql-announce&q=PGroonga (PGroongaのアナウンスのアーカイブ)

## GitHub Discussions

GitHub Discussionsにリリースアナウンスを作成します。

https://github.com/pgroonga/pgroonga/discussions/categories/releases

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

[launchpad-groonga-nightly]:https://launchpad.net/~groonga/+archive/ubuntu/nightly

[groonga-org-repository]:https://github.com/groonga/groonga.org

[facebook-groonga]:https://www.facebook.com/groonga/

[pgroonga-docker-repository]:https://github.com/pgroonga/docker

[github-actions-pgroonga-docker]:https://github.com/pgroonga/docker/actions

[pgroonga-docker-hub]:https://hub.docker.com/r/groonga/pgroonga
