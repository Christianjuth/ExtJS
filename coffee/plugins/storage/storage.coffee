PLUGIN = {



_: {

#INFO
authors : ['Christian Juth']
name : 'Storage'
aliases : ['localStorage','local']
version : '0.1.0'
libMin : '0.1.0'
background:  false
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
  #check usage
  usage = 'key string, value string'
  expected = ['string','string']
  ok = ext._.validateArg(arguments,expected,usage)
  throw new Error(ok) if ok?
  #logic
  storage = $.parseJSON localStorage.storage
  storage[key] = value
  localStorage.storage = JSON.stringify storage



get : (key) ->
  #check usage
  usage = 'key string'
  expected = ['string']
  ok = ext._.validateArg(arguments,expected,usage)
  throw new Error(ok) if ok?
  storage = $.parseJSON localStorage.storage
  storage[key]



remove : (key) ->
  #check usage
  usage = 'key string'
  expected = ['string']
  ok = ext._.validateArg(arguments,expected,usage)
  throw new Error(ok) if ok?
  storage = $.parseJSON localStorage.storage
  delete storage[key]
  localStorage.storage = JSON.stringify storage



removeAll : (exceptions) ->
  #check usage
  usage = 'exceptions array'
  expected = ['object']
  ok = ext._.validateArg(arguments,expected,usage)
  throw new Error(ok) if ok?
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
