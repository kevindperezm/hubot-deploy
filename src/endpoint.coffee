AppsCache = require './apps_cache'

module.exports = (robot) ->
  robot.router.post '/deploy/apps', (req, res) ->
    # Creates new deployable app.
    app = JSON.stringify req.body.app
    AppsCache.instance().saveApp(app)
    res.end()
