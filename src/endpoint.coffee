module.exports = (robot) ->
  robot.router.post '/deploy/apps', (req, res) ->
    console.log 'Incoming request in /deploy/apps endpoint'
    res.end()
