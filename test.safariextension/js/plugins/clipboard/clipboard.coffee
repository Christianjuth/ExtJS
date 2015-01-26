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

###
From the ExtJS team
-------------------
The code below was designed by the ExtJS team to provIDe useful info to the
developers. We ask you do not change this code unless necessary. By keeping
this standard on all plugins, we hope to make development easy by provIDing
useful info to developers.  In addition to logging, the code below also
contains the AMD function for defining the plugin.  This waits for the ExtJS
AMD module to define the library itself, and then your plugin is defined
which prevents any undefined errors.  Although not suggested, plugins can be
loaded before the ExtJS library.  The functionality below assures ease of
use.

https://github.com/Christianjuth/extension_framework/tree/plugin
###
NAME = plugin._info.name
ID = NAME.toLowerCase().replace(/\ /g,"_")
#console logging
log = {
  error: (msg) -> do ->
    ext._log.error 'Ext plugin (' + NAME + ') says: ' + msg

  warm: (msg) -> do ->
    ext._log.warn 'Ext plugin (' + NAME + ') says: ' + msg

  info: (msg) -> do ->
    ext._log.info 'Ext plugin (' + NAME + ') says: ' + msg
  }
#setup AMD support if browser supports the AMD define function
if typeof window.define is 'function' && window.define.amd
  window.define ['ext'], ->
    #load ExtJS meets VERSION requirements
    if !plugin._info.min? or plugin._info.min <= window.ext.version
      window.ext[ID] = plugin
    else
      VERSION = plugin._info.min
      console.error 'Ext plugin (' + NAME + ') requires ExtJS v' + VERSION + '+'
