symfio = require "symfio"
cruder = require "cruder"

module.exports = container = symfio "example", __dirname
loader = container.get "loader"

loader.use require "symfio-contrib-express"
loader.use require "symfio-contrib-mongoose"

loader.use (container, callback) ->
  connection = container.get "connection"
  mongoose = container.get "mongoose"

  LawsSchema = new mongoose.Schema
    number: Number
    law: String

  connection.model "laws", LawsSchema

  callback()

loader.use require "../lib/fixtures"

loader.use (container, callback) ->
  connection = container.get "connection"
  unloader = container.get "unloader"
  app = container.get "app"

  Laws = connection.model "laws"

  app.get "/laws", cruder.list Laws.find().sort(number: 1)

  unloader.register (callback) ->
    connection.db.dropDatabase ->
      callback()

  callback()

loader.load() if require.main is module
