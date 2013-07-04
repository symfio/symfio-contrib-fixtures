chai = require "chai"
w = require "when"


describe "contrib-fixtures example", ->
  chai.use require "chai-as-promised"
  chai.use require "chai-http"
  chai.should()

  container = require "../example"
  container.set "env", "test"

  before (callback) ->
    container.promise.should.notify callback

  describe "GET /laws", ->
    it "should respond with laws", (callback) ->
      container.get("app").then (app) ->
        deferred = w.defer()
        chai.request(app).get("/laws").res deferred.resolve
        deferred.promise
      .then (res) ->
        res.should.have.status 200
        res.body.should.have.length 3
        res.body[0].law.should.match /^A robot may not injure/
        res.body[1].law.should.match /^A robot must obey/
        res.body[2].law.should.match /^A robot must protect/
      .should.notify callback
