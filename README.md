# symfio-contrib-fixtures

> Load fixtures to database from fixtures directory.

[![Build Status](http://teamcity.rithis.com/httpAuth/app/rest/builds/buildType:id:bt14,branch:master/statusIcon?guest=1)](http://teamcity.rithis.com/viewType.html?buildTypeId=bt14&guest=1)
[![Dependency Status](https://gemnasium.com/symfio/symfio-contrib-fixtures.png)](https://gemnasium.com/symfio/symfio-contrib-fixtures)

## Usage

```coffee
symfio = require "symfio"

container = symfio "example", __dirname

container.use require "symfio-contrib-mongoose"
container.use require "symfio-contrib-fixtures"

container.load()
```

## Required plugins

* [contrib-mongoose](https://github.com/symfio/symfio-contrib-mongoose)

## Can be configured

* __fixturesDirectory__ - Default value is `fixtures`.
