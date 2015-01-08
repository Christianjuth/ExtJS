options :

  _aliases : ['ops', 'opts']

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

  #functions
  set : (key, value) ->
    if ext.browser is 'chrome'
      options = $.parseJSON localStorage.options
      options[key] = value
      localStorage.options = JSON.stringify options
    else if ext.browser is 'safari'
      safari.extension.settings[key] = value
    return options[key]

  get : (key) ->
    if ext.browser is 'chrome'
      options = $.parseJSON localStorage.options
      requestedOption = options[key]
    else if ext.browser is 'safari'
      requestedOption = safari.extension.settings[key]
    return requestedOption

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

  resetAll : (exceptions) ->
    $.ajax({
      url: '../../configure.json',
      dataType: 'json',
      async: false,
      success: (data) ->
        for item in data.options
          ext.options.reset(item.key)
    })
    return localStorage.options
