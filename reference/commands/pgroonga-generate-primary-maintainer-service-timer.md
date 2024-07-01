---
title: pgroonga-generate-primary-maintainer-{service,timer}.sh command
upper_level: ../
---

# `pgroonga-generate-primary-maintainer-{service,timer}.sh` command

Since 3.2.1.

## Summary

These commands output the contents of a configuration file for
[`pgroonga-primary-maintainer.sh`][primary-maintainer] to run periodically
using [systemd/Timers][systemd-timers].

* `pgroonga-generate-primary-maintainer-service.sh`

  * Output `.service` file configuration

* `pgroonga-generate-primary-maintainer-timer.sh`

  * Output `.timer` file configuration

## Usage

### `pgroonga-generate-primary-maintainer-service.sh` command

```
Options:
--pgroonga-primary-maintainer-command:
  Specify the path to `pgroonga-primary-maintainer.sh`
  (default: )
--threshold:
  If the specified value is exceeded, `REINDEX INDEX CONCURRENTLY` is run.
  (default: 1G)
--environment
  Connection information such as `dbname` should be set in environment variables.
  See also: https://www.postgresql.org/docs/current/libpq-envars.html"
  Example: --environment KEY1=VALUE1 --environment KEY2=VALUE2 ...
--psql:
  Specify the path to `psql` command.
--on-failure-service:
  Run SERVICE on failure
--help:
  Display help text and exit.
```

* `--pgroonga-primary-maintainer-command`

  * Specify the path of [`pgroonga-primary-maintainer.sh` command][primary-maintainer]

* `--threshold`

  * Specify the threshold

  * See [`pgroonga-primary-maintainer.sh` command][primary-maintainer] for details

* `--environment`

  * Specify DB connection information by environment variables

  * See [`pgroonga-primary-maintainer.sh` command][primary-maintainer] for details

* `--psql`

  * Specify the path of `psql`

  * See [`pgroonga-primary-maintainer.sh` command][primary-maintainer] for details

* `--on-failure-service`

  * Specify the notify destination on failure

  * See [Notifying about failed services][systemd-on-failure] for details

### `pgroonga-generate-primary-maintainer-timer.sh` command

```
Options:
--time:
  Specify run time,
  Example: --time 2:00 --time 3:30 ...
--help:
  Display help text and exit.
```

* `--time`

  * Specify the start time of the run

  * You can specify multiple times

## Example

Redirect the output to generate a configuration file.

The `NAME` part of `NAME.service` and `NAME.timer` must be equal.

Note: The command path depends on the environment.

### Generate `.service` file

* Specify the path of [`pgroonga-primary-maintainer.sh` command][primary-maintainer]

  * `--pgroonga-primary-maintainer-command /usr/pgsql-12/bin/pgroonga-primary-maintainer.sh`

* Specify DB connection information by environment variables

  * `--environment PGHOST=example.com`

  * `--environment PGDATABASE=test_database`

* Specify a threshold of 10GB

  * `--threshold 10G`

#### Generate

```console
$ sudo -u postgres -H /usr/pgsql-12/bin/pgroonga-generate-primary-maintainer-service.sh \
  --pgroonga-primary-maintainer-command /usr/pgsql-12/bin/pgroonga-primary-maintainer.sh \
  --environment PGHOST=example.com \
  --environment PGDATABASE=test_database \
  --threshold 10G | \
  sudo -H tee /lib/systemd/system/pgroonga-primary-maintainer.service
# How to install:
#   /usr/pgsql-12/bin/pgroonga-generate-primary-maintainer-service.sh | sudo -H tee /lib/systemd/system/pgroonga-primary-maintainer.service
[Unit]
Description=PGroonga primary maintainer

[Service]
Type=oneshot
User=postgres
Group=postgres
Environment=PGHOST=example.com PGDATABASE=test_database
ExecStart=/usr/pgsql-12/bin/pgroonga-primary-maintainer.sh --threshold 10G
[Install]
WantedBy=multi-user.target
```

#### Test execution and status check

