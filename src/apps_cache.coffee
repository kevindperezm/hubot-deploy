class AppsCache
  _instance = null

  class Cache
    constructor: ->
      console.log "Creada instancia de cache"

  @instance: ->
    _instance ?= new Cache

module.exports = AppsCache
