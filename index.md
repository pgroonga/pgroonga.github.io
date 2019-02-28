---
title: none
---

<div class="jumbotron">
  <h1>
    <img alt="{{ site.title }}"
         title="{{ site.title }}"
         src="/images/pgroonga-logo.png">
  </h1>
  <p>{{ site.description.en }}</p>
  <p>The latest version
     (<a href="news/#version-{{ site.pgroonga_version | replace:".", "-" }}">{{ site.pgroonga_version }}</a>)
     has been released at {{ site.pgroonga_release_date }}.
  </p>
  <p>
    <a href="tutorial/"
       class="btn btn-primary btn-lg"
       role="button">Try tutorial</a>
    <a href="install/"
       class="btn btn-primary btn-lg"
       role="button">Install</a>
  </p>
</div>

## About PGroonga {#about}

PGroonga (píːzí:lúnɡά) is a PostgreSQL extension to use [Groonga](http://groonga.org/) as the index.

PostgreSQL supports full text search against languages that use only alphabet and digit. It means that PostgreSQL doesn't support full text search against Japanese, Chinese and so on. You can use super fast full text search feature against all languages by installing PGroonga into your PostgreSQL!

## Documentations {#documentations}

  * [News](news/): It lists release information.

  * [Overview](overview/): It describes about PGroonga.

  * [Install](install/): It describes how to install PGroonga.

  * [Upgrade](upgrade/): It describes how to upgrade PGroonga.

  * [Uninstall](uninstall/): It describes how to uninstall PGroonga.

  * [Tutorial](tutorial/): It describes how to use PGroonga step by step.

  * [FAQ](faq/): Frequently asked questions.

  * [How to](how-to/): It describes about useful information for specific situations.

  * [Reference](reference/): It describes details for each features such as options, functions and operators.

  * [Community](community/): It introduces about PGroonga community.

  * [Users](users/): It lists PGroonga users.

  * [Development](development/): It describes how to develop PGroonga.

## License {#license}

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

  * [MeCab](http://taku910.github.io/mecab/) (bundled only for Windows package)
    * GPL, LGPL or BSD license
    * Copyright: `Taku Kudo <taku@chasen.org> and Nippon Telegraph and Telephone Corporation`
    * Detail: [`vendor/groonga/vendor/mecab-0.996/COPYING`](https://github.com/taku910/mecab/blob/master/mecab/COPYING)

  * [NAIST Japanese Dictionary](https://osdn.jp/projects/naist-jdic/) (bundled only for Windows package)
    * 3-clause BSD license
    * Copyright: `Copyright (c) 2009, Nara Institute of Science and Technology, Japan`
    * Detail: `vendor/groonga/vendor/mecab-naist-jdic-0.6.3b-20111013/COPYING`

  * [LZ4](http://www.lz4.org/) (bundled only for Windows package)
    * 2-clause BSD license for libraries
    * GPLv2+ for programs
    * Copyright: `Copyright (c) 2011-2015, Yann Collet`
    * Detail for libraries: `vendor/groonga/vendor/lz4-r131/lib/LICENSE`
    * Detail for programs: `vendor/groonga/vendor/lz4-r131/programs/COPYING`

  * [msgpack-c](https://github.com/msgpack/msgpack-c) (bundled only for Windows package)
    * Boost Software License Version 1.0
    * Copyright: `Copyright (C) 2008-2015 FURUHASHI Sadayuki`
    * Detail: [`vendor/groonga/vendor/msgpack-1.4.1/LICENSE_1_0.txt`](https://github.com/msgpack/msgpack-c/blob/master/LICENSE_1_0.txt)
