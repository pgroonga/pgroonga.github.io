---
title: リリース
---

# リリース

## 必要なもの

### 環境変数

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

[Groongaのリリースドキュメントの PPA用の鍵の登録 セクション](https://groonga.org/ja/docs/contribution/development/release.html#ppa)を参照してください。

* `GITHUB_ACCESS_TOKEN`

  GitHubのアクセストークンを指定します。

  [GitHub 個人用アクセス トークンを管理する](https://docs.github.com/ja/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)

### コマンド

リリースに必要なコマンドがあるのでインストールします。

```console
$ ./setup-release.sh
```

## バージョンをあげる

```console
$ rake version:update NEW_VERSION=x.x.x
```

## debとRPMのパッケージの変更履歴を更新

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

## アーカイブファイルのアップロード

```console
$ rake package:source
```

## リリース用パッケージを作成

### deb

```console
$ rake package:apt
```

### Ubuntu

Ubuntuの場合、パッケージはlaunchpad.netのPPAで提供されます。

* `ppa` リポジトリーにアップロード

  ```console
  $ rake package:ubuntu LAUNCHPAD_UPLOADER_PGP_KEY=xxxxxxx
  ```

* ビルド結果の確認

  パッケージのアップロードに成功すると、パッケージのビルドがlaunchpad.netにて行われます。アップロード後、ビルドに失敗するとメールで通知されます。ビルドが成功するとパッケージを[Groonga PPA][launchpad-groonga-ppa]経由でインストールできます。

### RPM

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

* `development_postgresql_version`:

 * マイナーバージョンを含むPostgreSQLの最新バージョン

## リポジトリーの更新

以下の手順でリポジトリーを更新します。

packages.groonga.orgリポジトリーをクローンします。

```console
$ git clone git@github.com:groonga/packages.groonga.org.git
```

debとRPM用にリポジトリーを更新します。

```console
$ cd packages.groonga.org
$ rake apt
$ rake yum
```

### Dockerイメージの更新

[Docker Hub][pgroonga-docker-hub]のPGroongaのDockerイメージを更新します。

[PGroongaのDockerリポジトリー][pgroonga-docker-repository]をクローンし、リポジトリーの中のDockerfileを更新します。

以下は、PGroongaのバージョンが `2.4.1` 、Groongaのバージョンが `12.0.9` の場合の例です。

```
$ mkdir -p ~/work/pgroonga
$ rm -rf ~/work/pgroonga/docker.clean
$ git clone --recursive git@github.com:pgroonga/docker.git ~/work/pgroonga/docker.clean
$ cd ~/work/pgroonga/docker.clean
$ ./update.sh 2.4.1 12.0.9 #Automatically update Dockerfiles and commit changes and create a tag.
$ git push --tags
```

作業時には最新のバージョンを指定してください。

[PGroongaのDockerリポジトリーのGithub Actions][github-actions-pgroonga-docker]が成功しているのを確認したら、タグをpushします。

```console
$ git push --tags
```

タグをpushすると、[PGroongaのDockerリポジトリーのGithub Actions][github-actions-pgroonga-docker]が[Docker Hub][pgroonga-docker-hub]のPGroongaのDockerイメージを自動で更新します。

## リリースアナウンス

### メーリングリスト

大きなニュースがある場合、PostgreSQLのメーリングリストにアナウンスします。

アナウンスするにはPostgreSQLのアカウントが `PGroonga project` に所属している必要があります。
`PGroonga project` への入り方は、プロジェクトメンバーに確認してください。

* [https://www.postgresql.org/list/](https://www.postgresql.org/list/)
* [https://www.postgresql.org/search/?m=1&ln=pgsql-announce&q=PGroonga](https://www.postgresql.org/search/?m=1&ln=pgsql-announce&q=PGroonga) (PGroongaのアナウンスのアーカイブ)

### ブログ

[https://groonga.org/blog/](https://groonga.org/blog/) と [https://groonga.org/ja/blog/](https://groonga.org/ja/blog/) に公開されているブログにリリースアナウンスを記載します。

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

[pgroonga-releases-page]:https://github.com/pgroonga/pgroonga/releases/latest

[pgroonga-github-discussions-releases]:https://github.com/pgroonga/pgroonga/discussions/categories/releases
