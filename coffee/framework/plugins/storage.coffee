if typeof localStorage.storage is "undefined"
  localStorage.storage = JSON.stringify({})

window.ext.storage = {

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

  dump : () ->
    output = []
    $.each $.parseJSON(localStorage.storage), (key,val) ->
      output.push key
    output

}
