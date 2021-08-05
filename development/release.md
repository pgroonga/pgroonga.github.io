---
title: Release
---

# Release

## Requirements

Use the following enviroment values.

* `GITHUB_TOKEN`

* `GROONGA_REPOSITORY`

* `LAUNCHPAD_UPLOADER_PGP_KEY`

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

## Tagging for the release

```console
$ rake tag
```

## Create and upload a archive file

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

```console
$ rake package:ubuntu
```

When upload packages was succeeded, package build process is executed on launchpad.net.
Then build result is notified via E-mail. We can install packages via [Groonga PPA on launchpad.net][launchpad-groonga-ppa].

### CentOS

```console
$ rake package:yum
```

### Windows

For Windows packages, we use [GitHub Actions][github-actions-pgroonga] artifacts files.

```console
$ rake package:windows:upload
```

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

We send release announce to below address.

* groonga-dev (Japanese) `groonga-dev@lists.osdn.me`

* groonga-talk (English) `groonga-talk@lists.sourceforge.net`

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

[groonga-org-repository]:https://github.com/groonga/groonga.org

[facebook-groonga]:https://www.facebook.com/groonga/
