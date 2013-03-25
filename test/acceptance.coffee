suite = require "symfio-suite"


describe "contrib-fixtures example", ->
  wrapper = suite.http require "../example"

  describe "GET /laws", ->
    it "should respond with laws", wrapper (callback) ->
      test = @http.get "/laws"

      test.res (res) =>
        @expect(res).to.have.status 200
        @expect(res.body).to.have.length 3
        @expect(res.body[0].law).to.match /^A robot may not injure/
        @expect(res.body[1].law).to.match /^A robot must obey/
        @expect(res.body[2].law).to.match /^A robot must protect/

        callback()
