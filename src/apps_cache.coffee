redis = require 'redis'

class AppsCache
  _instance = null

  class Cache
    constructor: ->
      @db = redis.createClient()

    loadApps: (cb, that) ->
      return cb(@apps, that) if @apps

      @db.get 'apps', (err, data) =>
        @apps = if data && !err then JSON.parse(data) else {}
        cb(@apps, that)

  @instance: ->
    _instance ?= new Cache

module.exports = AppsCache
