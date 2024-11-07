---
title: FAQ
---

# FAQ

## PGroonga fails to initialize {#fail-initialize}

These are some reasons why PGroonga fails to initialize:

  * [SELinux](#selinux)

If the issue is fixed and PGroonga still returns `pgroonga: already tried to initialize and failed`, please restart PostgreSQL so failed/corrupt `<data dir>/pgrn*` files can be detected and removed.

### SELinux {#selinux}

If you use SELinux then PGroonga needs a policy package. The section [building PGroonga from source](../install/source.html) shows how to create one.

Before installing the policy package, perhaps your PGroonga installation had failed due to incorrect SELinux permissions. In this case, you must restart PostgreSQL to clean PGroonga failed/corrupt files.

## Managed service including PGroonga {#managed-pgroonga}

There is a DBaaS that includes PGroonga:

### Supabase

[Supabase](https://supabase.com/) is an open source Firebase alternative that provides all the backend features developers need to build a product: a PostgreSQL database, Authentication, instant APIs, Edge Functions, Realtime subscriptions, and Storage.

PostgreSQL is the core of Supabase, it works natively with more than 40 PostgreSQL extensions, including PGroonga.
