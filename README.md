# symfio-contrib-fixtures

> Load fixtures to database from fixtures directory.

[![Build Status](http://teamcity.rithis.com/httpAuth/app/rest/builds/buildType:id:bt14,branch:master/statusIcon?guest=1)](http://teamcity.rithis.com/viewType.html?buildTypeId=bt14&guest=1)
[![Dependency Status](https://gemnasium.com/symfio/symfio-contrib-fixtures.png)](https://gemnasium.com/symfio/symfio-contrib-fixtures)

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
