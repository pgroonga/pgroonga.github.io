---
title: Install
upper_level: ../
---

# Install

There are packages for major platforms. You can install PGroonga easily.

There are separated documents for these platforms. And there is a document for building PGroonga from source.

Here are supported PostgreSQL versions:

  * 10
  * 11
  * 12
  * 13
  * 14
  * 15

If your PostgreSQL is older than them, you need to upgrade your PostgreSQL before you install PGroonga.

See a document for your platform in the followings:

  * [Debian GNU/Linux](debian.html)

    * bullseye

  * [Ubuntu](ubuntu.html)

    * 18.04

    * 20.04

    * 22.04

  * [CentOS](centos.html)

    * 7

  * [AlmaLinux](almalinux.html)

    * 8

  * [Amazon Linux](amazon-linux.html)

    * 2

  * [FreeBSD](freebsd.html)

  * [macOS](macos.html)

    * Homebrew

  * [Windows](windows.html)

{% for windows_postgresql_version in site.windows_postgresql_versions %}

    * PostgreSQL {{ windows_postgresql_version }}

{% endfor %}

If you can't find your platform in the above list, [build and install from source](source.html) or send a request as an [issue](https://github.com/pgroonga/pgroonga/issues/new).

## See also

  * [Uninstall][uninstall]

  * [Tuning][tuning]

[uninstall]:../uninstall/

[tuning]:../how-to/tuning.html
