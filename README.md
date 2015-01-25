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
```
