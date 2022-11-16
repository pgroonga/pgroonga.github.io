---
title: Release
---

# Release

## Requirements

Use the following enviroment values.

* `GROONGA_REPOSITORY`

  Specify a path for a latest Groonga repository.

  If you have not cloned the Groonga repository.

  ```console
  $ mkdir -p ~/work/groonga
  $ git clone --recursive git@github.com:groonga/groonga.git ~/work/groonga/groonga.clean
  $ export GROONGA_REPOSITORY=$HOME/work/groonga/groonga.clean
  ```

  If you have already cloned the Groonga repository, execute `git pull` beforehand.

* `LAUNCHPAD_UPLOADER_PGP_KEY`

  Specify a key for PPA of Groonga.

  Please refer the [Groonga release document about PPA](https://groonga.org/docs/contribution/development/release.html#ppa).

## Bump version

```console
$ rake version:update NEW_VERSION=x.x.x
```

## Update change log for Debian and CentOS packages

```console
$ rake package:version:update
```

## Check whether we can make packages or not

We confirm below CIs green or not.

* [GitHub Actions][github-actions-pgroonga]

## Check whether we can build packages on `nightly` repository of launchpad.net

For Ubuntu, packages are provided by PPA on launchpad.net.

We have [nightly][launchpad-groonga-nightly] and [ppa][launchpad-groonga-nightly] repositories on launchpad.net.
`nightly` is for testing and `ppa` is for distributing.

We should test whether we can build packages for Ubuntu on the `nightly` repository before tagging.

* Create a archive file for test on local.

  ```console
  $ rake dist
  ```

* Change `~/.dput.cf` in order to upload the `nightly` repository.

  Add or change a `[groonga-ppa]` entry as below.
  `incoming = ~groonga/ubuntu/nightly` is important.

  If you don't have `~/.dput.cf`, please manually create it.

  ```console
  $ vi ~/.dput.cf
  [groonga-ppa]
  fqdn = ppa.launchpad.net
  method = ftp
  incoming = ~groonga/ubuntu/nightly
  login = anonymous
  allow_unsigned_uploads = 0
  ```

* Upload to the `nightly` repository.

  ```console
  $ rake package:ubuntu
  ```

* Check the build result

  When upload packages into the `nightly` reposigoty succeeded, 
  a package build process is executed on launchpad.net.
  Then build result is notified via E-mail.

## Tagging for the release

```console
$ rake tag
```

## Download or create a archive file

Donwload the archive file (`pgroonga-x.x.x.tar.gz`) from the 
[GitHub relase page](https://github.com/pgroonga/pgroonga/releases/latest)
and distribute it to the top of the PGroonga repository.

If the archive file doesn't exist on the GitHub release page, 
you can create it on local by the following command.

```console
$ rake dist
```

## Upload a archive file

```console
$ rake package:source
```

## Create packages for the release

### Debian GNU/Linux

```console
$ rake package:apt
```

### Ubuntu

For Ubuntu, packages are provided by PPA on launchpad.net.

* Change `~/.dput.cf` in order to upload the `ppa` repository.

  Change the `[groonga-ppa]` entry as below.
  `incoming = ~groonga/ubuntu/ppa` is important.

  ```console
  $ vi ~/.dput.cf
  [groonga-ppa]
  fqdn = ppa.launchpad.net
  method = ftp
  incoming = ~groonga/ubuntu/ppa
  login = anonymous
  allow_unsigned_uploads = 0
  ```

* Upload to the `ppa` repository.

  ```console
  $ rake package:ubuntu
  ```

* Check the build result

  When upload packages succeeded, a package build process is executed on launchpad.net.
  Then build result is notified via E-mail. We can install packages via [Groonga PPA on launchpad.net][launchpad-groonga-ppa].

### CentOS

```console
$ rake package:yum
```

### Windows

For Windows packages, we don't need to execute anything.

Windows packages are uploaded automatically by actions of [GitHub Actions][github-actions-pgroonga].

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

* `amazon_linux_postgresql_version`:

  * PostgreSQL for AmazonLinux latest version.

* `development_postgresql_version`:

  * PostgreSQL latest version (include minor version).

## Update the repository

We update the repository in the following steps.

Clone the packages.groonga.org repository:

```console
$ git clone git@github.com:groonga/packages.groonga.org.git
```

Update repositories for Debian GNU/Linux and CentOS:

```console
$ cd packages.groonga.org
$ rake apt
$ rake yum
```

## Announce release

### Announce release for mailing list

We send release announcement to PostgreSQL mailing list if we have big news.

Your PostgreSQL account must belong to `PGroonga project` for announcement.
Please contact other release personnel to belong to `PGroonga project`.

* https://www.postgresql.org/list/
* https://www.postgresql.org/search/?m=1&ln=pgsql-announce&q=PGroonga (Archives for PGroonga announcements)

### Announce release for GitHub Discussions

We make release announce in GitHub Discussions.

https://github.com/pgroonga/pgroonga/discussions/categories/releases

### Announce release for blog

We make release announce in blogs that are published https://groonga.org/blog/ and https://groonga.org/ja/blog/ .

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
