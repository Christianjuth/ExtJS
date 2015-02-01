PLUGIN = {



#define plugin info object
_: {

#INFO
authors : ['Christian Juth']
name : 'Encrypted Storage'
aliases : ['enStore','enStorage']
version : '0.1.0'
min : '0.1.0'
compatibility :
  chrome : 'full'
  safari : 'full'
github : ''

#EVENTS
onload : ->
  if !localStorage.encryptedStorage?
    localStorage.encryptedStorage = JSON.stringify({})

  encryptedStorage = ext._.getConfig().encryptedStorage
  storage = JSON.parse(localStorage.encryptedStorage)
  for item in encryptedStorage
    if typeof storage[item.key] is 'undefined'
      log.info('storage item "'+item.key+'" default password is "password"')
      ext.encrypted_storage.set(item.key, item.default, 'password')

}



#FUNCTIONS
set : (key, passwd, value) ->
  #check usage
  usage = 'key string, passwd string, value string'
  expected = ['string','string','string']
  ok = ext._.validateArg(arguments,expected,usage)
  throw new Error(ok) if ok?
  #logic
  storage = $.parseJSON localStorage.encryptedStorage
  storage[key] = sjcl.encrypt passwd, value
  localStorage.encryptedStorage = JSON.stringify storage



get : (key, passwd) ->
  #check usage
  usage = 'key string, passwd string'
  expected = ['string','string']
  ok = ext._.validateArg(arguments,expected,usage)
  #logic
  output = ''
  storage = $.parseJSON localStorage.encryptedStorage
  return if typeof storage[key] is 'undefined'
  try
    output = sjcl.decrypt passwd, storage[key]
  catch error
    log.warn error.message
    output = false
  return output



changePasswd : (key, Old, New) ->
  #check usage
  usage = 'key string, oldPasswd string, newPasswd string'
  expected = ['string','string','string']
  ok = ext._.validateArg(arguments,expected,usage)
  #logic
  value = ext.encrypted_storage.get key, Old
  ext.encrypted_storage.set key, value, New



remove : (key) ->
  #check usage
  usage = 'key string'
  expected = ['string']
  ok = ext._.validateArg(arguments,expected,usage)
  #logic
  storage = $.parseJSON localStorage.encryptedStorage
  delete storage[key]
  localStorage.encryptedStorage = JSON.stringify encryptedStorage



removeAll : (exceptions) ->
  #check usage
  usage = 'exceptions array'
  expected = ['object']
  ok = ext._.validateArg(arguments,expected,usage)
  #logic
  for item in ext.encrypted_storage.dump()
    if item not in exceptions
      ext.encrypted_storage.remove(item)
  ext.encrypted_storage.dump()



dump : ->
  output = []
  $.each $.parseJSON(localStorage.encryptedStorage), (key,val) ->
    output.push key
  output


}

encryptedStorage = []
