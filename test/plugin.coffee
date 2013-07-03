symfio = require "symfio"
plugin = require ".."
sinon = require "sinon"
chai = require "chai"
fs = require "fs"


describe "contrib-fixtures plugin", ->
  chai.use require "chai-as-promised"
  chai.use require "sinon-chai"
  chai.should()

  connection = null
  container = null
  sandbox = null
  model = null

  beforeEach ->
    container = symfio "test", __dirname
    sandbox = sinon.sandbox.create()

    model = ->
    model.count = sandbox.stub()
    model.prototype = save: sandbox.stub()

    sandbox.stub fs, "readdir"
    fs.readdir.yields null, ["users.json"]

    sandbox.stub fs, "readFile"
    fs.readFile.yields null, JSON.stringify [
      {username: "username", password: "password"}
      {username: "username", password: "password"}
      {username: "username", password: "password"}
    ]

    connection = model: sandbox.stub()
    connection.model.returns model
    container.set "connection", connection

  afterEach ->
    sandbox.restore()

  it "should load fixtures only if collection is empty", (callback) ->
    model.count.yields null, 0
    model.prototype.save.yields()

    container.call(plugin).then ->
      model.prototype.save.should.been.calledThrice
    .then ->
      model.prototype.save.reset()
      model.count.yields null, 3
    .then ->
      container.call plugin
    .then ->
      model.prototype.save.should.not.been.called
    .should.notify callback

  it "should reject if mongoose module isn't defined", (callback) ->
    connection.model.throws()
    container.call(plugin).should.be.rejected.and.notify callback
