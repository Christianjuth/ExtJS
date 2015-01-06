plugin = {

}

#setup AMD support
if typeof window.define is 'function' && window.define.amd
  window.define ['ext'], ->
    #vars
    name = plugin._info.name
    id = ext.parse.id(name)
    #load plugin if valid
    if !plugin._info.min? or plugin._info.min <= window.ext.version
      window.ext[id] = plugin
    else
      console.error 'Ext plugin (' + name + ') required a minimum of ExtJS v' + plugin._info.min
