---
title: Streaming replication
---

# Streaming replication

PGroonga supports PostgreSQL built-in [WAL based streaming replication][postgresql-wal] since 1.1.6.

Note that WAL support doesn't mean crash safe. It just supports WAL based streaming replication. If PostgreSQL is crashed while PGroonga index update, the PGroonga index may be broken. If the PGroonga index is broken, you need to recreate the PGroonga index by [`REINDEX`][postgresql-reindex].

See also: [Crash safe][crash-safe]

This document describes how to configure PostgreSQL built-in WAL based streaming replication for PGroonga. Most of steps are normal steps. There are some PGroonga specific steps.

## Summary

Here are steps to configure PostgreSQL built-in WAL based streaming replication for PGroonga. "[normal]" tag means that the step is a normal step for streaming replication. "[special]" tag means that the step is a PGroonga specific step.

  1. [normal] Install PostgreSQL on primary and standbys

  2. [special] Install PGroonga on primary and standbys

  3. [normal] Initialize PostgreSQL database on primary

  4. [normal] Add some streaming replication configurations to `postgresql.conf` and `pg_hba.conf` on primary

  5. [special] Add some PGroonga related configurations to `postgresql.conf` on primary

  6. [normal] Insert data on primary

  7. [special] Create a PGroonga index on primary

  8. [special] Flush PGroonga related data on primary

  9. [normal] Run `pg_basebackup` on standbys

  10. [normal] Add some streaming replication configurations to `postgresql.conf` on standbys

  11. [special] Add some PGroonga's WAL configurations to `postgresql.conf` on standbys

  12. [normal] Start PostgreSQL on standbys

## Example environment

This document uses the following environment:

  * Primary:

    * OS: CentOS 7

    * IP address: 192.168.0.30

    * Database name: `blog`

    * Replication user name: `replicator`

    * Replication user password: `passw0rd`

  * Standby1:

    * OS: CentOS 7

    * IP address: 192.168.0.31

  * Standby2:

    * OS: CentOS 7

    * IP address: 192.168.0.31

This document shows command lines for CentOS 7. If you're using other platforms, adjust command lines by yourself.

## [normal] Install PostgreSQL on primary and standbys

This is a normal step.

Install PostgreSQL 9.6 on primary and standbys.

Primary:

```text
% sudo -H yum install -y http://yum.postgresql.org/9.6/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos96-9.6-3.noarch.rpm
% sudo -H yum install -y postgresql96-server
% sudo -H systemctl enable postgresql-9.6
```

Standbys:

```text
% sudo -H yum install -y http://yum.postgresql.org/9.6/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos96-9.6-3.noarch.rpm
% sudo -H yum install -y postgresql96-server
% sudo -H systemctl enable postgresql-9.6
```

