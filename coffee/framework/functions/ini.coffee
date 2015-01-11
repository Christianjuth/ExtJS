#functions
ini : (options) ->
  #set vars
  options = $.extend defultOptions, options
  this.browser = this.getBrowser()

  #define global options
  window.ext._config = options

  #set required storage items
  if !localStorage.options? and this.browser is 'chrome'
    localStorage.options = JSON.stringify({})

  #check plugins for _ APIs
  $.each ext, (item) ->
    #set vars
    item = window.ext[item]
    if item._info?
      name = item._info.name
    else
      name = item

    #call load function
    if item._load?
      item._load(options)
      delete item._load

    #check if aliases exists
    if item._aliases?
      #set aliases
      for alias in item._aliases
        if !window.ext[alias]?
          window.ext[alias] = item

        #alias warning
        else if options.silent isnt true
          msg = 'Ext plugin "'+name+'" can\'t define alias "'+alias+'"'
          console.warn msg

      delete item._aliases

    #check compatibility
    if item._info? and options.silent isnt true
      compatibility = item._info.compatibility
      #chrome compatibility
      if compatibility.chrome is 'none'
        console.warn 'Ext plugin "' + name + '" is Safari only'
      else if compatibility.chrome isnt 'full'
        msg = 'Ext plugin "' + name + '" may contain some Safari only functions'
        console.warn msg

      #safari compatibility
      if compatibility.safari is 'none'
        console.warn 'Ext plugin "' + name + '" is Chrome only'
      else if compatibility.safari isnt 'full'
        msg = 'Ext plugin "' + name + '" may contain some Chrome only functions'
        console.warn msg

    delete item._info
  return window.ext
