---
title: FAQ
---

# FAQ

## PGroonga fails to initialize {#fail-initialize}

These are reasons why PGroonga may failed to initialize:

  * [SELinux](#selinux)

If the issue is fixed and PGroonga still returns `pgroonga: already tried to initialize and failed`, please restart PostgreSQL so failed/corrupt `<data dir>/pgrn*` files can be detected and removed.

### SELinux support {#selinux}

If you use SELinux then PGroonga needs a policy package. The section [building PGroonga from source](../install/source.html) shows how to create one.

Before installing the policy package, perhaps your PGroonga installation had failed due to incorrect SELinux permissions. In this case, you must restart PostgreSQL to clean PGroonga failed/corrupt files.

## PGroonga on the managed service

If you want to use Groonga on the managed service to develop web applications, please check [Supabase](https://supabase.com/).

### Supabase 

Supabase is an open source Firebase alternative that provides all the backend features developers need to build a product: a Postgres database, Authentication, instant APIs, Edge Functions, Realtime subscriptions, and Storage.

Postgres is the core of Supabase, it works natively with more than 40 Postgres extensions, including PGroonga.

## Trouble Shooting

If you encounter the troubles, please check [reference manual]({% link reference/index.md %}) and [community]({% link community/index.md %}) for assistants.

If you find the bug, please feel free to report on [GitHub](https://github.com/pgroonga/pgroonga). Your report would help PGroonga to improve better.

