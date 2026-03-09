---
title: Build as a casual developer
---

# Build as a casual developer

This document describes how to build PGroonga as a casual developer. For example, a developer who just wants to fix a typo.

If you want to be a PGroonga developer, [build](build.html) is better than this.

## Prepare your fork repository

You need to fork <https://github.com/pgroonga/pgroonga/> for development. You will open a pull request from your fork repository later. See also GitHub documents:

* <https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks>

* <https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork>

Here are command lines to clone your fork repository:

```bash
git clone --recursive git@github.com:${YOUR_GITHUB_ACCOUNT}/pgroonga.git
cd pgroonga
```

## Setting up build environment

You can use our setup script that installs required dependencies including Groonga and PostgreSQL.

Here is the command line to run our setup script:

```bash
./setup.sh
```

## How to build and test PGroonga

You can use the following command line to build PGroonga and run PGroonga tests:

```bash
NEED_SUDO=yes HAVE_XXHASH=1 test/run-sql-test.sh
```

PGroonga has two test types:

  * SQL based regression tests

  * Complex tests that can't be implemented only with SQL

Normally, you only use the former. `test/run-sql-test.sh` is the test runner for the former. It builds and installs PGroonga and runs SQL based regression tests.

See also [test](test.html).

You can use the following command lines to only build and install PGroonga:

```bash
make
sudo make install
```
