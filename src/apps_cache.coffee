redis = require 'redis'
EventEmitter = require 'events'

ID_VALUE = 'hubot-deploy-apps-id'
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

    saveApp: (newApp, cb) ->
      @db.incr ID_VALUE, (err, id) =>
        newApp.id = id
        saved = @db.rpush APPS, @stringify(newApp)
        @emit 'expire'
        cb(saved, newApp.id)

    editApp: (id, appData, cb) ->
      appData.id = id
      @indexForId appData.id, (index) =>
        res = @db.lset APPS, index, @stringify(appData)
        @emit 'expire'
        cb(res)

    deleteApp: (id, cb) ->
      @indexForId id, (index) =>
        @db.lindex APPS, index, (err, appToDel) =>
          deletedItems = if appToDel then @db.lrem(APPS, 1, appToDel) else 0
          @emit 'expire'
          cb(deletedItems > 0)

    findAppById: (id, cb) ->
      @indexForId id, (index) =>
        if index
          @db.lindex APPS, index, (err, app) =>
            cb JSON.parse(app)
        else
          cb(null)

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
        apps[app.name] = app
      apps

    indexForId: (id, cb) ->
      @db.lrange APPS, 0, -1, (err, apps) ->
        for app in apps
          app = JSON.parse app
          return cb apps.indexOf(app) if app.id == id
        cb(null)

    stringify: (obj) ->
      JSON.stringify(obj)

  @instance: ->
    _instance ?= new Cache

module.exports = AppsCache
