redis = require 'redis'
EventEmitter = require 'events'

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

      @db.get 'apps', (err, data) =>
        @apps = if data && !err then JSON.parse(data) else {}
        cb(@apps, that) if cb

  @instance: ->
    _instance ?= new Cache

module.exports = AppsCache
