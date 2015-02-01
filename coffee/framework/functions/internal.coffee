#functions/internal.coffee

_:

  _load: ->



  browser: do->
    #vars
    userAgent = navigator.userAgent
    vendor =  navigator.vendor
    #logic
    if /Chrome/.test(userAgent) and /Google Inc/.test(vendor)
      browser = 'chrome'
    else if /Safari/.test(userAgent) and /Apple Computer/.test(vendor)
      browser = 'safari'
    else if /OPR/.test(userAgent) and /Opera Software/.test(vendor)
      browser = 'chrome'
    return browser



  #This function allows other functions to validate
  #their paramaters
  validateArg: (args, expected, usage)->
    usage = 'does not match usage function('+usage+')'
    for arg, i in expected
      arg = args[i]
      if expected[i]?
        types = expected[i].split(',')
        valid = false
        for type in types
          if typeof arg is type
            valid = true
            break
        return usage if !valid
    return undefined



  #This function returns the
  getConfig: (callback)->
    #check usage
    usage = 'callback function'
    ok = ext._.validateArg(arguments, ['function,undefined'], usage)
    throw new Error(ok) if ok?
    #set vars
    if callback?
      async = true
    else
      async = false
    #logic
    json = ''
    $.ajax({
      url: '../../configure.json',
      dataType: 'json',
      async: async,
      success: (data) ->
        json = data
        if callback?
          callback(json)
    })
    return json



  getDefaultIcon: ->
    json = ext._.getConfig()
    output = {}
    if !json.menuIcon? or (!json.menuIcon['16']? and !json.menuIcon['19']?)
      throw Error 'no default icons set in configure.json'
    else if !json.menuIcon['19']? and json.menuIcon['16']?
      json.menuIcon['19'] = json.menuIcon['16']
    else if !json.menuIcon['16']? and json.menuIcon['19']?
      json.menuIcon['16'] = json.menuIcon['19']
    output['19'] = json.menuIcon['19']
    output['16'] = json.menuIcon['16']
    return output




  load: (id,plugin)->
    #check usage
    usage = 'id string, plugin object'
    ok = ext._.validateArg(arguments, ['string','object'], usage)
    throw new Error(ok) if ok?
    #vars
    name = plugin._.name
    #expose plugin
    ext[id] = plugin
    if plugin._.aliases?
      for alias in plugin._.aliases
        if !ext[alias]?
          ext[alias] = ext[id]
          delete plugin._.aliases
        else
          msg = 'Ext plugin "'+name+'" can\'t define alias "'+alias+'"'
          ext._.log.warn msg
    if plugin._.onload?
      plugin._.onload(ext._.options)
      delete plugin._.onload



  log:
    info: ->
    warn: ->
    error: ->



