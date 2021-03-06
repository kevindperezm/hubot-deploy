redis = require 'redis'
validator = require './config_validator'

CONFIG_KEY = "hubot-deploy-config"

# Singleton class for Config values
class Config
  _config = null
  _default_config = {
    bot_name: 'hubot',
    slack_team: '',
    slack_token: '',
    github_token: '',
    deploy_timeout: 15
  }

  constructor: ->
    @robot = null

  @get = (cb) ->
    if _config
      cb(_config)
    else
      @load (config) ->
        _config = config
        cb(_config)

  @load = (cb) ->
    instance = new ConfigInstance
    instance.get (config) ->
      _config = config || _default_config
      cb(_config)

  @set = (config) ->
    _config = config

  @save = ->
    instance = new ConfigInstance
    instance.save(_config)
    @loadIntoEnvironment()

  @isValid = ->
    validator.isValid(_config)

  @get_validation_errors = ->
    validator.validation_errors

  @loadIntoEnvironment = ->
    @get (config) =>
      @setEnvironmentVars(config)
      @updateSlackAdapterConfig()
      console.log 'Updated deployment environment variables'

  @setEnvironmentVars = (config) ->
    process.env['HUBOT_SLACK_BOTNAME'] = config.bot_name
    process.env['HUBOT_SLACK_TEAM'] = config.slack_team
    process.env['HUBOT_SLACK_TOKEN'] = config.slack_token
    process.env['HUBOT_GITHUB_TOKEN'] = config.github_token
    process.env['HUBOT_DEPLOY_TIMEOUT'] = config.deploy_timeout

  @updateSlackAdapterConfig = ->
    if @robot? and @robot.adapter.parseOptions?
      @robot.adapter.parseOptions()
      console.log 'Updated Slack adapter options'

  class ConfigInstance
    constructor: ->
      @db = @connectDB()

    get: (cb) ->
      @db.get CONFIG_KEY, (err, data) ->
        if err
          console.log "Can't get deployment config."
        else
          cb JSON.parse(data)

    save: (config) ->
      config = JSON.stringify(config)
      console.log 'Updated deployment config'
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
