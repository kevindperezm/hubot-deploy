module.exports = {
  replace: (substr, replacement, subject) ->
    while subject.indexOf(substr) >= 0
      subject = subject.replace substr, replacement
    subject
}
