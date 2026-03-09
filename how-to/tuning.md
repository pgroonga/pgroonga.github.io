---
title: How to tune PGroonga
---

# How to tune PGroonga

Normally, you don't need to tune PGroonga because PGroonga works well by default.

But you need to tune PGroonga in some cases such as a case that you need to handle a very large database. PGroonga uses Groonga as backend. It means that you can apply tuning knowledge for Groonga to PGroonga. See also the [Groonga tuning document][groonga-tuning] to tune PGroonga.

## Basic tuning

### `nofile`

When you are inserting or updating huge amout of data using PGroonga, you might get following errors in your `pgroonga.log`.

```text
SQLSTATE[58000]: <<Unknown error>>: 7 ERROR:  pgroonga: [insert] failed to set column value: system call error: Too many open files: [io][open] failed to open path: <base/121469/pgrn.00001C4>
```

PostgreSQL process that uses PGroonga needs to open many files but your system preferences are not allowing it. In order to solve this, you need to create a configuration file `/etc/security/limits.d/postgresql.conf` with the following content:

```vim
postgres soft nofile 65535
postgres hard nofile 65535
```

In this example, one PostgreSQL process can open up to 65535 files.

To calculate how many open files are sufficient, please refer to [Groonga: Turning: The max number of open files per process][groonga-tuning-nofile]


### `vm.overcommit_memory`

When you are performing search using PGroonga, you might get following warning in your `pgroonga.log`.

```text
vm.overcommit_memory kernel parameter should be 1: <0>: See INFO level log to resolve this
```

In order to prevent this warning from happening, you need to set `vm.overcommit_memory` kernel parameter to 1. To do this, you need to create a configuration file `/etc/sysctl.d/groonga.conf` that has the following content:

```vim
vm.overcommit_memory = 1
```

The configuration can be applied by restarting your system or run the following command:

```bash
sudo sysctl --system
```

## See also

  * [Groonga: Tuning][groonga-tuning]

[groonga-tuning]:https://groonga.org/docs/reference/tuning.html

[groonga-tuning-nofile]:https://groonga.org/docs/reference/tuning.html#the-max-number-of-open-files-per-process
