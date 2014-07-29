redis = require 'redis'
EventEmitter = require 'events'

APPS = 'hubot-deploy-apps'

class AppsCache
  _instance = null

  class Cache extends EventEmitter
    constructor: ->
      @db = @connectToServer()
      @on 'expire', =>
        console.log "Expiring cache of apps"
        console.log "Reloading cache"
        @loadApps()

    loadApps: (cb) ->
      return cb(@apps) if @apps && cb

      @db.lrange APPS, 0, -1, (err, data) =>
        @apps = @buildApps(data) unless err
        cb(@apps) if cb

    saveApp: (newApp) ->
      @db.rpush APPS, newApp
      @emit 'expire'

    deleteApp: (index, cb) ->
      @db.lrange APPS, 0, -1, (err, data) =>
        appToDelete = data[index]
        deletedItems = if appToDelete then @db.lrem(APPS, 1, appToDelete) else 0
        cb(deletedItems > 0)

    # private

    connectToServer: ->
      client = null
      if process.env['REDISTOGO_URL']
        rtg = require('url').parse process.env.REDISTOGO_URL
        client = redis.createClient(rtg.port, rtg.hostname);
        client.auth rtg.auth.split(':')[1]
      else
        client = redis.createClient()
      console.log 'AppsCache connected to server'
      client

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
