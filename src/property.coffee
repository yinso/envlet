Type = require 'typelet'

class EnvironmentProperty
  constructor: (key, type, defaultVal) ->
    if not (@ instanceof EnvironmentProperty)
      if arguments.length == 2
        return new EnvironmentProperty key, type
      else
        return new EnvironmentProperty key, type, defaultVal
    @key = key
    @type =
      if type instanceof Type
        type
      else
        Type.parse type
    if arguments.length > 2
      if not @type.isa defaultVal
        throw new Error("Environment: #{key}: wrong default val type: #{defaultVal} not a #{@type}")
      @defaultVal = defaultVal
    @aliases = []
  addAlias: (alias) ->
    @aliases.push alias
  convert: (key) ->
    @type.convert process.env[key]
  parse: () ->
    try
      return @convert @key
    catch e
      for alias in @aliases
        try
          return @convert alias
        catch e
          continue
      if @hasOwnProperty('defaultVal')
        return @defaultVal
      else
        throw new Error("Environment: missing #{@key} (aliases: [#{@aliases.join(', ')}])")
  @normalName: (key, appName) ->
    prefix =
      if typeof(appName) == 'string' and appName.length > 0
        appName.toUpperCase() + '_'
      else
        ''
    if key.indexOf(prefix) == 0
      key.substring(prefix.length)
    else
      key
  @wrappedName: (key, appName) ->
    prefix =
      if typeof(appName) == 'string' and appName.length > 0
        appName.toUpperCase() + '_'
      else
        ''
    if key.indexOf(prefix) == 0
      key
    else
      prefix + key

module.exports = EnvironmentProperty


