redis = require 'redis'

CONFIG_KEY = "hubot-deploy-config"

# Singleton class for Config values
class Config
  _instance = null
  @get = (cb) ->
    _instance ?= new ConfigInstance
    _instance.get(cb)

  @save = (config) ->
    _instance ?= new ConfigInstance
    _instance.save(config)

  class ConfigInstance
    constructor: ->
      @db = @connectDB()

    get: (cb) ->
      @db.get CONFIG_KEY, (err, data) ->
        if err
          console.log "Can't get hubot-deploy config."
        else
          cb JSON.parse(data)

    save: (config) ->
      config = JSON.stringify(config)
      @db.set CONFIG_KEY, config

    connectDB: ->
      if process.env['REDISTOGO_URL']
        rtg = require('url').parse process.env.REDISTOGO_URL
        client = redis.createClient(rtg.port, rtg.hostname);
        client.auth rtg.auth.split(':')[1]
        client
      else
        redis.createClient()

module.exports = Config
