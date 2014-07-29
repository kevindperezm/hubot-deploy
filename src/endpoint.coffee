AppsCache = require './apps_cache'

module.exports = (robot) ->
  return unless process.env['HUBOT_DEPLOY_WEB_ENDPOINT']

  robot.router.get '/deploy/apps', (req, res) ->
    # Lists deployable apps
    AppsCache.instance().loadApps (apps) ->
      body = {apps: apps}
      res.status(200).setHeader 'Content-Type', 'application/json'
      res.send JSON.stringify(body)
      res.end()

  robot.router.post '/deploy/apps', (req, res) ->
    # Creates new deployable app.
    app = JSON.stringify req.body.app
    AppsCache.instance().saveApp(app)
    res.status(201).end()

  robot.router.delete '/deploy/apps/:id', (req, res) ->
    # Delete a specific app, given a name
    AppsCache.instance().deleteApp parseInt(req.params.id), (success) ->
      if success then res.status(204) else res.status(404)
      res.end()

