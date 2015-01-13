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
  name : 'UUID'
  version : '0.1.0'
  compatibility :
    chrome : 'full'
    safari : 'full'

_aliases : ['UUID']

_load : (options) ->
  if !localStorage.uuid?
    s = []
    hexDigits = '0123456789abcdef'
    i=0
    while i <= 36
      i++
      s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1)
    s[14] = '4'
    s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1)
    s[9] = s[14] = s[19] = s[23] = '-'
    uuid = s.join('');
    #log reset
    if options.silent isnt true
      console.info('UUID "' + uuid + '" was created')
    localStorage.uuid = uuid

#functions
reset : ->
  options = window.ext._config
  s = []
  hexDigits = '0123456789abcdef'
  i=0
  while i <= 36
    i++
    s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1)
  s[14] = '4'
  s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1)
  s[9] = s[14] = s[19] = s[23] = '-'
  uuid = s.join('');
  #log reset
  if options.silent isnt true
    console.info('UUID was reset to "' + uuid + '"')
  localStorage.uuid = uuid

get : ->
  return localStorage.uuid

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
error : (msg) -> console.error 'Ext plugin (' + NAME + ') says: ' + msg
warn : (msg) ->
  if ext._config.silent isnt true
    console.warn 'Ext plugin (' + NAME + ') says: ' + msg
info : (msg) ->
  if ext._config.silent isnt true
    console.log 'Ext plugin (' + NAME + ') says: ' + msg
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
