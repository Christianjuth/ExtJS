
-This framework is still in the early stages-

Extension Framework
============
Build for one. Build for all. **Chrome, Safari, and Opera** extension in one.  We worry about **cross browser compatibility** so you do not have to.

Why use a framework?
============
In addition to **cross browser support** you also get a file **structure** to out of the box keeping your work **clean** and the the **transition** between your projects easy.


How does it work?
=============
You write code in **Coffeescript**, **LESS**, and **HTMl** and it compiles down to **Javascript**, **CSS**, and **html**.  All the building is handled by **Gruntjs**.

Plugins
=============
We know we can not do everything so we leave what we missed up to you. Creating **plugins** for ExtJS is as easy as defining a JSON element.

```coffeescript
#define local copy of plugin
plugin = {

  #_info is some basic info for ExtJS to read
  _info :
    authors : ['Christian Juth']
    name : 'Notification'
    version : '0.1.0'
    min : '0.1.0'
    compatibility :
      chrome : 'full'
      safari : 'full'

  #_aliases will be defined if ext.noti is not in use
  _aliases : ["noti"]

  #functions
  basic : (title,content) ->
    if ext.browser is 'chrome'
      chrome.notifications.create '', {
        iconUrl : chrome.extension.getURL('icon-128.png')
        type: 'basic'
        title:title
        message: content
      }, () ->
    else if ext.browser is 'safari'
      new Notification(title,{body : content})

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
```

Url Search Syntax
============
We offer a method of searching URLs very similar to Grunts file syntax.

* `*`  Matches zero or more characters but not `/`
* `?`  Matches one character but not `/`
* `**` Matches all characters including `/`
* `{}` Allows for a comma-separated list of "or" expressions
* `!`  At the beginning of a pattern will negate the match

```coffeescript
#if url is google.com or google.co.uk but not google.com/fonts
"**google.*"

#if url contains the word google
"**google**"

#if url contains google, apple, or microsoft
"**{google,apple,microsoft}**"

#or inception
"{cake,apple{pie,tart}}"

#if url does not contain google
"!**google**"

#! must come at the beginning of the
#statement or it will be taken literally
"x!y" #url is x!y
"!xy" #url is not xy
```
