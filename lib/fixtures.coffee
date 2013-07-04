nodefn = require "when/node/function"
apply = require "when/apply"
path = require "path"
fs = require "fs"
w = require "when"


module.exports = (container, logger) ->
  readFixturesDirectory = (fixturesDirectory) ->
    nodefn.call(fs.readdir, fixturesDirectory).then (files) ->
      files.map (file) ->
        path.join fixturesDirectory, file


  readFixtures = (files) ->
    fixtures = []

    for file in files
      if path.extname(file) in [".json", ".js", ".coffee"]
        fixture = readFixture file
        fixtures.push w.join file, fixture if fixture

    w.all fixtures


  readFixture = (file) ->
    switch path.extname file
      when ".json"
        readJSONFixture file
      when ".js", ".coffee"
        readJSFixture file
      else
        w.reject new Error "Unknown fixture format `#{file}'"


  readJSONFixture = (file) ->
    nodefn.call(fs.readFile, file).then (data) ->
      JSON.parse data


  readJSFixture = (file) ->
    require file


  saveFixtures = (fixtures) ->
    w.map fixtures, apply saveFixture


  saveFixture = (file, fixture) ->
    parseKey(file).then (key) ->
      [key, getModel(key)]

    .spread (key, Model) ->
      [key, Model, countModel(Model)]

    .spread (key, Model, count) ->
      if count == 0
        logger.info "save fixture", file: file, model: key

        w.map fixture, (data) ->
          item = new Model data
          nodefn.call item.save.bind item


  parseKey = (file) ->
    w.resolve path.basename file, path.extname file


  getModel = (key) ->
    container.get key


  countModel = (Model) ->
    nodefn.call Model.count.bind Model


  loadFixture = (file) ->
    readFixture(file).then (fixture) ->
      saveFixture file, fixture


  loadFixtures = (fixturesDirectory) ->
    readFixturesDirectory(fixturesDirectory)
    .then(readFixtures)
    .then(saveFixtures)


  container.unless "fixturesDirectory", (applicationDirectory) ->
    path.join applicationDirectory, "fixtures"

  container.set "fixture", ->
    loadFixture

  container.set "fixtures", ->
    readFixturesDirectory

  container.inject (fixturesDirectory) ->
    loadFixtures fixturesDirectory
