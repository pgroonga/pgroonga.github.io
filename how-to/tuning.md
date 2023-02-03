# Tuning

Normally, you don't need to tune PGroonga because PGroonga works well by default.

But you need to tune PGroonga in some cases such as a case that you need to handle a very large database. PGroonga uses Groonga as backend. It means that you can apply tuning knowledge for Groonga to PGroonga. See the following Groonga document to tune PGroonga:


## Basic Tuning

### `nofile`

When you are inserting or updating huge amout of data using PGroonga, you might get following errors in your `pgroonga.log`.

```vim
SQLSTATE[58000]: <<Unknown error>>: 7 ERROR:  pgroonga: [insert] failed to set column value: system call error: Too many open files: [io][open] failed to open path: <base/121469/pgrn.00001C4>
```

Groonga process needs to open many files but your system preferences are not allowing it. In order to solve this, you need to create a a configuration file `/etc/security/limits.d/groonga.conf` with the following content:

```vim
groonga soft nofile 10000
groonga hard nofile 10000
```

In this example, one Groonga process can open up to 10000 files.

To calculate how many open files are sufficient, please refer to [7.24.2.1. The max number of open files per process](https://groonga.org/docs/reference/tuning.html#the-max-number-of-open-files-per-process).


### `vm.overcommit_memory`

When you are performing search using PGroonga, you might get following warning in your `pgroonga.log`.

```vim
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

## For more detail

Please refer following documents in order to learn more about Groonga performance tuning.

- [Tuning](https://groonga.org/docs/reference/tuning.html)
