#functions/ini.coffee

#functions
ini : (options) ->
  #set vars
  options = $.extend defultOptions, options

  #expose options globally
  ext._.options = options

  ext._.onload()

  return window.ext
