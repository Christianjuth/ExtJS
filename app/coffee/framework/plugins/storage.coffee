###!
Licence - 2015
--------------------------------
This plugin is protected by the MIT licence and is open source.
I ask you do not remove and/or modify this copyright in any way.
This plugin is built separately from the ExtJS framework/library
and therefor falls under its own licence (MIT).  ExtJS and other
contributors can not claim ownership.  All contributors agree their
work is open source and falls under this plugins licence (MIT).

https://github.com/Christianjuth/
###

plugin = {

  _info :
    authors : ['Christian Juth']
    name : 'Storage'
    version : '0.1.0'
    min : '0.1.0'
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
        for item in data.storage
          if typeof ext.storage.get(item.key) is 'undefined'
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


###
From the ExtJS team
-------------------
The code below was designed by the ExtJS team to provide useful info to the
developers. We ask you do not change this code unless necessary. By keeping
this standard on all plugins, we hope to make development easy by providing
useful info to developers.  In addition to logging, the code below also
contains the AMD function for defining the plugin.  This waits for the ExtJS
AMD module to define the library itself, and then your plugin is defined
which prevents any undefined errors.  Although not suggested, plugins can be
loaded before the ExtJS library.  The functionality below assures ease of
use. We also ask you keep this code up to date with any changes that may
occur in the future.  Please refer to the sample plugin on the GitHub repo
where this code is updated.

https://github.com/Christianjuth/extension_framework/tree/plugin
###
name = plugin._info.name
id = ext.parse.id(name)
#console logging
log = {
  error : (msg) -> console.error 'Ext plugin (' + name + ') says: ' + msg
  warn : (msg) -> console.warn 'Ext plugin (' + name + ') says: ' + msg
  info : (msg) -> console.warn 'Ext plugin (' + name + ') says: ' + msg
}
#setup AMD support if browser supports the AMD define function
if typeof window.define is 'function' && window.define.amd
  window.define ['ext'], ->
    #load ExtJS meets version requirements
    if !plugin._info.min? or plugin._info.min <= window.ext.version
      window.ext[id] = plugin
    else
      console.error 'Ext plugin ('+name+') requires ExtJS v'+plugin._info.min+'+'
