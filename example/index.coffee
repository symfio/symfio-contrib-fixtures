symfio = require "symfio"
w = require "when"


module.exports = container = symfio "example", __dirname

module.exports.promise = container.injectAll [
  require "symfio-contrib-winston"
  require "symfio-contrib-express"
  require "symfio-contrib-mongoose"
  require "symfio-contrib-cruder"

  (model) ->
    model "Laws", "laws", (mongoose) ->
      new mongoose.Schema
        number: Number
        law: String

    container.inject (resource, Laws) ->
      resource Laws, list: query: -> Laws.find().sort(number: 1)

  (connection) ->
    deffered = w.defer()

    connection.db.dropDatabase ->
      deffered.resolve container.inject require ".."

    deffered.promise
]


if require.main is module
  module.exports.promise.then ->
    container.get "startExpressServer"
  .then (startExpressServer) ->
    startExpressServer()
