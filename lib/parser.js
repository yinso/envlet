// Generated by CoffeeScript 1.10.0
(function() {
  var Parser, Type;

  Type = require('typelet');

  Parser = (function() {
    Parser.convert = function(type, key, defaultVal) {
      var e, error;
      try {
        type = typeof type === 'string' ? Type.Parser.parse(type) : type;
        if (type instanceof Type.ArrayType) {
          if (typeof process.env[key] === 'string') {
            return type.convert(process.env[key].split(/\s*,\s*/));
          } else {
            return type.convert(process.env[key]);
          }
        } else {
          return type.convert(process.env[key]);
        }
      } catch (error) {
        e = error;
        if (arguments.length > 2) {
          return defaultVal;
        } else {
          throw e;
        }
      }
    };

    function Parser(prefix, options) {
      this.prefix = prefix;
      this.table = {};
    }

    Parser.prototype.define = function(key, type, defaultVal) {
      type = Type.parse(type);
      return this.table[key] = {
        type: type,
        defaultVal: defaultVal
      };
    };

    Parser.prototype.int = function(key, defaultVal) {
      return this.define(key, 'int', defaultVal);
    };

    return Parser;

  })();

  module.exports = Parser;

}).call(this);
