Config = require './config'

module.exports = (robot) ->
  return unless process.env['HUBOT_DEPLOY_REST_APPS']

  Config.robot = robot
  Config.loadIntoEnvironment()

  robot.router.get '/deploy/config', (req, res) ->
    # Get bot config
    Config.get (config) ->
      config = JSON.stringify(config)
      res.set 'Content-Type', 'application/json'
      res.set 'Content-Length', config.length
      res.status(200).send config
      res.end()

  robot.router.post '/deploy/config', (req, res) ->
    # Saves bot config
    config = req.body
    Config.set(config)
    if Config.isValid()
      Config.save()
      res.status(204).end()
    else
      errors = JSON.stringify { errors: Config.get_validation_errors() }
      res.set 'Content-Type', 'application/json'
      res.set 'Content-Length', errors.length
      res.status(422).send errors
      res.end()
