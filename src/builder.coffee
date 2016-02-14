Type = require 'typelet'
Property = require './property'

class Builder
  constructor: (name, options = {}) ->
    if not (@ instanceof Builder)
      return new Builder(arguments...)
    @appName = name
    @keys = {}
    @defs = []
    for key, opt of options
      @set key, opt
    return
  set: (key, options = {}) ->
    wrappedKey = Property.wrappedName key, @appName
    normalKey = Property.normalName key, @appName
    if @defs.hasOwnProperty(wrappedKey) or @defs.hasOwnProperty(normalKey)
      throw new Error("envlet.set:duplicate_key: #{key}")
    if not options.hasOwnProperty('type')
      throw new Error("envlet.set:type_must_be_defined: #{key}")
    type = Type.parse options.type
    prop =
      if options.hasOwnProperty('default')
        Property wrappedKey, type, options.default
      else
        Property wrappedKey, type
    @keys[wrappedKey] = prop
    @defs.push prop
    @_aliasOne prop, normalKey
    @
  int: (key, defaultVal) ->
    if not @keys.hasOwnProperty(key)
      if arguments.length > 1
        @set key, type: 'int', default: defaultVal
      else
        @set key, type: 'int'
    prop = @keys[key]
    if prop.type != Type.Integer
      throw new Error("envlet.property_type_redefined: from #{prop.type} to int")
    return prop.parse()
  _aliasOne: (prop, keyTo) ->
    prop.addAlias keyTo
    @keys[keyTo] = prop
    @
  alias: (keyFrom, keyTo) ->
    wrappedKeyTo = Property.wrappedName keyTo, @appName
    normalKeyTo = Property.normalName keyTo, @appName
    if @keys.hasOwnProperty(wrappedKeyTo) or @keys.hasOwnProperty(normalKeyTo)
      throw new Error("envlet.alias:duplicate_key: #{keyTo}")
    if not @keys.hasOwnProperty(keyFrom)
      throw new Error("envlet.alias:unknown_key: #{keyFrom}")
    prop = @keys[keyFrom]
    @_aliasOne prop, wrappedKeyTo
    @_aliasOne prop, normalKeyTo
    @
  parse: () ->
    @argv = {}
    try
      for prop in @defs
        val = prop.parse()
        @argv[prop.key] = val
        for alias in prop.aliases
          @argv[alias] = val
      @
    catch e
      if process.env.ON_ERROR_HALT != 'false'
        @usage()
        process.exit()
      else
        throw e
  usage: () ->
    console.log "Usage: "
    for prop in @defs
      console.log "  #{prop.key}: #{prop.type}", (if prop.defaultVal then "(default: #{prop.defaultVal})" else "")
    return
  get: (key) ->
    if @keys.hasOwnProperty(key)
      @keys[key].parse()
    else
      process.env[key]
  _get: (key, type, defaultVal) ->
    if not @keys.hasOwnProperty(key)
      if arguments.length > 1
        @set key, type: type, default: defaultVal
      else
        @set key, type: type
    prop = @keys[key]
    if prop.type != type
      throw new Error("envlet.property_type_redefined: from #{prop.type} to #{type}")
    return prop.parse()
  int: (key, defaultVal) ->
    @_get Type.Integer, arguments...
  float: (key, defaultVal) ->
    @_get Type.Float, arguments...
  string: (key, defaultVal) ->
    @_get Type.String, arguments...
  bool: (key, defaultVal) ->
    @_get Type.Boolean, arguments...
  date: (key, defaultVal) ->
    @_get Type.Date, arguments...
  array: (key, type, defaultVal) ->
    type =
      if typeof(type) == 'string'
        Type.parse type
      else
        type
    @_get Type.ArrayType(type), arguments...

module.exports = Builder

