---
title: Users
---

# Users

Here are PGroonga users.

## Zulip

[Zulip](https://zulip.org/) is a powerful open source group chat. It uses PGroonga to implement all languages support full text search. Because [PostgreSQL built-in full text search feature]({{ site.postgresql_doc_base_url.en }}/textsearch.html) supports only one language at the same time. PGroonga can support all languages at the same time.

## waja

[waja](https://www.waja.co.jp/) is an EC for fashion items. It uses PGroonga to implement full text search by keywords.

Here are main reasons to use PGroonga:

  * It's easy to integrate with existing search process. (waja uses PostgreSQL.)

  * waja only needs to add indexes to use fast full text search.

  * It's fast enough.

PGroonga also supports query expansion and auto complete. Their precision can be  improved by maintaining normal PostgreSQL tables. It's easy to use.

See also [the blog post by the developer](https://www.waja.co.jp/corp/6359). (Japanese)

## (Send us your service name)

(Send us your service description, how do you use PGroonga and why did you choose PGroonga.)

You can send your use case from [https://github.com/pgroonga/pgroonga.github.io/edit/master/users/index.md](https://github.com/pgroonga/pgroonga.github.io/edit/master/users/index.md) .
