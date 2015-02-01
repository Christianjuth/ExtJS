PLUGIN = {



#define plugin info object
_: {

#INFO
authors : ['Christian Juth']
name : 'Notification'
aliases : ['noti']
version : '0.1.0'
min : '0.1.0'
compatibility :
  chrome : 'full'
  safari : 'full'
github : ''

}



#FUNCTIONS
basic : (title,message) ->
  #check usage
  usage = 'title string, message string'
  expected = ['string','string']
  ok = ext._.validateArg(arguments,expected,usage)
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
  usage = 'key string, passwd string, value string'
  expected = ['string','string','string']
  ok = ext._.validateArg(arguments,expected,usage)
  #
  if 50000 < parseInt milliseconds
    throw new Error 'timeout too long'
  setTimeout ->
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
