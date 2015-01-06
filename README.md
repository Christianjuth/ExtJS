
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
notification = {

  #_info is some basic info for ExtJS to read
  _info :
    authors : ['Christian Juth']
    name : 'Notification'
    version : '0.1.0'
    compatibility :
      chrome : 'full'
      safari : 'full'
  
  #_aliases will be defined if element is not taken
  _aliases : ["noti"]
  
  #functions
  basic : (title,content,icon) ->
    if ext.browser is "chrome"
      chrome.notifications.create "", {
        iconUrl : icon
        type: "basic"
        title: title
        message: content
      }, () ->
    else if ext.browser is "safari"
      new Notification(title,{body : content})
      
}

if typeof window.define is 'function' && window.define.amd
  window.define ['ext'], ->
    window.ext.notification = notification
```

Url Search Syntax
============
We offer a method of searching URLs very similar to Grunts file syntax.

```coffeescript
#if url contains the word google
"*google*"

#if url contains google or apple
"*(google|apple)*"

#if url does not contain google
"!*google*"

#curently something like this is NOT Valid
#this will not look for a url that contains google
#but not apple rather it will negate the whole
#expression and look for a url that does not contain either
"*(google|!apple)*"
```
