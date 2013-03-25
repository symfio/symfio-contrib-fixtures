async = require "async"
path = require "path"
fs = require "fs"


module.exports = (container, callback) ->
  applicationDirectory = container.get "application directory"
  fixturesDirectory = path.join applicationDirectory, "fixtures"

  fixturesDirectory = container.get "fixtures directory", fixturesDirectory
  connection = container.get "connection"
  logger = container.get "logger"

  logger.info "loading plugin", "contrib-fixtures"

  fs.readdir fixturesDirectory, (err, files) ->
    return callback() unless files

    tasks = []
    for file in files
      if path.extname(file) is ".json"
        tasks.push
          collection: path.basename file, ".json"
          file: path.join fixturesDirectory, file

    worker = (task, callback) ->
      async.waterfall [
        (callback) ->
          fs.readFile task.file, callback

        (data, callback) ->
          try
            callback null, JSON.parse data
          catch err
            callback null, false

        (fixture, callback) ->
          return callback() unless fixture

          try
            model = connection.model task.collection
          catch err
            logger.warn err
            return callback null

          model.count (err, count) ->
            return callback err if err
            return callback null if count > 0

            logger.info "loading fixture", task.collection

            itemWorker = (data, callback) ->
              item = new model data
              item.save callback

            async.forEachSeries fixture, itemWorker, ->
              callback()

      ], callback

    async.forEach tasks, worker, ->
      callback()
