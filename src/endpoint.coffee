AppsCache = require './apps_cache'

module.exports = (robot) ->
  robot.router.post '/deploy/apps', (req, res) ->
    apps = JSON.stringify req.body.apps
    AppsCache.instance().saveApps(apps)
    res.end()
