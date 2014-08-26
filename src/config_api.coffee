Config = require './config'

module.exports = (robot) ->
  return unless process.env['HUBOT_DEPLOY_REST_APPS']

  robot.router.get '/deploy/config', (req, res) ->
    # Get bot config
    config = JSON.stringify(Config.get())
    res.set 'Content-Type', 'application/json'
    res.set 'Content-Length', config.length
    res.status(200).send config
    res.end()
