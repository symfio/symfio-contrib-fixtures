# symfio-contrib-fixtures

> Load fixtures to database from fixtures directory.

[![Build Status](https://travis-ci.org/symfio/symfio-contrib-fixtures.png?branch=master)](https://travis-ci.org/symfio/symfio-contrib-fixtures)
[![Coverage Status](https://coveralls.io/repos/symfio/symfio-contrib-fixtures/badge.png?branch=master)](https://coveralls.io/r/symfio/symfio-contrib-fixtures?branch=master)
[![Dependency Status](https://gemnasium.com/symfio/symfio-contrib-fixtures.png)](https://gemnasium.com/symfio/symfio-contrib-fixtures)
[![NPM version](https://badge.fury.io/js/symfio-contrib-fixtures.png)](http://badge.fury.io/js/symfio-contrib-fixtures)

## Usage

```coffee
symfio = require "symfio"

container = symfio "example", __dirname

container.inject require "symfio-contrib-mongoose"
container.inject require "symfio-contrib-fixtures"
```

## Dependencies

* [contrib-mongoose](https://github.com/symfio/symfio-contrib-mongoose)

## Configuration

### `fixturesDirectory`

Default value is `fixtures`.

## Services

### `fixture`

Fixture loading helper. First argument is path to fixture file.

### `fixtures`

Fixtures loading helper. First argument is path to directory with fixture files.

### `loadFixtures`

Function used to load fixtures after all plugins is loaded.
