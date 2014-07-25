class AppsCache
  _instance = null

  class Cache
    constructor: ->
      @apps = {
        hellocato: {
          provider: "heroku",
          auto_merge: false,
          repository: "kevindperezm/hellocat",
          environments: ["production"],

          heroku_production_name: "hellocat"
        }
      }

  @instance: ->
    _instance ?= new Cache

module.exports = AppsCache
