---
title: Replication
---

# Replication

PGroonga supports PostgreSQL built-in [WAL based streaming replication](https://www.postgresql.org/docs/{{ site.postgresql_short_version }}/static/warm-standby.html) since 1.1.6. It requires PostgreSQL 9.6 or later.

If you're using PostgreSQL 9.5 or earlier, there are some alternative streaming replication implementations that can be used with PGroonga:

  * [pglogical](https://2ndquadrant.com/en/resources/pglogical/)

  * [pg\_shard](https://github.com/citusdata/pg_shard) (pg\_shard is deprecated. [Citus](https://github.com/citusdata/citus), the replacement of pg\_shard, may work with PGroonga. If you confirm that Citus can work with PGroonga, please [report it](https://github.com/pgroonga/pgroonga/issues/new).)

This document describes how to configure PostgreSQL built-in WAL based streaming replication for PGroonga. Most of steps are normal steps. There are some PGroonga specific steps.

## Summary

Here are steps to configure PostgreSQL built-in WAL based streaming replication for PGroonga. "[normal]" tag means that the step is a normal step for streaming replication. "[special]" tag means that the step is a PGroonga specific step.

  1. [normal] Install PostgreSQL on master and slaves

  2. [special] Install PGroonga on master and slaves

  3. [normal] Initialize PostgreSQL database on master

  4. [normal] Add some streaming replication configurations to `postgresql.conf` and `pg_hba.conf`

  5. [special] Add some PGroonga related configurations to `postgresql.conf`

  6. [normal] Insert data on master

  7. [special] Create a PGroonga index on master

  8. [special] Flush PGroonga related data on master

  9. [normal] Run `pg_basebackup` on slaves

  10. [normal] Add some streaming replication configurations to `postgresql.conf`

  11. [normal] Start PostgreSQL on slaves

## Example environment

This document uses the following environment:

  * Master:

    * OS: CentOS 7

    * IP address: 192.168.0.30

    * Database name: `blog`

    * Replication user name: `replicator`

    * Replication user password: `passw0rd`

  * Slave1:

    * OS: CentOS 7

    * IP address: 192.168.0.31

  * Slave2:

    * OS: CentOS 7

    * IP address: 192.168.0.31

This document shows command lines for CentOS 7. If you're using other platforms, adjust command lines by yourself.

## [normal] Install PostgreSQL on master and slaves

This is a normal step.

Install PostgreSQL 9.6 on master and slaves.

Master:

```text
% sudo -H yum install -y http://yum.postgresql.org/9.6/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos96-9.6-3.noarch.rpm
% sudo -H yum install -y postgresql96
% sudo -H systemctl enable postgresql-9.6
```

Slave:

```text
% sudo -H yum install -y http://yum.postgresql.org/9.6/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos96-9.6-3.noarch.rpm
% sudo -H yum install -y postgresql96
% sudo -H systemctl enable postgresql-9.6
```

See also [PostgreSQL: Linux downloads (Red Hat family)](https://www.postgresql.org/download/linux/redhat/#yum)

## [special] Install PGroonga on master and slaves

This is a PGroonga specific step.

Install PGroonga on master and slaves.

Master:

```text
% sudo -H yum install -y http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm
% sudo -H yum install -y postgresql96-pgroonga
```

Slaves:

```text
% sudo -H yum install -y http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm
% sudo -H yum install -y postgresql96-pgroonga
```

See also [Install on CentOS | PGroonga](/../install/centos.html#install-on-7)

## [normal] Initialize PostgreSQL database on master

This is a normal step.

Initialize PostgreSQL database on only master. You don't need to initialize PostgreSQL database on slaves.

Master:

```text
% sudo -H env PGSETUP_INITDB_OPTIONS="--locale C --encoding UTF-8" /usr/pgsql-9.6/bin/postgresql96-setup initdb
```

## [normal] Add some streaming replication configurations to `postgresql.conf` and `pg_hba.conf`

This is a normal step.

Add the following streaming replication configurations to `postgresql.conf` on only master:

  * `listen_address = '*'`

  * `wal_level = replica`

     * See also [PostgreSQL: Documentation: Write Ahead Log](https://www.postgresql.org/docs/{{ site.postgresql_short_version }}/static/runtime-config-wal.html#GUC-WAL-LEVEL)

  * `max_wal_senders = 4` (`= 2 (The number of slaves) * 2`. `* 2` is for unexpected connection close.)

     * See also [PostgreSQL: Documentation: Replication](https://www.postgresql.org/docs/{{ site.postgresql_short_version }}/static/runtime-config-replication.html#GUC-MAX-WAL-SENDERS)

`/var/lib/pgsql/9.6/data/postgresql.conf`:

Before:

```text
#listen_address = 'localhost'
#wal_level = minimal
#wal_wal_senders = 0
```

After:

```text
listen_address = '*'
wal_level = replica
wal_wal_senders = 4
```

Add the following streaming replication configurations to `pg_hba.conf` on only master:

  * Accept replication connection by the replication user `replicator` from `192.168.0.0/24`.

`/var/lib/pgsql/9.6/data/pg_hba.conf`:

Before:

```text
#local   replication     postgres                                peer
#host    replication     postgres        127.0.0.1/32            ident
#host    replication     postgres        ::1/128                 ident
```

After:

```text
host    replication     replicator       192.168.0.0/24         md5
```

Create the user for replication on only master:

```text
% sudo -H systemctl start postgresql-9.6
% sudo -u postgres -H createuser --pwprompt --replication replicator
Enter password for new role: (passw0rd)
Enter it again: (passw0rd)
```

## [special] Add some PGroonga related configurations to `postgresql.conf`

This is a PGroonga specific step.

Add [`pgronga.enable_wal` parameter](parameters/enable_wal.html) configuration to `postgresql.conf` on only master:

`/var/lib/pgsql/9.6/data/postgresql.conf`:

```text
pgroonga.enable_wal = on
```

Restart PostgreSQL to apply the configuration:

```text
% sudo -H systemctl restart postgresql-9.6
```

## [normal] Insert data on master

This is a normal step.

Create a normal user on only master:

```text
% sudo -u postgres -H createuser ${USER}
```

Create a database on only master:

```text
% sudo -u postgres -H createdb --locale C --encoding UTF-8 --owner ${USER} blog
```

Create a table in the created database on only master.

Connect to the created `blog` database:

```text
% psql blog
```

Create `entries` table:

```sql
CREATE TABLE entries (
  title text,
  body text
);
```

Insert data to the created `entries` table:

```sql
INSERT INTO entries VALUES ('PGroonga', 'PGroonga is a PostgreSQL extension for fast full text search that supports all languages. It will help us.');
INSERT INTO entries VALUES ('Groonga', 'Groonga is a full text search engine used by PGroonga. We did not know about it.');
INSERT INTO entries VALUES ('PGroonga and replication', 'PGroonga 1.1.6 supports WAL based streaming replication. We should try it!');
```

## [special] Create a PGroonga index on master

This is a PGroonga specific step.

Install PGroonga to the database. It requires superuser privilege:

```text
% sudo -u postgres -H psql blog --command "CREATE EXTENSION pgroonga;"
% sudo -u postgres -H psql blog --command "GRANT USAGE ON SCHEMA pgroonga TO ${USER};"
```

Connect to PostgreSQL by a normal user again:

```text
% psql blog
```

Create a PGroonga index on only master:

```sql
CREATE INDEX entries_full_text_search ON entries USING pgroonga (title, body);
```

Confirm the index:

```sql
SET enable_seqscan TO off;
SELECT title FROM entries WHERE title %% 'replication';
--           title           
-- --------------------------
--  PGroonga and replication
-- (1 row)
```

## [special] Flush PGroonga related data on master

This is a PGroonga specific step.

Ensure writing PGroonga related data on memory to disk on only master. You can choose one of them:

  1. Run `SELECT pgroonga.command('io_flush');`

  2. Disconnect all connections

Here is an example to use `pgroonga.command('io_flush')`:

```sql
SELECT pgroonga.command('io_flush');
--                     command                    
-- -----------------------------------------------
--  [[0,1478446349.2241,0.1413860321044922],true]
-- (1 row)
```

You must not change tables that use PGroonga indexes on master until the next `pg_basebackup` step is finished.

## [normal] Run `pg_basebackup` on slaves

This is a normal step.

Run `pg_basebackup` on only slaves. It copies the current database from master.

Slaves:

```text
% sudo -u postgres -H pg_basebackup --host 192.168.0.30 --pgdata /var/lib/pgsql/9.6/data --xlog --progress --username replicator --password --write-recovery-conf
Password: (passw0rd)
149261/149261 kB (100%), 1/1 tablespace
```

## [normal] Add some streaming replication configurations to `postgresql.conf`

This is a normal step.

Add the following replica configurations to `postgresql.conf` on only slaves:

  * `hot_standby = on`

    * See also [PostgreSQL: Documentation: Replication](https://www.postgresql.org/docs/{{ site.postgresql_short_version }}/static/runtime-config-replication.html#GUC-HOT-STANDBY)

Slaves:

`/var/lib/pgsql/9.6/data/postgresql.conf`:

Before:

```text
#hot_standby = off
```

After:

```text
hot_standby = on
```

## [normal] Start PostgreSQL on slaves

This is a normal step.

Start PostgreSQL on slaves:

```text
% sudo -H systemctl start postgresql-9.6
```

Now, you can search data inserted on master by PGroonga index created on master.

Slave1:

```text
% psql blog
```

```sql
SET enable_seqscan TO off;
SELECT title FROM entries WHERE title %% 'replication';
--           title           
-- --------------------------
--  PGroonga and replication
-- (1 row)
```

You can also search data inserted on master after `pg_basebackup`.

Master:

```sql
INSERT INTO entries VALUES ('PostgreSQL 9.6 and replication', 'PostgreSQL supports generic WAL since 9.6. It is required for replication for PGroonga.');
```

Slave1:

```sql
SELECT title FROM entries WHERE title %% 'replication';
--              title              
-- --------------------------------
--  PGroonga and replication
--  PostgreSQL 9.6 and replication
-- (2 rows)
```

Slave2:

```sql
SELECT title FROM entries WHERE title %% 'replication';
--              title              
-- --------------------------------
--  PGroonga and replication
--  PostgreSQL 9.6 and replication
-- (2 rows)
```

## TODO

Write about MessagePack is required on PGroonga build.
