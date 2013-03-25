symfio = require "symfio"
plugin = require "../lib/fixtures"
suite = require "symfio-suite"
fs = require "fs"


describe "contrib-fixtures plugin", ->
  wrapper = suite.sandbox symfio, ->
    @model = ->
    @model.count = @sandbox.stub()
    @model.prototype = save: @sandbox.stub()
    @connection = model: @sandbox.stub()

    @users = [
      {username: "username", password: "password"}
      {username: "username", password: "password"}
      {username: "username", password: "password"}
    ]

    @sandbox.stub fs, "readdir"
    @sandbox.stub fs, "readFile"

    fs.readdir.yields null, ["users.json"]
    fs.readFile.yields null, JSON.stringify @users
    @connection.model.returns @model

    @container.set "connection", @connection

  it "should load fixtures only if collection is empty", wrapper (callback) ->
    @model.count.yields null, 0
    @model.prototype.save.yields()

    plugin @container, =>
      @expect(@model.prototype.save).to.have.been.calledThrice

      @model.prototype.save.reset()
      @model.count.yields null, 3

      plugin @container, =>
        @expect(@model.prototype.save).to.not.have.been.called
        callback()

  it "should warn if mongoose module isn't defined", wrapper (callback) ->
    @connection.model.throws()

    plugin @container, =>
      @expect(@logger.warn).to.have.been.calledOnce
      callback()

  it "should skip loading if json is invalid", wrapper (callback) ->
    fs.readFile.resetBehavior()
    fs.readFile.yields null, "invalid json"

    plugin @container, =>
      @expect(@connection.model).to.not.have.been.called
      callback()
