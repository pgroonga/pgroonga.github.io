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

  1. [normal][special] [Install PostgreSQL and PGroonga on both primary and standbys](#normalspecial-install-postgresql-and-pgroonga-on-both-primary-and-standbys)

  2. [normal] [Add some streaming replication configurations to `postgresql.conf` and `pg_hba.conf` on primary](#normal-add-some-streaming-replication-configurations-to-postgresqlconf-and-pg_hbaconf-on-primary)

  3. [special] [Add some PGroonga related configurations to `postgresql.conf` on primary](#special-add-some-pgroonga-related-configurations-to-postgresqlconf-on-primary)

  4. [normal] [Run `pg_basebackup` on standbys](#normal-run-pg_basebackup-on-standbys)

  5. [normal] [Add some streaming replication configurations to `postgresql.conf` on standbys](#normal-add-some-streaming-replication-configurations-to-postgresqlconf-on-standbys)

  6. [special] [Add some PGroonga's WAL configurations to `postgresql.conf` on standbys](#special-add-some-pgroongas-wal-configurations-to-postgresqlconf-on-standbys)

  7. [normal] [Restart PostgreSQL on standbys](#normal-restart-postgresql-on-standbys)

  8. [normal] [Insert data on primary](#normal-insert-data-on-primary)

  9. [special] [Create a PGroonga index on primary](#special-create-a-pgroonga-index-on-primary)

## Example environment

This document uses the following environment:

  * Primary:

    * OS: Ubuntu 22.04

    * IP address: 192.168.0.30

    * Database name: `blog`

    * Replication user name: `replicator`

  * Standby1:

    * OS: Ubuntu 22.04

    * IP address: 192.168.0.31

  * Standby2:

    * OS: Ubuntu 22.04

    * IP address: 192.168.0.32

This document shows command lines for CentOS 7. If you're using other platforms, adjust command lines by yourself.

## [normal][special] Install PostgreSQL and PGroonga on both primary and standbys {#install-postgresql-pgroonga}

Install PostgreSQL 15 on both primary and standbys.

Primary:

```bash
sudo apt install -y software-properties-common
sudo add-apt-repository -y universe
sudo add-apt-repository -y ppa:groonga/ppa
sudo apt install -y wget lsb-release
wget https://packages.groonga.org/ubuntu/groonga-apt-source-latest-$(lsb_release --codename --short).deb
sudo apt install -y -V ./groonga-apt-source-latest-$(lsb_release --codename --short).deb

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --no-default-keyring --keyring /usr/share/keyrings/pdgd-keyring.gpg --import -
echo "deb [signed-by=/usr/share/keyrings/pdgd-keyring.gpg] http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
sudo apt update
sudo apt install -y postgresql-15 postgresql-contrib-15

sudo apt update
sudo apt install -y -V postgresql-15-pgdg-pgroonga
```

Standbys:

```bash
sudo apt install -y software-properties-common
sudo add-apt-repository -y universe
sudo add-apt-repository -y ppa:groonga/ppa
sudo apt install -y wget lsb-release
wget https://packages.groonga.org/ubuntu/groonga-apt-source-latest-$(lsb_release --codename --short).deb
sudo apt install -y -V ./groonga-apt-source-latest-$(lsb_release --codename --short).deb

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --no-default-keyring --keyring /usr/share/keyrings/pdgd-keyring.gpg --import -
echo "deb [signed-by=/usr/share/keyrings/pdgd-keyring.gpg] http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
sudo apt update
sudo apt install -y postgresql-15 postgresql-contrib-15

sudo apt update
sudo apt install -y -V postgresql-15-pgdg-pgroonga
```

## [normal] Add some streaming replication configurations to `postgresql.conf` and `pg_hba.conf` on primary

This is a normal step.

Add the following streaming replication configurations to `postgresql.conf` on only primary:

  * `listen_address = '*'`

  * `wal_level = replica`

    * See also [PostgreSQL: Documentation: Write Ahead Log][postgresql-wal-level].

  * `max_wal_senders = 4` (`= 2 (The number of standbys) * 2`. `* 2` is for unexpected connection close.)

    * See also [PostgreSQL: Documentation: Replication][postgresql-max-wal-senders].

`/etc/postgresql/15/main/pg_hba.conf`:

Before:

```vim
#listen_address = 'localhost'
```

After:

```vim
listen_address = '*'
wal_level = replica
max_wal_senders = 4
```

Add the following streaming replication configurations to `pg_hba.conf` on only primary:

  * Accept replication connection by the replication user `replicator` from `192.168.0.0/24`.

`/etc/postgresql/15/main/pg_hba.conf`:

Before:

```vim
#local   replication     postgres                                peer
#host    replication     postgres        127.0.0.1/32            ident
#host    replication     postgres        ::1/128                 ident
```

After:

```vim
host    replication     replicator       192.168.0.0/24         trust
```

Create the user for replication on only primary:

```bash
sudo su - postgres

psql postgres
CREATE USER replicator WITH REPLICATION;
```

## [special] Add some PGroonga related configurations to `postgresql.conf` on primary

This is a PGroonga specific step.

Add [`pgronga.enable_wal` parameter][enable-wal] and [`pgroonga.max_wal_size` parameter][max-wal-size] configurations to `postgresql.conf` on only primary:

`/etc/postgresql/15/main/postgresql.conf`:

```vim
# Probably add to the bottom of psotgresql.cong
pgroonga.enable_wal = on
# You may need more large size
pgroonga.max_wal_size = 100MB
```

You can confirm whether you set the above parameters or not with the following SQL:

```sql
SELECT name,setting FROM pg_settings WHERE name LIKE '%pgroonga%';

Restart PostgreSQL to apply the configuration:

```bash
sudo -H systemctl restart postgresql
```

## [normal] Run `pg_basebackup` on standbys

This is a normal step.

Run `pg_basebackup` on only standbys. It copies the current database from primary.

Standbys:

```console
$ sudo -H systemctl stop postgresql
$ sudo -u postgres -H rm -rf /var/lib/postgresql/15/main
$ sudo -u postgres -H pg_basebackup --host 192.168.0.30 -D /var/lib/postgresql/15/main --progress -U replicator -R
Password: (passw0rd)
22987/22987 kB (100%), 1/1 tablespace

## [normal] Add some streaming replication configurations to `postgresql.conf` on standbys

This is a normal step.

Add the following replica configurations to `postgresql.conf` on only standbys:

  * `hot_standby = on`

    * See also [PostgreSQL: Documentation: Replication][postgresql-hot-standby].

Standbys:

`/etc/postgresql/15/main/postgresql.conf`:

Before:

```vim
data_directory = '/var/lib/postgresql/15/main'

#hot_standby = off
```

After:

```vim
data_directory = '/var/lib/postgresql/15/data'

hot_standby = on
```

## [special] Add some PGroonga's WAL configurations to `postgresql.conf` on standbys

This is a PGroonga specific step.

Since 2.3.3.

Add [`pgroonga_wal_applier` module][pgroonga-wal-applier] to [`shared_preload_libraries` parameter][postgresql-shared-preload-libraries]:

Standbys:

`/etc/postgresql/15/main/postgresql.conf`:

Before:

```vim
#shared_preload_libraries = ''
```

After:

```vim
shared_preload_libraries = 'pgroonga_wal_applier'

# Probably add to the bottom of postgresql.conf
pgroonga.enable_wal = on
# You may need more large size
pgroonga.max_wal_size = 100MB
```


## [normal] Start PostgreSQL on standbys

This is a normal step.

Restart PostgreSQL on standbys:

```bash
% sudo -H systemctl restart postgresql
```


## [normal] Insert data on primary

This is a normal step.

Create a database on only primary:

```bash
sudo -u postgres -H createdb blog
```

Create a table in the created database on only primary.

Connect to the created `blog` database:

```bash
sudo -u postgres -H psql blog
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

```bash
sudo su - postgres

psql blog
```

Create a PGroonga index on only primary:

```sql
CREATE INDEX entries_full_text_search ON entries USING pgroonga (title, body);
```

Confirm the index:

```sql
SET enable_seqscan TO off;
SELECT title FROM entries WHERE title &@~ 'replication';
--           title           
-- --------------------------
--  PGroonga and replication
-- (1 row)
```

Confirm replicated data on Standby1:

```sql
SELECT title FROM entries WHERE title &@~ 'replication';
--           title           
-- --------------------------
--  PGroonga and replication
-- (1 row)
```

Confirm replicated data on Standby2:

```text
% psql blog
```

```sql
SELECT title FROM entries WHERE title &@~ 'replication';
--           title           
-- --------------------------
--  PGroonga and replication
-- (1 row)
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
