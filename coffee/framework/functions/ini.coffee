#functions/ini.coffee

#functions
ini : (options) ->
  #set vars
  options = $.extend defultOptions, options

  #expose options globally
  ext._config = options
  ext._.options = options

  ext._onload()

  return window.ext
