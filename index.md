---
layout: en
---
<div class="jumbotron">
  <h1>
    <img alt="{{ site.title }}"
         title="{{ site.title }}"
         src="/images/pgroonga-logo.png">
  </h1>
  <p>{{ site.description }}</p>
  <p>
    <a href="/install/"
       class="btn btn-primary btn-lg"
       role="button">Use the latest version ({{ site.pgroonga_version }})
                     released at {{ site.pgroonga_release_date }}</a>
  </p>
</div>

## About PGroonga

PGroonga (píːzí:lúnɡά) is a PostgreSQL extension to use [Groonga](http://groonga.org/) as the index.

As default, PostgreSQL isn't capable for CJK full text search. You can use super fast CJK full text search feature by installing PGroonga into your PostgreSQL!

## Documentations

  * [News](news/): It lists release information.
  * [Overview](overview/): It describes about PGroonga.
  * [Install](install/): It describes how to install PGroonga.
  * [Tutorial](tutorial/): It describes how to use PGroonga step by step.
  * [How to](how-to/): It describes about useful information for specific situations.
  * [Reference](reference/): It describes details for each features such as options, functions and operators.
  * [Community](community/): It introduces about PGroonga community.

## License

PGroonga is released under [PostgreSQL license](http://opensource.org/licenses/postgresql) that is similar to BSD license and MIT license.

See [COPYING](https://github.com/pgroonga/pgroonga/blob/master/COPYING) file for details such as copyright holders.

Bundled software is released under different license. Here are bundled software and license information:

  * [xxHash](https://github.com/Cyan4973/xxHash)
    * BSD license
    * Copyright: `Copyright (c) 2012-2014, Yann Collet`
    * Detail: [`vendor/xxHash/LICENSE`](https://github.com/Cyan4973/xxHash/blob/master/LICENSE)

  * [Groonga](http://groonga.org/) (bundled only for Windows package)
    * LGPL 2.1
    * Copyright: `Copyright(C) 2009-2015 Brazil`
    * Detail: [`vendor/groonga/COPYING`](https://github.com/groonga/groonga/blob/master/COPYING)

