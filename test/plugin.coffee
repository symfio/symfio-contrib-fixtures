plugin = require ".."
suite = require "symfio-suite"
fs = require "fs"


describe "contrib-fixtures()", ->
  it = suite.plugin [
    (container) ->
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
  ]

  it "should load fixtures only if collection is empty", (container, User) ->
    container.inject(plugin).then ->
      User.prototype.save.should.been.calledThrice
      User.prototype.save.reset()
      User.count.yields null, 3
    .then ->
      container.inject plugin
    .then ->
      User.prototype.save.should.not.been.called
