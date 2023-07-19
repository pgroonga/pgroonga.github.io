---
title: Users
---

# Users

Here are PGroonga users.

## Supabase {#supabase}

[Supabase](https://supabase.com/) is an open source Firebase alternative that provides all the backend features developers need to build a product: a Postgres database, Authentication, instant APIs, Edge Functions, Realtime subscriptions, and Storage. Postgres is the core of Supabase, it works natively with more than 40 Postgres extensions, including PGroonga.

[https://supabase.com/blog/launch-week-6-community-day](https://supabase.com/blog/launch-week-6-community-day)

PGroonga could not be used in any managed service. Supabase let you use PGroonga, a fast full text search for all languages, on a managed PostgreSQL.
Supabase has the free basic plan to start. For people who couldn't use PGroonga because of PostgreSQL operation cost, it is a great chance to give a try!

For other plan and more information, please check [Supabase website](https://supabase.com/pricing). 

Supabase added PGroonga to our native extensions because PGroonga would be great option for multi language users.

Supabase values PostgreSQL License and the idea of OSS ecosystem because we make contributions to OSS community by providing services with those OSS licenses such as PostgreSQL License, BSD License, and MIT License.

Also Supabase gives financial contributions to various OSS including PGroonga via [Open Collective](https://opencollective.com/), a fundraising + legal status + money management platform.

* [Supabase Open Collective Page](https://opencollective.com/supabase)
* [PGroonga Open Collective Page](https://opencollective.com/pgroonga)

## National Institute of Japanese Literature {#nijl}

[Union Catalogue Database of Japanese Texts](https://kokusho.nijl.ac.jp/?ln=en) published by National Institute of Japanese Literature uses PGroonga to implement fast Japanese full text search feature.

See [E2612 – 日本古典籍を身近にする「国書データベース」](https://current.ndl.go.jp/e2612) which is an article at Current Awareness Portal for details.

## Zulip {#zulip}

[Zulip](https://zulip.org/) is a powerful open source group chat. It uses PGroonga to implement all languages support full text search. Because [PostgreSQL built-in full text search feature]({{ site.postgresql_doc_base_url.en }}/textsearch.html) supports only one language at the same time. PGroonga can support all languages at the same time.

## waja {#waja}

[waja](https://www.waja.co.jp/) is an EC for fashion items. It uses PGroonga to implement full text search by keywords.

Here are main reasons to use PGroonga:

  * It's easy to integrate with existing search process. (waja uses PostgreSQL.)

  * waja only needs to add indexes to use fast full text search.

  * It's fast enough.

PGroonga also supports query expansion and auto complete. Their precision can be  improved by maintaining normal PostgreSQL tables. It's easy to use.

See also [the blog post by the developer](https://www.waja.co.jp/corp/6359). (Japanese)

## Web portfolio search at Top Studio {#topstudio}

Our company, [Top Studio Corporation](https://www.topstudio.co.jp/), is a production company working mainly for the publisher's production like translation, writing, editing, proof reading, design, digital publishing, and etc.

We are introducing our work in the [Web portfolio](https://www.topstudio.co.jp/books/). Yet, we did not have search system for our work portfolio on the Web site, even though we have been stocking our work with our PostgreSQL database.

Because the sales departments requested to add the search function in order for the potential customer to search easily what kind of publishing the company has been done, we have examined "how to develop the search system". Of course, we had thought about simple SQL's LIKE operator and PostgreSQL's standard full text search feature, "tequery", but those methods require to clarify normalization of query strings and stored strings, or to install other big depending system like morphological analysis tool.

On the other hand, PGroonga is very simple and easy to setup. It only requires to enable the extension after the install. Since our service system is based on Debian GNU/Linux to start, we only followed the direction on the [Debian GNU/Linux install guide][install-debian] to install.

It is widely known to use multiple query words by using space between the words for narrowing-down the search results. We were thinking to use `&@~` operator in PGroonga for "AND search".

However, `&@~` operator requires highly functioned [query syntax][groonga-query-syntax] and the function is bit too much for general guest usage who only needs simple "AND search". We could imagine to receive nice advisories like "your system has a SQL injection vulnerability" that caused by too much high feature.

Thus, we chose sadly not to use `&@~` operator. We split query to keywords with space and build a condition that combines the split keywords with `&@` operator that is for single keyword search and SQL's `AND`. The splitting rule for query is `/[\s　,，.．・。、「」『』（）]+/` so that "AND results" come up even with random letters besides space.

For the future, we would like to improve the system with our meta tag by using [the score feature of PGroonga][tutorial-score]. Our work data are labeled with meta tags that inform the contents of the book like "Windows", "Linux", "Open Source", "machine learning". Currently adding those meta tag as the search makes the search results hazy. But we think it is important to utilize those tags that our staff are working on.

## (Send us your service name)

(Send us your service description, how do you use PGroonga and why did you choose PGroonga.)

You can send your use case from [https://github.com/pgroonga/pgroonga.github.io/edit/master/users/index.md](https://github.com/pgroonga/pgroonga.github.io/edit/master/users/index.md) .

[install-debian]: ../install/debian.html

[groonga-query-syntax]: https://groonga.org/docs/reference/grn_expr/query_syntax.html

[tutorial-score]:../tutorial/#score
