strUtils = require '../utils/str'

class ConfigValidator
  @isValid = (config) ->
    if config.bot_name? && config.slack_team? &&
      config.slack_token? && config.github_token? &&
      config.deploy_timeout? && typeof config.deploy_timeout == 'number'
        true
    else
      @buildValidationErrors(config)
      false

  @buildValidationErrors = (config) ->
    @validation_errors = []
    fields = ['bot name', 'Slack team', 'Slack token', 'GitHub token']
    for field in fields
      property = strUtils.replace ' ', '_', field.toLowerCase()
      @validation_errors.push("Invalid #{field}") unless config[property]?
    unless config.deploy_timeout? && typeof config.deploy_timeout == 'number'
      @validation_errors.push 'Invalid deploy timeout'

module.exports = ConfigValidator
