symfio = require "symfio"
cruder = require "cruder"

module.exports = container = symfio "example", __dirname

container.use require "symfio-contrib-express"
container.use require "symfio-contrib-mongoose"

container.use (model, get) ->
  model "Laws", "laws", (mongoose) ->
    new mongoose.Schema
      number: Number
      law: String

  get "/laws", (Laws) ->
    cruder.list Laws.find().sort(number: 1)

container.use require ".."

container.load() if require.main is module
