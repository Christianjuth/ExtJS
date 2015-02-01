#This is a group of functions that allow you
#to manipulate and get data from your extension's
#toolbar icon. You can make your icon responsive
#and change it based on the weather, the time, etc.
menu :



  #This functions allows you to change the menu
  #icon through javascript. This is good for
  #something like a weather extension where you
  #might update the icon based on the weather.
  setIcon : (url) ->
    #check usage
    usage = 'url string'
    ok = ext._.validateArg(arguments, ['string'], usage)
    throw new Error(ok) if ok?
    #vars
    icon
    #logic
    if ext._.browser is 'chrome'
      icon = {path: chrome.extension.getURL('menu-icons/' + url + '-16.png')}
      chrome.browserAction.setIcon(icon)
    else if ext._.browser is 'safari'
      iconUrl = safari.extension.baseURI + 'menu-icons/' + url + '-19.png'
      safari.extension.toolbarItems[0].image = iconUrl
    return icon



  #This function will reset the menu icon to
  #the default img.
  resetIcon : ->
    #vars
    icons = ext._.getDefaultIcon()
    #logic
    if ext._.browser is 'chrome'
      icon = {path: chrome.extension.getURL(icons['19'])}
      chrome.browserAction.setIcon(icon)
    else if ext._.browser is 'safari'
      iconUrl = safari.extension.baseURI + icons['16']
      safari.extension.toolbarItems[0].image = iconUrl
    return icon



  #This function creates a callback triggered when
  #the user clicks on the menu icon. Currently there
  #is no way to unbind this function so this should
  #called once in your code.
  iconOnClick: (callback) ->
    #check usage
    usage = 'callback function'
    ok = ext._.validateArg(arguments, ['function'], usage)
    throw new Error(ok) if ok?
    #logic
    if !ext._.getConfig().popup?
      throw Error 'can not define menu icon callback if popup is set in config'
    if ext._.browser is 'chrome'
      chrome.browserAction.onClicked.addListener -> callback()
    else if ext._.browser is 'safari'
      safari.application.addEventListener('command', (event) ->
        if event.command is 'icon-clicked'
          callback()
      , false)



  #Set the menu icon badge. This function only lets
  #you set a integer value because it is a limitation
  #of Safari.
  setBadge: (number) ->
    #check usage
    usage = 'number'
    ok = ext._.validateArg(arguments, ['number'], usage)
    throw new Error(ok) if ok?
    #vars
    number = parseInt number
    #logic
    if ext._.browser is 'chrome'
      number = '' if number is 0
      chrome.browserAction.setBadgeText({text:String number})
      chrome.browserAction.setBadgeBackgroundColor({color:'#8E8E91'})
    else if ext._.browser is 'safari'
      safari.extension.toolbarItems[0].badge = number
    number = 0 if number is ''
    return number



  #This function will get the current value of the icon
  #badge.
  getBadge: (callback) ->
    #check usage
    usage = 'callback function'
    ok = ext._.validateArg(arguments, ['function'], usage)
    throw new Error(ok) if ok?
    #vars
    output
    #logic
    if ext._.browser is 'chrome'
      output = chrome.browserAction.getBadgeText({},callback)
    if ext._.browser is 'safari'
      output = safari.extension.toolbarItems[0].badge
    return output
