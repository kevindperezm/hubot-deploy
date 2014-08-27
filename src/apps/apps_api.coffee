Apps = require './apps'

PAGE_SIZE = 15

module.exports = (robot) ->
  return unless process.env['HUBOT_DEPLOY_REST_APPS']

  robot.router.get '/deploy/apps', (req, res) ->
    # Lists deployable apps
    Apps.instance().loadApps (apps) ->
      startFrom = req.param('page') || 0
      apps = formatIntoArray(apps, startFrom, PAGE_SIZE)
      res.set 'Content-Type', 'application/json'
      res.status(200).send JSON.stringify(apps)
      res.end()

  robot.router.get '/deploy/apps/:id', (req, res) ->
    Apps.instance().findAppById parseInt(req.params.id), (app) ->
      if app
        res.set 'Content-Type', 'application/json'
        res.status(200).send JSON.stringify(app)
      else
        res.status 404
      res.end()

  robot.router.post '/deploy/apps', (req, res) ->
    # Creates new deployable app.
    Apps.instance().saveApp req.body, (saved, id) ->
      res.set 'Location', "#{req.headers['Host']}/#{id}"
      if saved then res.status(201) else res.status(422)
      res.end()

  robot.router.patch '/deploy/apps/:id', (req, res) ->
    # Edits an app
    id = parseInt(req.params.id)
    Apps.instance().editApp id, req.body, (saved) ->
      if saved then res.status(204) else res.status(404)
      res.end()

  robot.router.delete '/deploy/apps/:id', (req, res) ->
    # Delete a specific app, given a name
    Apps.instance().deleteApp parseInt(req.params.id), (success) ->
      if success then res.status(204) else res.status(404)
      res.end()

  formatIntoArray = (sourceApps, startFrom, pageSize) ->
    apps = []
    for appName, appData of sourceApps
      apps.push(appData) if appData.id >= startFrom
      break if apps.length >= pageSize
    apps

