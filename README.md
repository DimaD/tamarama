# Tamarama

Tamarama is code written for SponsorPay Ruby Developer Challenge.

Tamarama is the name of the [beach in Sydney, Australia](https://en.wikipedia.org/wiki/Tamarama).

# How To Run

## Installing Dependencies

Code is written and tested on ruby 2.1. It uses new hashes syntax so it can not be run on ruby 1.8.

Gems dependencies are managed with [Bundler](http://bundler.io/v1.6/rationale.html). To install run this in your shell:

```shell
gem install --no-ri --no-rdoc bundler
```

Now you can pull in dependencies for this project. Step into project directory in the shell and run the following command (replace `2` with number of cores in your processor to parallelize installation):

```shell
bundle install -j2
```

## Running Tests

Tests (specs) are written in RSpec and could be run with rake:

```shell
bundle exec spec
```

## Generating Documentation

Code is documented and type annotated with [YARD](http://rubydoc.info/gems/yard/). You can generate API documentation for the code with rake:

```shell
bundle exec rake doc
```

Resulting HTML is placed into `doc/all` directory and you can open it on Mac OS X with

```shell
open doc/all/index.html
```
