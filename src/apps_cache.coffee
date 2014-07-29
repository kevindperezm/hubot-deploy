redis = require 'redis'
EventEmitter = require 'events'

APPS = 'hubot-deploy-apps'

class AppsCache
  _instance = null

  class Cache extends EventEmitter
    constructor: ->
      @db = redis.createClient()
      @on 'expire', =>
        console.log "Expiring cache of apps"
        console.log "Reloading cache"
        @loadApps()

    loadApps: (cb) ->
      return cb(@apps) if @apps && cb

      @db.lrange APPS, 0, -1, (err, data) =>
        @apps = @buildApps(data) unless err
        cb(@apps) if cb

    saveApp: (app) ->
      @db.rpush APPS, app
      @emit 'expire'

    # private

    buildApps: (data) ->
      apps = {}
      if data then for str in data
        app = JSON.parse(str)
        app.id = data.indexOf(str)
        apps[app.name] = app
      apps

  @instance: ->
    _instance ?= new Cache

module.exports = AppsCache
