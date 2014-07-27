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

    loadApps: (cb, that) ->
      return cb(@apps, that) if @apps && cb

      @db.get APPS, (err, data) =>
        @apps = if data && !err then JSON.parse(data)
        cb(@apps, that) if cb

    saveApps: (apps) ->
      @db.set APPS, apps
      @emit 'expire'

  @instance: ->
    _instance ?= new Cache

module.exports = AppsCache
