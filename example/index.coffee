symfio = require "symfio"
cruder = require "cruder"
w = require "when"


module.exports = container = symfio "example", __dirname

module.exports.promise = container.injectAll [
  require "symfio-contrib-winston"
  require "symfio-contrib-express"
  require "symfio-contrib-mongoose"

  (model, get) ->
    model "Laws", "laws", (mongoose) ->
      new mongoose.Schema
        number: Number
        law: String

    get "/laws", (Laws) ->
      cruder.list Laws.find().sort(number: 1)

  (connection) ->
    deffered = w.defer()

    connection.db.dropDatabase ->
      deffered.resolve container.inject require ".."

    deffered.promise
]


if require.main is module
  container.get("listener").then (listener) ->
    listener.listen()
