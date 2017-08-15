---
title: How to use PGroonga on Travis CI
---

# How to use PGroonga on Travis CI

You can use PGroonga on [Travis CI](https://travis-ci.org/).

PGroonga provides shell script to set up PGroonga on Travis CI.

Add the following configuration into your `.travis.yml`:

```yaml
sudo: required
install:
  - curl --silent --location https://raw.githubusercontent.com/pgroonga/pgroonga/master/data/travis/setup.sh | sh
```

`sudo: required` is important. The setup script uses `sudo`. So `sudo: required` is required.

The setup script runs `CREATE EXTENSION pgroonga` against `template1` database. It means that you can use PGroonga without any instruction on new database.
