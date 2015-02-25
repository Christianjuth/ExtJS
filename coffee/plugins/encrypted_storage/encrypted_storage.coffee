PLUGIN = {



#define plugin info object
_: {

#INFO
authors:    ['Christian Juth']
name:        'Encrypted Storage'
aliases:    ['enStore','enStorage']
version:     '0.1.0'
libMin:      '0.1.0'
background:   false
compatibility:
  chrome:    'full'
  safari:    'full'
github:     'https://github.com/Christianjuth/ExtJS_Library/tree/master'

#OPTIONS
options:
  silent: false

#EVENTS
onload : ->
  Default = JSON.stringify({})
  encryptedStorage = ext._.getConfig().encryptedStorage
  storage = {}
  if !localStorage.encryptedStorage?
    localStorage.encryptedStorage = sjcl.encrypt('password',Default)
    for item in encryptedStorage
      log.info('storage item "'+item.key+'" default password is "password"')
      ext.encrypted_storage.set(item.key, 'password', item.default)

}



#FUNCTIONS
set : (key, passwd, value) ->
  #check usage
  usage = 'key string, passwd string, value string'
  expected = ['string','string']
  ok = ext._.validateArg(arguments,expected,usage)
  throw new Error(ok) if ok?
  #logic
  storage = localStorage.encryptedStorage
  try
    storage = sjcl.decrypt(passwd, storage)
  catch err
    throw Error err.message
  storage = $.parseJSON storage
  storage[key] = value
  storage = sjcl.encrypt(passwd, JSON.stringify storage)
  localStorage.encryptedStorage =  storage
  return undefined



get : (key, passwd) ->
  #check usage
  usage = 'key string, passwd string'
  expected = ['string','string']
  ok = ext._.validateArg(arguments,expected,usage)
  throw new Error(ok) if ok?
  #logic
  output = ''
  storage = localStorage.encryptedStorage
  try
    storage = sjcl.decrypt(passwd, storage)
  catch err
    throw Error err.message
  storage = $.parseJSON storage
  if !storage[key]?
    throw Error 'undefined item'
  output = storage[key]
  return output



changePasswd : (Old, New) ->
  #check usage
  usage = 'oldPasswd string, newPasswd string'
  expected = ['string','string']
  ok = ext._.validateArg(arguments,expected,usage)
  throw new Error(ok) if ok?
  #logic
  storage = localStorage.encryptedStorage
  try
    storage = sjcl.decrypt(Old, storage)
  catch err
    throw Error err.message
  storage = sjcl.encrypt(New, storage)
  localStorage.encryptedStorage =  storage



remove : (key,passwd) ->
  #check usage
  usage = 'key string, passwd string'
  expected = ['string','string']
  ok = ext._.validateArg(arguments,expected,usage)
  throw new Error(ok) if ok?
  #logic
  storage = localStorage.encryptedStorage
  try
    storage = sjcl.decrypt(passwd, storage)
  catch err
    throw Error err.message
  storage = $.parseJSON storage
  delete storage[key]
  storage = sjcl.encrypt(passwd, JSON.stringify storage)
  localStorage.encryptedStorage =  storage



removeAll : (passwd,exceptions) ->
  #check usage
  usage = 'passwd string, exceptions array'
  expected = ['string', 'object,undefined']
  ok = ext._.validateArg(arguments,expected,usage)
  throw new Error(ok) if ok?
  #logic
  for item in ext.encrypted_storage.dump(passwd)
    if !exceptions?  or item not in exceptions
      ext.encrypted_storage.remove(item,passwd)



dump : (passwd)->
  #check usage
  usage = 'passwd string'
  expected = ['string']
  ok = ext._.validateArg(arguments,expected,usage)
  throw new Error(ok) if ok?
  #logic
  storage = localStorage.encryptedStorage
  try
    storage = sjcl.decrypt(passwd, storage)
  catch err
    throw Error err.message
  storage = $.parseJSON storage
  output = []
  $.each storage, (key,val) ->
    output.push key
  output


}
