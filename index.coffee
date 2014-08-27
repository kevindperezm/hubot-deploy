Path = require 'path'

module.exports = (robot, scripts) ->
  robot.loadFile(Path.resolve(__dirname, "src/config"), "config_api.coffee")
  robot.loadFile(Path.resolve(__dirname, "src/apps"), "apps_api.coffee")
  robot.loadFile(Path.resolve(__dirname, "src"), "script.coffee")
