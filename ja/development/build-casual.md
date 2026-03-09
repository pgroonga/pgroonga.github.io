---
title: カジュアル開発者としてビルド
---

# カジュアル開発者としてビルド

このドキュメントはカジュアル開発者としてPGroongaをビルドする方法を説明します。たとえば、typoを直したいだけのような開発者が対象になります。

PGroongaの開発者になりたい場合は、このドキュメントより[ビルド](build.html)の方が適切です。

## フォークリポジトリーの準備

開発するために<https://github.com/pgroonga/pgroonga/>をフォークする必要があります。後でフォークしたリポジトリーからプルリクエストを作るかもしれません。GitHubのドキュメントも参照してください。

* <https://docs.github.com/ja/pull-requests/collaborating-with-pull-requests/working-with-forks>

* <https://docs.github.com/ja/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork>

フォークしたリポジトリーをクローンするコマンドラインは次のとおりです。

```bash
git clone --recursive git@github.com:${YOUR_GITHUB_ACCOUNT}/pgroonga.git
cd pgroonga
```

## ビルド環境のセットアップ

GroongaとPostgreSQLを含む依存ソフトウェアをインストールするセットアップスクリプトを使うことができます。

セットアップスクリプトを使うコマンドラインは次のとおりです。

```bash
./setup.sh
```

## PGroongaのビルド・テスト方法

PGroongaをビルドしてPGroongaのテストを実行するには次のコマンドラインを使います。

```bash
NEED_SUDO=yes HAVE_XXHASH=1 test/run-sql-test.sh
```

PGroongaのテストは2種類あります。

  * SQLベースのリグレッションテスト

  * SQLだけでは実装できない複雑なテスト

通常、前者だけを使います。`test/run-sql-test.sh`は前者用のテストランナーです。PGroongaをビルド・インストールしてSQLベースのリグレッションテストを実行します。

[テスト](test.html)も読んでください。

PGroongaをビルド・インストールするだけのコマンドラインは次のとおりです。

```bash
make
sudo make install
```
