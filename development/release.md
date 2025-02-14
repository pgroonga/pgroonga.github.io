---
title: Release
---

# Release

## Requirements

### Environment variables

Use the following environment variables.

* `GROONGA_REPOSITORY`

  Specify a path for a latest Groonga repository.

  It is better to clone the Groonga repository for each releases.

  Here is an example to specify `$HOME/work/groonga/groonga.clean` to `GROONGA_REPOSITORY`.

  ```console
  $ mkdir -p ~/work/groonga
  $ rm -rf ~/work/groonga/groonga.clean
  $ git clone --recursive git@github.com:groonga/groonga.git ~/work/groonga/groonga.clean
  $ export GROONGA_REPOSITORY=$HOME/work/groonga/groonga.clean
  ```

* `LAUNCHPAD_UPLOADER_PGP_KEY`

  Specify a key for PPA of Groonga.

  Please refer to the [Groonga release document about PPA](https://groonga.org/docs/contribution/development/release.html#ppa).

* `GITHUB_ACCESS_TOKEN`

  Specify a GitHub access token.

  [GitHub Managing your personal access tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)

* `APACHE_ARROW_REPOSITORY`

  Specify a path for a latest [Apache Arrow repository](https://github.com/apache/arrow).

  e.g.

  ```console
  $ export APACHE_ARROW_REPOSITORY=$HOME/work/apache/arrow
  ```

### Commands

Some commands are required for the release, so install them.

```console
$ ./setup-release.sh
```

## Execute `release` task

```console
$ rake release NEW_RELEASE_DATE=$(date +%Y-%m-%d)
```

`NEW_RELEASE_DATE` is the release date.

### About `release` task

`release` task executes the three tasks

1. `package:version:update`

   * Append the changelog of the new version to the spec file of the RPM package, and so on

2. `tag`

   * Push the tag for release

   * This will start the automatic release

3. `version:update`

   * We will bump up the version for the next release

## Confirm CI

We confirm below CIs green or not.

* [GitHub Actions][github-actions-pgroonga]

We use CI to do automatic releases, so if it fails, we retry.

## Create packages for the release

### Ubuntu

For Ubuntu, packages are provided by PPA on launchpad.net.

* Upload to the `ppa` repository

  ```console
  $ rake package:ubuntu LAUNCHPAD_UPLOADER_PGP_KEY=xxxxxxx
  ```

* Check the build result

  When upload packages succeeded, a package build process is executed on launchpad.net.
  Then the build result is notified via E-mail if the build fails.
  We can install packages via [Groonga PPA on launchpad.net][launchpad-groonga-ppa].

## Describe the changes

We need to update https://github.com/pgroonga/pgroonga.github.io/ to announce the new release.

We describe to `news/index.md` summarize changes from before version.

We also update below items in `_config.yml`.

* `pgroonga_version`:

  * PGroonga latest version.

* `pgroonga_release_date`:

  * Relase data for the latest version.

* `postgresql_doc_base_url`:

  * Update if PostgreSQL version changes.

* `windows_postgresql_versions`:

  * Update if PostgreSQL version for Windows changes.

* `latest_postgresql_version`:

  * PostgreSQL latest major version.

* `freebsd_postgresql_version`:

  * PostgreSQL for FreeBSD latest version.

* `development_postgresql_version`:

  * PostgreSQL latest version (include minor version).

### Update Docker images

We update PGroonga's Docker images of [Docker Hub][pgroonga-docker-hub].

Clone [PGroonga's Docker repository][pgroonga-docker-repository] and update Dockerfiles in tha repository.

Here is an example for the case that the PGroonga version is `2.4.1`, and the Groonga version is `12.0.9`.

```
$ mkdir -p ~/work/pgroonga
$ rm -rf ~/work/pgroonga/docker.clean
$ git clone --recursive git@github.com:pgroonga/docker.git ~/work/pgroonga/docker.clean
$ cd ~/work/pgroonga/docker.clean
$ ./update.sh 2.4.1 12.0.9 #Automatically update Dockerfiles and commit changes and create a tag.
$ git push
```

You have to specify the latest versions.

After you check [GitHub Actions of the PGroonga's Docker repository][github-actions-pgroonga-docker] are succeeded, push tag to remote.

```console
$ git push --tags
```

[GitHub Actions of the PGroonga's Docker repository][github-actions-pgroonga-docker] automatically update the PGroonga's docker images of [Docker Hub][pgroonga-docker-hub] after you push the tag.

## Announce release

### Announce release for mailing list

We send release announcement to PostgreSQL mailing list if we have big news.

Your PostgreSQL account must belong to `PGroonga project` for announcement.
Please contact a project member in order to join `PGroonga project`.

* [https://www.postgresql.org/list/](https://www.postgresql.org/list/)
* [https://www.postgresql.org/search/?m=1&ln=pgsql-announce&q=PGroonga](https://www.postgresql.org/search/?m=1&ln=pgsql-announce&q=PGroonga) (Archives for PGroonga announcements)

### Announce release for blog

We make release announce in blogs that are published [https://groonga.org/blog/](https://groonga.org/blog/) and [https://groonga.org/ja/blog/](https://groonga.org/ja/blog/) .

We update blogs in the following steps.

Clone [blog source repository][groonga-org-repository].

Make below files in [blog source repository][groonga-org-repository].

* `groonga.org/en/_post/(release-date)-pgroonga-(pgroonga-version).md`

* `groonga.org/ja/_post/(release-date)-pgroonga-(pgroonga-version).md`

We can confirm blogs by the following steps.

Install required libraries:

```console
$ bundle update
```

Start Web server:

```console
$ jekyll serve --watch
```

We access http://localhost:4000 on our browser.

### Announce release for Facebook

We have [Groonga group][facebook-groonga] in Facebbok.
If you into Groonga group as a member, you can post as a member of [Groonga group][facebook-groonga].

We post announce based on the blog and news.

### Announce release for twitter

Click Tweet link in PGroonga blog entry.
We can share tweet about latest release.
If we use tweet link, title of release announce and URL is embedded into our tweet.

Execute sharing tweet in Japanese and English version of blog entry.
Note that this tweet should be done when logged in by groonga account.

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
