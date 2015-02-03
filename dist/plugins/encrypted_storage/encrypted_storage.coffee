###!
The MIT License (MIT)

Copyright (c) 2014 Christian Juth

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
###

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
  usage = 'key string, passwd string, value string'
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

encryptedStorage = []

###
From the ExtJS team
-------------------
The code below was designed by the ExtJS team to providing useful info to the
developers. We ask you do not change this code unless necessary. By keeping
this standard on all plugins, we hope to make development easy by providing
useful info to developers.  In addition to logging, the code below also
contains the AMD function for defining the plugin.  This waits for the ExtJS
AMD module to define the library itself, and then your plugin is defined
which prevents any undefined errors.  Although not suggested, plugins can be
loaded before the ExtJS library.  The functionality below assures ease of
use.

https://github.com/Christianjuth/extension_framework/tree/plugin
###
BROWSER = ''
NAME = PLUGIN._.name
ID = NAME.toLowerCase().replace(/\ /g,"_")
#console logging
log = {
  error: (msg)-> do->
    msg = 'Ext plugin ('+NAME+') says: '+msg
    ext._.log.error msg

  warn: (msg)-> do->
    msg = 'Ext plugin ('+NAME+') says: '+msg
    ext._.log.warn msg

  info: (msg)-> do->
    msg = 'Ext plugin ('+NAME+') says: '+msg
    ext._.log.info msg
  }
#setup AMD support if browser supports the AMD define function
if typeof window.define is 'function' && window.define.amd
  window.define ['ext'], (ext)->
    BROWSER = ext._.browser
    #load ExtJS meets VERSION requirements
    if !PLUGIN._.min? or PLUGIN._.min <= window.ext._.version
      ext._.load(ID,PLUGIN)
    else
      VERSION = PLUGIN._.min
      console.error 'Ext plugin ('+NAME+') requires ExtJS v'+VERSION+'+'
