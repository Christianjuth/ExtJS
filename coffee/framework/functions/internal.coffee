#functions/internal.coffee

_:

  #VARS
  version: '0.1.0'
  internal: []
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


  #EVENTS
  onbeforeload: (ext)->
    Keys = Object.keys(ext)
    Keys.splice(Keys.indexOf('_'),1)
    ext._.internal = Keys

     #set required localStorage items
    if !localStorage.options? and ext._.browser is 'chrome'
      localStorage.options = JSON.stringify({})

    ext._.options = defultOptions
    for item in ext._.internal
      if item isnt '_'
        item = ext[item]
        #set aliases
        if item._? and item._.aliases?
          name = item._.name
          for alias in item._.aliases
            if !ext[alias]?
              ext[alias] = item
            else
              msg = 'ExtJS can\'t define alias "'+alias+'"'
              ext._.log.warn msg
        #trigger onload event
        if item._? and item._.onload?
          item._.onload()



  onload: ->
    #define ext log object
    ext._.log = {}
    #log
    if ext._.options.verbose is true
      ext._.log.info = do ->
        Function.prototype.bind.call(console.info, console)
      ext._.log.warn = do ->
        Function.prototype.bind.call(console.warn, console)
    else
      ext._.log.info = ->
      ext._.log.warn = ->
    #error
    ext._.log.error = do ->
      Function.prototype.bind.call(console.error, console)



  #FUNCTIONS

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





  run: (fun)->
    bk = ext._.getBackground()
    fun = fun.bind(fun)
    fun.call(bk.window)



  getBackground: ->
    bk = ''
    if ext._.browser is 'chrome'
      bk = chrome.extension.getBackgroundPage().window
    if ext._.browser is 'safari'
      bk = safari.extension.globalPage.contentWindow
    return bk



  backgroundProxy: (fun)->
    bk = ext._.getBackground()
    bk.ext._.run(fun)




  load: (id,plugin)->
    #check usage
    usage = 'id string, plugin object'
    ok = ext._.validateArg(arguments, ['string','object'], usage)
    throw new Error(ok) if ok?
    if !plugin._?
      ext._.log.error('plugin missing header')
      return false
    #vars
    name = plugin._.name
    bk = ext._.getBackground()

    #load plugin in background page
    if bk.window isnt window and plugin._.background is true
      bk.ext._.load(id,plugin)

    #trigger onbeforeload event
    if plugin._.onbeforeload?
      plugin._.onbeforeload(plugin)
    #expose plugin
    ext[id] = plugin
    #trigger onload event
    if plugin._.onload?
      plugin._.onload(ext._.options)
    #define aliases
    if plugin._.aliases?
      for alias in plugin._.aliases
        if !ext[alias]?
          ext[alias] = ext[id]
        else
          msg = 'Ext plugin "'+name+'" can\'t define alias "'+alias+'"'
          ext._.log.warn msg
    #check compatibility
    if plugin._.compatibility?
      compatibility = plugin._.compatibility
      #chrome compatibility
      if compatibility.chrome is 'none'
        msg = 'Ext plugin "' + name + '" is Safari only'
        ext._.log.warn msg
      else if compatibility.chrome isnt 'full'
        msg = 'Ext plugin "' + name + '" may contain some Safari only functions'
        ext._.log.warn msg

      #safari compatibility
      if compatibility.safari is 'none'
        msg = 'Ext plugin "' + name + '" is Chrome only'
        ext._.log.warn msg
      else if compatibility.safari isnt 'full'
        msg = 'Ext plugin "' + name + '" may contain some Chrome only functions'
        ext._.log.warn msg



  log:
    info: ->
    warn: ->
    error: ->



