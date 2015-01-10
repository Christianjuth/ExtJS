#This is a group of functions that allow you to
#create options that the user can change.  What sets
#this apart from the Storage plugin is it is only
#for storing data the user can update.  This group
#of function will allow you to set, get, reset, and
#dump all the options.

options :

  #These are some simple aliases I have defined to
  #help keep things short and tidy.
  _aliases : ['ops', 'opts']


  #This function will set up undefined options when
  #the library is loaded.
  _load : ->
    if ext.browser is 'chrome'
      $.ajax {
      url: '../../configure.json',
      dataType: 'json',
      async: false,
      success: (data) ->
        for option in data.options
          if typeof ext.options.get(option.key) is 'undefined'
            ext.options.set(option.key, option.default)
      }


  #This function will set a storage item.  It pulls
  #the value of localStorage.options, parses them as
  #a object, sets the option based on the key you
  #input, and last updates localStorage.options.
  set : (key, value) ->
    if ext.browser is 'chrome'
      options = $.parseJSON localStorage.options
      options[key] = value
      localStorage.options = JSON.stringify options
    else if ext.browser is 'safari'
      safari.extension.settings[key] = value
    return options[key]


  #This function will gram localStorage.options, parse
  #it as a object, retrieve the value of the key you
  #requested, and return the value.
  get : (key) ->
    if ext.browser is 'chrome'
      options = $.parseJSON localStorage.options
      requestedOption = options[key]
    else if ext.browser is 'safari'
      requestedOption = safari.extension.settings[key]
    return requestedOption


  #This function wil grab localStorage.options, parse
  #it as a object, delete the key you input, and update
  #localStorage.options with the object
  reset : (key) ->
    if ext.browser is 'chrome'
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
    else if ext.browser is 'safari'
      optionReset = safari.extension.settings.removeItem(key)
    return optionReset


  #This function will find al the defined options in
  #configure.json, get all the keys for those options,
  #and loop through them resetting them to their defaults.
  resetAll : (exceptions) ->
    #vars
    output = []
    #logic
    $.ajax({
      url: '../../configure.json',
      dataType: 'json',
      async: false,
      success: (data) ->
        for item in data.options
          if exceptions.indexOf item is -1
            output.push ext.options.reset(item.key)
    })
    return output


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
          output.push item
    })
    return output


