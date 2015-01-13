plugin = {

#define plugin info object
_info :
  authors : ['Christian Juth']
  name : 'Notification'
  version : '0.1.0'
  min : '0.1.0'
  compatibility :
    chrome : 'full'
    safari : 'full'
  github : ''

#define plugin aliases
_aliases : ['noti']

#functions
basic : (title,message) ->
  if ext.browser is 'chrome'
    chrome.notifications.create '', {
      iconUrl : chrome.extension.getURL('icon-128.png')
      type: 'basic'
      title:title
      message: message
    }, () ->
  else if ext.browser is 'safari'
    new Notification(title,{body : message})

delay : (title,message,milliseconds) ->
  if 50000 < parseInt milliseconds
    log.error 'timeout too long'
  else
    setTimeout ->
      if ext.browser is 'chrome'
        chrome.notifications.create '', {
          iconUrl : chrome.extension.getURL('icon-128.png')
          type: 'basic'
          title:title
          message: message
        }, () ->
      else if ext.browser is 'safari'
        new Notification(title,{body : message})
    ,milliseconds

}
