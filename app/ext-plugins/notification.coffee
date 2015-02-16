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
name : 'Notification'
aliases : ['noti']
version : '0.1.0'
libMin : '0.1.0'
background: true
compatibility :
  chrome : 'full'
  safari : 'full'
github : ''

}



#FUNCTIONS
basic : (title,message) ->
  #check usage
  usage = 'title string, msg string'
  expected = ['string','string']
  ok = ext._.validateArg(arguments,expected,usage)
  throw new Error(ok) if ok?
  #logic
  if BROWSER is 'chrome'
    chrome.notifications.create '', {
      iconUrl : chrome.extension.getURL('icon-128.png')
      type: 'basic'
      title:title
      message: message
    }, () ->
  else if BROWSER is 'safari'
    new Notification(title,{body : message})



delay : (title,message,milliseconds) ->
  #check usage
  usage = 'title string, msg string, delay number'
  expected = ['string','string','number']
  ok = ext._.validateArg(arguments,expected,usage)
  throw new Error(ok) if ok?
  #
  if 50000 < parseInt milliseconds
    throw new Error 'timeout too long'
  BACKGROUND.setTimeout ->
    window = BACKGROUND
    if BROWSER is 'chrome'
      chrome.notifications.create '', {
        iconUrl : chrome.extension.getURL('icon-128.png')
        type: 'basic'
        title:title
        message: message
      }, () ->
    else if BROWSER is 'safari'
      new Notification(title,{body : message})
  ,milliseconds



}

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

https://github.com/Christianjuth/ExtJS_Library/tree/plugin
###

#set vars
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
#set background var
if PLUGIN._.background is true
  BACKGROUND = do ->
    if ext._.browser is 'chrome'
      bk = chrome.extension.getBackgroundPage().window
    if ext._.browser is 'safari'
      bk = safari.extension.globalPage.contentWindow
    return bk
#setup AMD support if browser supports the AMD define function
if typeof window.define is 'function' && window.define.amd
  window.define ['ext'], (ext)->
    BROWSER = ext._.browser
    #load ExtJS meets VERSION requirements
    if !PLUGIN._.minLib? or PLUGIN._.minLib <= window.ext._.version
      ext._.load(ID,PLUGIN)
    else
      VERSION = PLUGIN._.min
      console.error 'Ext plugin ('+NAME+') requires ExtJS v'+VERSION+'+'