See also [PostgreSQL: Linux downloads (Red Hat family)](https://www.postgresql.org/download/linux/redhat/#yum).

## [special] Install PGroonga on primary and standbys

This is a PGroonga specific step.

Install PGroonga on primary and standbys.

Primary:

```text
% sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-{{ site.centos_groonga_release_version }}.noarch.rpm
% sudo -H yum install -y postgresql96-pgroonga
```

Standbys:

```text
% sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-{{ site.centos_groonga_release_version }}.noarch.rpm
% sudo -H yum install -y epel-release
% sudo -H yum install -y postgresql96-pgroonga
```

See also [Install on CentOS](/../install/centos.html#install-on-7).

## [normal] Initialize PostgreSQL database on primary

This is a normal step.

Initialize PostgreSQL database on only primary. You don't need to initialize PostgreSQL database on standbys.

Primary:

```text
% sudo -H env PGSETUP_INITDB_OPTIONS="--locale C --encoding UTF-8" /usr/pgsql-9.6/bin/postgresql96-setup initdb
```

## [normal] Add some streaming replication configurations to `postgresql.conf` and `pg_hba.conf` on primary

This is a normal step.

Add the following streaming replication configurations to `postgresql.conf` on only primary:

  * `listen_address = '*'`

  * `wal_level = replica`

    * See also [PostgreSQL: Documentation: Write Ahead Log][postgresql-wal-level].

  * `max_wal_senders = 4` (`= 2 (The number of standbys) * 2`. `* 2` is for unexpected connection close.)

    * See also [PostgreSQL: Documentation: Replication][postgresql-max-wal-senders].

`/var/lib/pgsql/9.6/data/postgresql.conf`:

Before:

```text
#listen_address = 'localhost'
#wal_level = minimal
#max_wal_senders = 0
```

After:

```text
listen_address = '*'
wal_level = replica
max_wal_senders = 4
```

Add the following streaming replication configurations to `pg_hba.conf` on only primary:

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

Create the user for replication on only primary:

```text
% sudo -H systemctl start postgresql-9.6
% sudo -u postgres -H createuser --pwprompt --replication replicator
Enter password for new role: (passw0rd)
Enter it again: (passw0rd)
```

## [special] Add some PGroonga related configurations to `postgresql.conf` on primary

This is a PGroonga specific step.

Add [`pgronga.enable_wal` parameter][enable-wal] and [`pgroonga.max_wal_size` parameter][max-wal-size] configurations to `postgresql.conf` on only primary:

`/var/lib/pgsql/9.6/data/postgresql.conf`:

```text
pgroonga.enable_wal = on
# You may need more large size
pgroonga.max_wal_size = 100MB
```

Restart PostgreSQL to apply the configuration:

```text
% sudo -H systemctl restart postgresql-9.6
```

You can confirm whether you set the above parameters or not with the following SQL:

```sql
SELECT name,setting FROM pg_settings WHERE name LIKE '%pgroonga%';
```

## [normal] Insert data on primary

This is a normal step.

Create a normal user on only primary:

```text
% sudo -u postgres -H createuser ${USER}
```

Create a database on only primary:

```text
% sudo -u postgres -H createdb --locale C --encoding UTF-8 --owner ${USER} blog
```

Create a table in the created database on only primary.

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

## [special] Create a PGroonga index on primary

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

Create a PGroonga index on only primary:

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

## [special] Flush PGroonga related data on primary

This is a PGroonga specific step.

Ensure writing PGroonga related data on memory to disk on only primary. You can choose one of them:

  1. Run `SELECT pgroonga_command('io_flush');`

  2. Disconnect all connections

Here is an example to use `pgroonga_command('io_flush')`:

```sql
SELECT pgroonga_command('io_flush') AS command;
--                     command                    
-- -----------------------------------------------
--  [[0,1478446349.2241,0.1413860321044922],true]
-- (1 row)
```

You must not change tables that use PGroonga indexes on primary until the next `pg_basebackup` step is finished.

## [normal] Run `pg_basebackup` on standbys

This is a normal step.

Run `pg_basebackup` on only standbys. It copies the current database from primary.

Standbys:

```text
% sudo -u postgres -H pg_basebackup --host 192.168.0.30 --pgdata /var/lib/pgsql/9.6/data --xlog --progress --username replicator --password --write-recovery-conf
Password: (passw0rd)
149261/149261 kB (100%), 1/1 tablespace
```

## [normal] Add some streaming replication configurations to `postgresql.conf` on standbys

This is a normal step.

Add the following replica configurations to `postgresql.conf` on only standbys:

  * `hot_standby = on`

    * See also [PostgreSQL: Documentation: Replication][postgresql-hot-standby].

Standbys:

`/var/lib/pgsql/9.6/data/postgresql.conf`:

Before:

```text
#hot_standby = off
```

After:

```text
hot_standby = on
```

## [special] Add some PGroonga's WAL configurations to `postgresql.conf` on standbys

This is a PGroonga specific step.

Since 2.3.3.

Add [`pgroonga_wal_applier` module][pgroonga-wal-applier] to [`shared_preload_libraries` parameter][postgresql-shared-preload-libraries]:

Standbys:

`/var/lib/pgsql/9.6/data/postgresql.conf`:

Before:

```text
#shared_preload_libraries = ''
```

After:

```text
shared_preload_libraries = 'pgroonga_wal_applier'
```

You can confirm whether you set [`shared_preload_libraries` parameter][postgresql-shared-preload-libraries] or not with the following SQL:

```sql
SELECT name,setting FROM pg_settings WHERE name = 'shared_preload_libraries';
```

## [normal] Start PostgreSQL on standbys

This is a normal step.

Start PostgreSQL on standbys:

```text
% sudo -H systemctl start postgresql-9.6
```

Now, you can search data inserted on primary by PGroonga index created on primary.

Standby1:

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

You can also search data inserted on primary after `pg_basebackup`.

Primary:

```sql
INSERT INTO entries VALUES ('PostgreSQL 9.6 and replication', 'PostgreSQL supports generic WAL since 9.6. It is required for replication for PGroonga.');
```

Standby1:

```sql
SELECT title FROM entries WHERE title %% 'replication';
--              title              
-- --------------------------------
--  PGroonga and replication
--  PostgreSQL 9.6 and replication
-- (2 rows)
```

Standby2:

```text
% psql blog
```

```sql
SELECT title FROM entries WHERE title %% 'replication';
--              title              
-- --------------------------------
--  PGroonga and replication
--  PostgreSQL 9.6 and replication
-- (2 rows)
```

[postgresql-wal]:{{ site.postgresql_doc_base_url.en }}/warm-standby.html

[postgresql-reindex]:{{ site.postgresql_doc_base_url.en }}/sql-reindex.html

[crash-safe]:crash-safe.html

[postgresql-wal-level]:{{ site.postgresql_doc_base_url.en }}/runtime-config-wal.html#GUC-WAL-LEVEL

[postgresql-max-wal-senders]:{{ site.postgresql_doc_base_url.en }}/runtime-config-replication.html#GUC-MAX-WAL-SENDERS

[enable-wal]:parameters/enable-wal.html
[max-wal-size]:parameters/max-wal-size.html

[pgroonga-wal-applier]:modules/pgroonga-wal-applier.html

[postgresql-shared-preload-libraries]:{{ site.postgresql_doc_base_url.en }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES

[postgresql-hot-standby]:{{ site.postgresql_doc_base_url.en }}/runtime-config-replication.html#GUC-HOT-STANDBY
