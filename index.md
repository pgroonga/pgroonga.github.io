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

PGroonga (p-g-runga) is an extension for PostgreSQL to use [Groonga](http://groonga.org/) as an index.

PostgreSQL isn't CJK full text search ready by default. You can use super fast CJK ready full text search feature by installing PGroonga into your PostgreSQL!

## Documentations

  * [News](news/): It lists release information.
  * [Overview](overview/): It describes about PGroonga.
  * [Install](install/): It describes how to install PGroonga.
  * [Tutorial](tutorial/): It describes how to use PGroonga step by step.
  * [Reference](reference/): It describes options and operators.
  * [Community](community/): It introduces about PGroonga community.

## License

PGroonga is released under [PostgreSQL license](http://opensource.org/licenses/postgresql) that is similar to BSD license and MIT license.

See [COPYING](https://github.com/pgroonga/pgroonga/blob/master/COPYING) file for details such as copyright holders.
