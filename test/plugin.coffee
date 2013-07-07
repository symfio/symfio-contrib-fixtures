suite = require "symfio-suite"
fs = require "fs"


describe "contrib-fixtures()", ->
  it = suite.plugin (container, containerStub, logger) ->
    require("..") containerStub, logger

    container.set "User", (sandbox, containerStub) ->
      User = ->
      User.count = sandbox.stub()
      User.prototype = save: sandbox.stub()
      User.prototype.save.yields()
      containerStub.get.promise.then.yields User
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
    it "should define", (containerStub) ->
      factory = containerStub.unless.get "fixturesDirectory"
      factory("/").should.equal "/fixtures"

  describe "container.set fixture", ->
    it "should save fixture", (containerStub, User) ->
      User.count.yields null, 0
      factory = containerStub.set.get "fixture"
      fixture = factory()
      fixture("User.json").then ->
        fs.readFile.should.be.calledOnce
        fs.readFile.should.be.calledWith "User.json"
        User.prototype.save.should.be.calledThrice

    it "should load fixture only if collection is empty",
      (containerStub, User) ->
        User.count.yields null, 3
        factory = containerStub.set.get "fixture"
        fixture = factory()
        fixture("User.json").then ->
          User.prototype.save.should.not.be.called

  describe "container.set fixtures", ->
    it "should save fixtures", (containerStub, User) ->
      User.count.yields null, 0
      factory = containerStub.set.get "fixtures"
      fixtures = factory()
      fixtures("/").then ->
        fs.readdir.should.be.calledOnce
        fs.readdir.should.be.calledWith "/"
        fs.readFile.should.be.calledOnce
        fs.readFile.should.be.calledWith "/User.json"
        User.prototype.save.should.be.calledThrice

  it "should load fixtures from fixturesDirectory", (containerStub, fixtures) ->
    factory = containerStub.inject.get 0
    factory fixtures, "/"
    fixtures.should.be.calledOnce
    fixtures.should.be.calledWith "/"
