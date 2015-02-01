#functions/options.coffee

#This is a group of functions that allow you to
#create options that the user can change.  What sets
#this apart from the Storage plugin is it is only
#for storing data the user can update.  This group
#of function will allow you to set, get, reset, and
#dump all the options.
options :



  _:{

  #INFO
  aliases : ['ops', 'opts']

  #THIS IS A HACK
  #local callback bindings
  changeBindings : []
  bindChange : (callback) ->
    ext.options._changeBindings.push callback
    console.log ext.options._changeBindings
    console.log callback
  callChangeBindings : ->
    console.log ext.options._changeBindings
    for fun in ext.options._changeBindings
      fun()

  load : ->
    alert()
    if ext._.browser is 'chrome'
      data = ext._.getConfig()
      for option in data.options
        if typeof ext.options.get(option.key) is 'undefined'
          ext.options.set(option.key, option.default)


  }



  #FUNCTIONS

  #This function will set a storage item.  It pulls
  #the value of localStorage.options, parses them as
  #a object, sets the option based on the key you
  #input, and last updates localStorage.options.
  set : (key, value) ->
    #check usage
    usage = 'key string, value'
    ok = ext._.validateArg(arguments, ['string','string,number,object'], usage)
    throw new Error(ok) if ok?
    #logic
    if ext._.browser is 'chrome'
      options = $.parseJSON localStorage.options
      options[key] = value
      localStorage.options = JSON.stringify options
      ext.options._.callChangeBindings()
    else if ext._.browser is 'safari'
      safari.extension.settings[key] = value
    return options[key]



  #This function will gram localStorage.options, parse
  #it as a object, retrieve the value of the key you
  #requested, and return the value.
  get : (key) ->
    #check usage
    usage = 'key string'
    ok = ext._.validateArg(arguments, ['string'], usage)
    throw new Error(ok) if ok?
    #logic
    if ext._.browser is 'chrome'
      options = $.parseJSON localStorage.options
      requestedOption = options[key]
    else if ext._.browser is 'safari'
      requestedOption = safari.extension.settings[key]
    return requestedOption



  #This function wil grab localStorage.options, parse
  #it as a object, delete the key you input, and update
  #localStorage.options with the object
  reset : (key) ->
    #check usage
    usage = 'key string'
    ok = ext._.validateArg(arguments, ['string'], usage)
    throw new Error(ok) if ok?
    #logic
    if ext._.browser is 'chrome'
      options = $.parseJSON localStorage.options
      $.ajax({
        url: '../../configure.json',
        dataType: 'json',
        async: false,
        success: (data) ->
          options[key] = _.filter(data.options, {'key' : key})[0].default
          localStorage.options = JSON.stringify options
      })
      optionReset = options[key]
    else if ext._.browser is 'safari'
      optionReset = safari.extension.settings.removeItem(key)
    return optionReset



  #This function will find al the defined options in
  #configure.json, get all the keys for those options,
  #and loop through them resetting them to their defaults.
  resetAll : (exceptions) ->
    $.ajax({
      url: '../../configure.json',
      dataType: 'json',
      async: false,
      success: (data) ->
        for item in data.options
          if -1 is exceptions.indexOf item.key
            ext.options.reset(item.key)
    })
    return ext.options.dump()



  #This function will return a array of option keys
  dump : ->
    #vars
    output = []
    #logic
    $.ajax({
      url: '../../configure.json',
      dataType: 'json',
      async: false,
      success: (data) ->
        for item in data.options
          output.push item.key
    })
    return output



  onChange: (callback) ->
    #check usage
    usage = 'callback function'
    ok = ext._.validateArg(arguments, ['function'], usage)
    throw new Error(ok) if ok?
    #logic
    if ext._.browser is 'chrome'
      bk = chrome.extension.getBackgroundPage().window
      bk.$(window).bind 'storage', (e) ->
        if e.originalEvent.key is 'options'
          callback()
      bk.ext.options._.bindChange(callback)
    if ext._.browser is 'safari'
      safari.extension.settings.addEventListener 'change', callback, false



