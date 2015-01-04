window.ext.notification = {

  _info :
    authors : ['Christian Juth']
    name : 'Notification'
    version : '0.1.0'
    compatibility :
      chrome : 'full'
      safari : 'full'

  _aliases : ["noti"]


  #functions
  basic : (title,content,icon) ->
    if ext.browser is "chrome"
      chrome.notifications.create "", {
        iconUrl : icon
        type: "basic"
        title:title
        message: content
      }, () ->

    else if ext.browser is "safari"
      new Notification(title,{body : content})

}
