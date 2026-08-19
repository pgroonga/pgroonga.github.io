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

See also [E2612 – 日本古典籍を身近にする「国書データベース」](https://current.ndl.go.jp/e2612) which is an article at Current Awareness Portal.

See also [NIJL Tech Talk Vol.1 - How to support variant form of a character](https://www.youtube.com/watch?v=sNwBKeyfBGk) which is a video that describes how to support variant form of a character.

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

## Kelteu {#kelteu}

[Kelteu](https://www.kelteu.com) is a community-driven, Wikipedia-like application focused on products and shopping. The platform enables users to explore detailed product information, such as country of origin, ingredients, ratings, prices (including taxes) across various locations, and more. With Kelteu, you can create and share shopping lists, locate stores where specific products are available, track price histories by region, and enjoy many other features.

Available in 51 languages, Kelteu relies entirely on PGroonga to power its search functionality.

PGroonga was chosen for its robust, out-of-the-box full-text search capabilities that support all languages. Its speed and performance rival established tools like Elasticsearch and Solr. Additionally, as a PostgreSQL extension, PGroonga seamlessly integrates with your existing database stack, eliminating the need for extra components or complex integrations. All search functionalities can be accessed via standard SQL queries.

PGroonga also scales efficiently and maintains high performance even with complex queries on huge data sets, making it an ideal choice for a feature-rich application like Kelteu.

## IvorySQL {#ivorysql}

[IvorySQL](https://www.ivorysql.org/) is an advanced open-source, Oracle-compatible PostgreSQL branch database. We chose to integrate PGroonga to provide our users with a high-performance, multilingual full-text search solution. As IvorySQL's user base is global, and many applications need to process East Asian languages, PGroonga's "out-of-the-box" functionality and excellent support for all languages made it the best choice for us.

The integration of PGroonga with IvorySQL was very smooth. Its exceptional search speed and high scalability allow us to deliver an experience for our users that rivals proprietary search engines, without the need for additional complex architecture. Users simply need to create a PGroonga index within IvorySQL to enjoy fast full-text search through simple SQL queries, significantly lowering the barrier to development and operational costs.

## kokkai-data (国会議事録検索) {#kokkai-data}

[kokkai-data (国会議事録検索)](https://kokkai-data.com) is a site for full text search of the minutes of Japan's National Diet. It's developed and operated by an individual. It contains about 9.6 million speeches from May 1947 to the present, and you can trace speakers, meetings, and dates from keywords.

PGroonga handles the full text search. A single index is built on the speech text column using `TokenBigramSplitSymbolAlphaDigit` and `NormalizerNFKC150`, and searches are done with `&@~`. Searches across about 9.6 million records return in tens of milliseconds.

The reason for choosing PGroonga was that it doesn't require setting up a search engine outside of PostgreSQL. Since it's operated by an individual, it's hosted on a single VPS (virtual 6 cores / 8GB memory) shared with other sites. There wasn't room to prepare another server for search, and I didn't want to increase the number of things to back up and monitor. With PGroonga, all you need is to build a single index, and the search conditions can be written in ordinary SQL `WHERE` clauses, so there's no need to implement filtering and sorting twice, once in the search engine and once in the application.

What I've learned from running it is summarized in articles.

* [pg_total_relation_sizeが20GBって言うから信じてたら、実際は56GB使ってた](https://zenn.dev/sato_ken/articles/667459027f2025)
* [「Ｇ７」も「G7」も正規化するとg7になる。それでも検索結果は0件だった](https://zenn.dev/sato_ken/articles/651faad6e137ac)

## Multilingual knowledge search at Kuroko Labs {#kurokolabs}

[Kuroko Labs](https://kurokolabs.ai/) is a Munich company building AI agents for manufacturers, working in Japanese and German. For a Japanese manufacturer we built and operate a knowledge search over internal documents written in Japanese and Thai (inspection reports, for example) that answers with the source passage attached. It serves sites in three countries and about 5,000 people.

PGroonga does the full text search. One index on the `content` column with `TokenBigram` and `NormalizerNFKC150`, queried with `&@~`. Japanese and Thai run on the same index. We merge the results with vector search (pgvector) using Reciprocal Rank Fusion and hand the top candidates to Cohere Rerank for the final order.

Two reasons for PGroonga. Internal documents are full of words no dictionary knows: new part numbers, in-house abbreviations, Thai loanwords. TokenBigram finds them without a dictionary. And the search engine stays inside PostgreSQL. The index sits next to pgvector in the same database, so there is nothing new to back up or monitor.

Part numbers tripped us once. The default TokenBigram keeps a run of letters or digits as one token, so `QC-2031` does not match `203`. Instead of a finer tokenizer we extract part numbers with a regular expression into a separate column and match by prefix there.

Design and operation details are in these articles (Japanese):

* [Making Japanese text without spaces searchable in a RAG pipeline: PGroonga TokenBigram, pgvector and RRF](https://qiita.com/kurokolabs/items/c0b187822580dc5e96fb)
* [When part numbers do not match: how PGroonga TokenBigram splits alphanumerics, and the workaround we chose](https://zenn.dev/kurokolabs/articles/dc7d8b1829c37f)
* [Case study: multilingual knowledge agent](https://kurokolabs.ai/en/case-studies/rag-knowledge-agent)

## (Send us your service name)

(Send us your service description, how do you use PGroonga and why did you choose PGroonga.)

You can send your use case from [https://github.com/pgroonga/pgroonga.github.io/edit/master/users/index.md](https://github.com/pgroonga/pgroonga.github.io/edit/master/users/index.md) .

[install-debian]: ../install/debian.html

[groonga-query-syntax]: https://groonga.org/docs/reference/grn_expr/query_syntax.html

[tutorial-score]:../tutorial/#score
