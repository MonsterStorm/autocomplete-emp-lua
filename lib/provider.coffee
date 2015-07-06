fs = require 'fs'
path = require 'path'

propertyPrefixPattern = /(?:^|\[|\(|,|=|:|\s)\s*([a-zA-Z]+(\.|:)(?:[a-zA-Z]+\.?){0,2})$/

module.exports =
  selector: '.source.xhtml .lua, .lua'
  filterSuggestions: true
  inclusionPriority: 10
  # excludeLowerPriority: true

  getSuggestions: ({bufferPosition, editor}) ->
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    @getCompletions(line)

  load: ->
    @loadCompletions()

  loadCompletions: ->
    @completions ?= {}
    completionsDir = path.resolve(__dirname, '..', 'completions')

    fs.readdir completionsDir, (error, files) =>
      return if error?
      files.forEach (file) =>
        file = path.join completionsDir, file
        data = require file
        @completions[k] = v for k, v of data
        console.log @completions
      return
    # fs.readFile ,completionsDir, (error, content) =>
    #   return if error?
    #   @completions = JSON.parse(content)
    #   return

  getCompletions: (line) ->
    completions = []
    match =  propertyPrefixPattern.exec(line)?[1]
    return completions unless match

    segments = match.split('.')
    if segments.length == 1
      segments = match.split(':')
    prefix = segments.pop() ? ''
    segments = segments.filter (segment) -> segment
    property = segments[segments.length - 1]
    if /(ctrl|control)$/gi.test(property)
      property = "control"
    propertyCompletions = @completions[property]?.completions ? []
    for completion in propertyCompletions when not prefix or firstCharsEqual(completion.name, prefix)
      completions.push(clone(completion))
    completions

clone = (obj) ->
  newObj = {}
  newObj[k] = v for k, v of obj
  newObj

firstCharsEqual = (str1, str2) ->
  str1[0].toLowerCase() is str2[0].toLowerCase()
