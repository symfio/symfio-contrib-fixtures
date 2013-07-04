symfio = require "symfio"
plugin = require ".."
sinon = require "sinon"
chai = require "chai"
fs = require "fs"


describe "contrib-fixtures plugin", ->
  chai.use require "chai-as-promised"
  chai.use require "sinon-chai"
  chai.should()

  container = null
  sandbox = null
  User = null

  beforeEach ->
    container = symfio "test", __dirname
    sandbox = sinon.sandbox.create()

    User = ->
    User.count = sandbox.stub()
    User.prototype = save: sandbox.stub()
    container.set "User", ->
      User

    sandbox.stub fs, "readdir"
    fs.readdir.yields null, ["User.json"]

    sandbox.stub fs, "readFile"
    fs.readFile.yields null, JSON.stringify [
      {username: "username", password: "password"}
      {username: "username", password: "password"}
      {username: "username", password: "password"}
    ]

  afterEach ->
    sandbox.restore()

  it "should load fixtures only if collection is empty", (callback) ->
    User.count.yields null, 0
    User.prototype.save.yields()

    container.inject(plugin).then ->
      User.prototype.save.should.been.calledThrice
    .then ->
      User.prototype.save.reset()
      User.count.yields null, 3
    .then ->
      container.inject plugin
    .then ->
      User.prototype.save.should.not.been.called
    .should.notify callback
