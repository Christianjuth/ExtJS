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
