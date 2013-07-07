plugin = require ".."
suite = require "symfio-suite"
fs = require "fs"


describe "contrib-fixtures()", ->
  it = suite.plugin [
    (container) ->
      container.set "applicationDirectory", __dirname

      container.set "User", (sandbox) ->
        User = ->
        User.count = sandbox.stub()
        User.prototype = save: sandbox.stub()
        User.count.yields null, 0
        User.prototype.save.yields()
        User

      container.inject (sandbox) ->
        sandbox.stub fs, "readdir"
        fs.readdir.yields null, ["User.json"]

        sandbox.stub fs, "readFile"
        fs.readFile.yields null, JSON.stringify [
          {username: "username", password: "password"}
          {username: "username", password: "password"}
          {username: "username", password: "password"}
        ]

    plugin
  ]

  describe "container.unless fixturesDirectory", ->
    it "should define", (fixturesDirectory) ->
      fixturesDirectory.should.equal "#{__dirname}/fixtures"

  describe "container.set fixture", ->
    it "should save fixture", (fixture, User) ->
      fs.readFile.reset()
      User.prototype.save.reset()

      fixture("User.json").then ->
        fs.readFile.should.be.calledOnce
        fs.readFile.should.be.calledWith "User.json"
        User.prototype.save.should.be.calledThrice

    it "should load fixture only if collection is empty", (fixture, User) ->
      User.prototype.save.reset()
      User.count.yields null, 3

      fixture("User.json").then ->
        User.prototype.save.should.not.be.called

  describe "container.set fixtures", ->
    it "should save fixtures", (fixtures, User) ->
      fs.readdir.reset()
      fs.readFile.reset()
      User.prototype.save.reset()

      fixtures("/").then ->
        fs.readdir.should.be.calledOnce
        fs.readdir.should.be.calledWith "/"
        fs.readFile.should.be.calledOnce
        fs.readFile.should.be.calledWith "/User.json"
        User.prototype.save.should.be.calledThrice

  it "should load fixtures from fixturesDirectory", (container) ->
    container.set "fixtures", (sandbox) ->
      sandbox.spy()

    container.inject (sandbox) ->
      sandbox.stub container, "set"
    .then ->
      container.inject plugin
    .then ->
      container.get ["fixtures", "fixturesDirectory"]
    .spread (fixtures, fixturesDirectory) ->
      fixtures.should.be.calledOnce
      fixtures.should.be.calledWith fixturesDirectory
