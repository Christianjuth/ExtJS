PLUGIN = {



_: {

#INFO
authors : ['Christian Juth']
name : 'Storage'
aliases : ['localStorage','local']
version : '0.1.0'
min : '0.1.0'
compatibility :
  chrome : 'full'
  safari : 'full'

#EVENTS
onload : ->
  if !localStorage.storage?
    localStorage.storage = JSON.stringify({})
  data = ext._.getConfig()
  for item in data.storage
    if typeof ext.storage.get(item.key) is 'undefined'
      log.info('storage item "' + item.key + '" was created')
      ext.storage.set(item.key, item.default)

}



#FUNCTIONS

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
