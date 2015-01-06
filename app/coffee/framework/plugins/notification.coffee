notification = {

  _info :
    authors : ['Christian Juth']
    name : 'Notification'
    version : '0.1.0'
    min : '0.1.0'
    compatibility :
      chrome : 'full'
      safari : 'full'

  _aliases : ['noti']


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
    if !notification._info.min? or notification._info.min >= window.ext.version
      window.ext.notification = notification
