suite = require "symfio-suite"


describe "contrib-express example", ->
  it = suite.example require "../example"

  describe "GET /laws", ->
    it "should respond with laws", (request) ->
      request.get("/laws").then (res) ->
        res.should.have.status 200
        res.body.should.have.length 3
        res.body[0].law.should.match /^A robot may not injure/
        res.body[1].law.should.match /^A robot must obey/
        res.body[2].law.should.match /^A robot must protect/
