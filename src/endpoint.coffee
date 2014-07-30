AppsCache = require './apps_cache'

module.exports = (robot) ->
  return unless process.env['HUBOT_DEPLOY_REST_APPS']

  robot.router.get '/deploy/apps', (req, res) ->
    # Lists deployable apps
    AppsCache.instance().loadApps (apps) ->
      apps = [apps] unless typeof apps == Array
      res.set 'Content-Type', 'application/json'
      res.status(200).send JSON.stringify(apps)
      res.end()

  robot.router.get '/deploy/apps/:id', (req, res) ->
    AppsCache.instance().findAppById parseInt(req.params.id), (app) ->
      console.log "Callback called!"
      if app
        res.set 'Content-Type', 'application/json'
        res.status(200).send JSON.stringify(app)
      else
        res.status 404
      res.end()

  robot.router.post '/deploy/apps', (req, res) ->
    # Creates new deployable app.
    AppsCache.instance().saveApp req.body, (saved) ->
      if saved then res.status(201) else res.status(422)
      res.end()

  robot.router.patch '/deploy/apps/:id', (req, res) ->
    # Edits an app
    id = parseInt(req.params.id)
    AppsCache.instance().editApp id, req.body, (saved) ->
      if saved then res.status(204) else res.status(404)
      res.end()

  robot.router.delete '/deploy/apps/:id', (req, res) ->
    # Delete a specific app, given a name
    AppsCache.instance().deleteApp parseInt(req.params.id), (success) ->
      if success then res.status(204) else res.status(404)
      res.end()

