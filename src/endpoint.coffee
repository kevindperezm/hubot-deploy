AppsCache = require './apps_cache'

module.exports = (robot) ->
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
    res.end()

