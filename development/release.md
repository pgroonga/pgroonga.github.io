---
title: How to release
---

# How to release

## Requestments

Use the following enviroment values.

* APACHE_ARROW_REPOSITORY

* GITHUB_TOKEN

* GROONGA_REPOSITORY

* LAUNCHPAD_UPLOADER_PGP_KEY

We update GRUB option in the following steps for executing CentOS6 on Docker.

1. Make `/etc/default/grub.d/vsyscall-emulate.cfg` and write below content.

    ```
    GRUB_CMDLINE_LINUX_DEFAULT="${GRUB_CMDLINE_LINUX_DEFAULT} vsyscall=emulate"
    ```

2. Execute `update-grub`.

3. Execute `reboot`.

## Bump version

```shell
% rake version:update NEW_VERSION=x.x.x
```

## Update change log for Debian and CentOS packages

```shell
% cd package
% rake package:version:update
```

## Update PostgreSQL version for Appveyor

We update PostgreSQL version for `appveyor.yml`.

## Check whether we can make packages or not

We confirm below CIs green or not.

* [GitHub Actions Workflow for Linux](https://github.com/pgroonga/pgroonga/actions?query=workflow%3ALinux)

* [AppVeyor CI](https://ci.appveyor.com/project/groonga/pgroonga)

## Tagging for the release

```shell
% cd package
% rake tag
```

## Create and upload a archive file

```shell
% cd package
% rake package:source
```

## Create packages for the release

### Debian

```shell
% cd package
% rake package:apt
```

### Ubuntu

For Ubuntu, packages are provided by PPA on launchpad.net.

```shell
% cd package
% rake package:ubuntu
```

When upload packages was succeeded, package build process is executed on launchpad.net.
Then build result is notified via E-mail. We can install packages via [Groonga PPA on launchpad.net](https://launchpad.net/~groonga/+archive/ubuntu/ppa).

### CentOS

```shell
% cd package
% rake package:yum
```

### Windows

For Windows packages, we use [AppVeyor CI](https://ci.appveyor.com/project/groonga/pgroonga) artifacts files.

```shell
% cd package
% rake package:windows:upload
```

## Describe the changes

We describe to `news/index.md` summarize changes from before version.

We also update below items in `_config.yml`.

* pgroonga_version:

  * PGroonga latest version.

* pgroonga_release_date:

  * Relase data for the latest version.

* copyright_year:

  * Update if the year changes.

* postgresql_doc_base_url:

  * Update if PostgreSQL version changes.

* windows_postgresql_versions:

  * Update if PostgreSQL version for Windows changes.

* latest_postgresql_version:

  * PostgreSQL latest major version.

* freebsd_postgresql_version:

  * PostgreSQL for FreeBSD latest version.

* amazon_linux_postgresql_version:

  * PostgreSQL for AmazonLinux latest version.

* development_postgresql_version:

  * PostgreSQL latest version (include minor version).

## Update the repository

We update the repository in the following steps.

```shell
# Clone packages.groonga.org repository
% git clone git@github.com:groonga/packages.groonga.org.git

# Update repositories for Debian and CentOS.
% cd packages.groonga.org
% rake apt
% rake yum
```

## Announce release

### Announce release for mailing list

We send release announce to below address.

* groonga-dev(Japanese) groonga-dev@lists.osdn.me.

* groonga-talk(English) groonga-talk@lists.sourceforge.net.

### Announce release for blog

We make release announce in blogs that are published http://groonga.org/blog/ and http://groonga.org/blog/

We update blogs in the following steps.

1. Clone [blog source repository](https://github.com/groonga/groonga.org).

2. Make below files in [blog source repository](https://github.com/groonga/groonga.org).

   * groonga.org/en/_post/(release-date)-pgroonga-(pgroonga-version).md

   * groonga.org/ja/_post/(release-date)-pgroonga-(pgroonga-version).md

3. Confirm blogs.

  We can confirm blogs by the following steps.

  1. Install Jekyll.

     ```shell
     % sudo gem install jekyll jekyll-paginate RedCloth rdiscount therubyracer
     ```

  2. Start web server

     ```shell
     % jekyll serve --watch
     ```

  3. We access http://localhost:4000 on our browser.

### Announce release for Facebook

We have [Groonga group](https://www.facebook.com/groonga/) in Facebbok.
If you into Groonga group as a member, you can post as a member of [Groonga group](https://www.facebook.com/groonga/).

We post announce based on the blog and news.

### Announce release for twitter

Click Tweet link in PGroonga blog entry.
We can share tweet about latest release.
If we use tweet link, title of release announce and URL is embedded into our tweet.

Execute sharing tweet in Japanese and English version of blog entry.
Note that this tweet should be done when logged in by groonga account.
