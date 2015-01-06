plugin = {

  _info :
    authors : ['Christian Juth']
    name : 'Clipboard'
    version : '0.5.0'
    min : '0.1.0'
    compatibility :
      chrome : 'full'
      safari : 'none'

  _aliases : ['clippy']

  write : (text) ->
    #set vars
    input = text
    output = input

    copyFrom = $('<input/>')
    copyFrom.val(input)
    $('body').append(copyFrom)
    copyFrom.select()
    document.execCommand('copy')
    copyFrom.remove()
    output

  read : () ->
    #set vars
    input = ""
    output = ""

    pasteTo = $('<input/>')
    $('body').append(pasteTo)
    pasteTo.select()
    document.execCommand('paste')
    output = pasteTo.val()
    pasteTo.remove()
    output
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
