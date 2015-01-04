window.ext.storage = {

  _info :
    authors : ['Christian Juth']
    name : 'Storage'
    version : '0.1.0'
    compatibility :
      chrome : 'full'
      safari : 'full'

  _aliases : ['localStorage','local']

  _load : ->
    if !localStorage.storage?
      localStorage.storage = JSON.stringify({})

    $.ajax {
      url: '../../configure.json',
      dataType: 'json',
      async: false,
      success: (data) ->
        if ext.browser is 'chrome'
          options = data.options
          storedOptions = $.parseJSON localStorage.options
          for option in options
            if !storedOptions[option.key]?
              ext.options.set option.key,option.default

        storage = data.storage
        for item in storage
          if !ext.storage.get(item.key)?
            ext.storage.set(item.key, item.default)
      }


  #functions
  set : (key, value) ->
    storage = $.parseJSON localStorage.storage
    storage[key] = value
    localStorage.storage = JSON.stringify storage


  get : (key) ->
    storage = $.parseJSON localStorage.storage
    storage[key]


  remove : (key) ->
    storage = $.parseJSON localStorage.storage
    delete storage[key]
    localStorage.storage = JSON.stringify storage


  removeAll : (exceptions) ->
    for item in ext.storage.dump()
      if item not in exceptions
        ext.storage.remove(item)
    ext.storage.dump()


  dump : ->
    output = []
    $.each $.parseJSON(localStorage.storage), (key,val) ->
      output.push key
    output

}
