suite = require "symfio-suite"
fs = require "fs"


describe "contrib-fixtures()", ->
  it = suite.plugin (container) ->
    container.inject ["suite/container", "logger"], require ".."

    container.set "applicationDirectory", "/"
    container.set "fixturesDirectory", "/fixtures"

    container.set "User",
      ["sandbox", "suite/container"],
      (sandbox, container) ->
        User = ->
        User.count = sandbox.stub()
        User.prototype = save: sandbox.stub()
        User.prototype.save.yields()
        container.get.promise.then.yields User
        User

    container.set "fixtures", (sandbox) ->
      sandbox.spy()

    container.inject (sandbox) ->
      sandbox.stub fs, "readdir"
      fs.readdir.yields null, ["User.json"]

      sandbox.stub fs, "readFile"
      fs.readFile.yields null, JSON.stringify [
        {username: "username", password: "password"}
        {username: "username", password: "password"}
        {username: "username", password: "password"}
      ]

  describe "container.unless fixturesDirectory", ->
    it "should define", (unlessed) ->
      factory = unlessed "fixturesDirectory"
      factory().should.eventually.equal "/fixtures"

  describe "container.set fixture", ->
    it "should save fixture", (setted, User) ->
      User.count.yields null, 0
      factory = setted "fixture"
      factory().then (fixture) ->
        fixture "User.json"
      .then ->
        fs.readFile.should.be.calledOnce
        fs.readFile.should.be.calledWith "User.json"
        User.prototype.save.should.be.calledThrice

    it "should load fixture only if collection is empty", (setted, User) ->
      User.count.yields null, 3
      factory = setted "fixture"
      factory().then (fixture) ->
        fixture "User.json"
      .then ->
        User.prototype.save.should.not.be.called

  describe "container.set fixtures", ->
    it "should save fixtures", (setted, User) ->
      User.count.yields null, 0
      factory = setted "fixtures"
      factory().then (fixtures) ->
        fixtures "/"
      .then ->
        fs.readdir.should.be.calledOnce
        fs.readdir.should.be.calledWith "/"
        fs.readFile.should.be.calledOnce
        fs.readFile.should.be.calledWith "/User.json"
        User.prototype.save.should.be.calledThrice

  describe "container.set loadFixtures", ->
    it "should load fixtures from fixturesDirectory", (setted) ->
      factory = setted "loadFixtures"
      factory().then (loadFixtures) ->
        loadFixtures()
      .then ->
        factory.dependencies.fixtures.should.be.calledOnce
        factory.dependencies.fixtures.should.be.calledWith "/fixtures"
