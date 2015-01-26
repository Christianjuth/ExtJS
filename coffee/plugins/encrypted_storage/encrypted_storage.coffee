plugin = {

#define plugin info object
_info :
  authors : ['Christian Juth']
  name : 'Encrypted Storage'
  version : '0.1.0'
  min : '0.1.0'
  compatibility :
    chrome : 'full'
    safari : 'full'
  github : ''


_aliases : ['enStore','enStorage']


_load : ->
  if !localStorage.encryptedStorage?
    localStorage.encryptedStorage = JSON.stringify({})

  $.ajax {
    url: '../../configure.json',
    dataType: 'json',
    async: false,
    success: (data) ->
      encryptedStorage = data.encryptedStorage
      storage = JSON.parse(localStorage.encryptedStorage)
      for item in data.encryptedStorage
        if typeof storage[item.key] is 'undefined'
          log.info('storage item "'+item.key+'" default password is "password"')
          ext.encrypted_storage.set(item.key, item.default, 'password')
  }


#functions
set : (key, passwd, value) ->
  value = String value
  storage = $.parseJSON localStorage.encryptedStorage
  storage[key] = sjcl.encrypt passwd, value
  localStorage.encryptedStorage = JSON.stringify storage


get : (key, passwd) ->
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
  value = ext.encrypted_storage.get key, Old
  ext.encrypted_storage.set key, value, New


remove : (key) ->
  storage = $.parseJSON localStorage.encryptedStorage
  delete storage[key]
  localStorage.encryptedStorage = JSON.stringify encryptedStorage


removeAll : (exceptions) ->
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