**Caution!: `REINDEX` is actually executed when the WAL exceeds the threshold.**

```console
$ sudo -H systemctl start pgroonga-primary-maintainer.service
```

```console
$ sudo -H systemctl status pgroonga-primary-maintainer.service
● pgroonga-primary-maintainer.service - PGroonga primary maintainer
   Loaded: loaded (/usr/lib/systemd/system/pgroonga-primary-maintainer.service; disabled; vendor preset: disabled)
  Drop-In: /run/systemd/system/pgroonga-primary-maintainer.service.d
           └─zzz-lxc-service.conf
   Active: inactive (dead) since Fri 2024-06-28 08:36:27 UTC; 4min 50s ago
  Process: 21035 ExecStart=/usr/pgsql-12/bin/pgroonga-primary-maintainer.sh --threshold 10G (code=exited, status=0/SUCCESS)
 Main PID: 21035 (code=exited, status=0/SUCCESS)

Jun 28 08:36:26 temp systemd[1]: Starting PGroonga primary maintainer...
Jun 28 08:36:26 temp pgroonga-primary-maintainer.sh[21035]: Run 'REINDEX INDEX CONCURRENTLY memos_content'
Jun 28 08:36:26 temp pgroonga-primary-maintainer.sh[21047]: Fri Jun 28 08:36:26 UTC 2024
Jun 28 08:36:27 temp pgroonga-primary-maintainer.sh[21048]: REINDEX
Jun 28 08:36:27 temp pgroonga-primary-maintainer.sh[21051]: Fri Jun 28 08:36:27 UTC 2024
Jun 28 08:36:27 temp systemd[1]: pgroonga-primary-maintainer.service: Succeeded.
Jun 28 08:36:27 temp systemd[1]: Started PGroonga primary maintainer.
```

### Generate `.timer` file

Here is an example of executing at 1:15 and 23:45.

#### Generate

```console
$ sudo -u postgres -H /usr/pgsql-12/bin/pgroonga-generate-primary-maintainer-timer.sh \
  --time 1:15 \
  --time 23:45 | \
  sudo -H tee /lib/systemd/system/pgroonga-primary-maintainer.timer
# How to install:
#   /usr/pgsql-12/bin/pgroonga-generate-primary-maintainer-timer.sh | sudo -H tee /lib/systemd/system/pgroonga-primary-maintainer.timer
#   sudo -H systemctl daemon-reload
#
# Usage:
#
#   Enable:  sudo -H systemctl enable --now pgroonga-primary-maintainer.timer
#   Disable: sudo -H systemctl disable --now pgroonga-primary-maintainer.timer
[Unit]
Description=PGroonga primary maintainer
[Timer]
OnCalendar=*-*-* 1:15:00
OnCalendar=*-*-* 23:45:00
[Install]
WantedBy=timers.target
```

### Enable systemd Timer

```
$ sudo -H systemctl enable --now pgroonga-primary-maintainer.timer
```

### Status check

```
$ sudo -H systemctl status pgroonga-primary-maintainer.timer
● pgroonga-primary-maintainer.timer - PGroonga primary maintainer
   Loaded: loaded (/usr/lib/systemd/system/pgroonga-primary-maintainer.timer; enabled; vendor preset: disabled)
   Active: active (waiting) since Fri 2024-06-28 08:28:58 UTC; 14min ago
  Trigger: Fri 2024-06-28 23:45:00 UTC; 15h left

Jun 28 08:28:58 temp systemd[1]: Started PGroonga primary maintainer.
```

### Disable systemd Timer

```
$ sudo -H systemctl disable --now pgroonga-primary-maintainer.timer
```

## See also

  * [`pgroonga-primary-maintainer.sh` command][primary-maintainer]

  * [systemd/Timers][systemd-timers]

[primary-maintainer]:pgroonga-primary-maintainer.html

[systemd-timers]:https://wiki.archlinux.org/title/systemd/Timers

[systemd-on-failure]:https://wiki.archlinux.org/title/systemd#Notifying_about_failed_services
