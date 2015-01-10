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
    #vars
    icon
    #logic
    if ext.browser is 'chrome'
      icon = {path: chrome.extension.getURL('menu-icons/' + url + '-16.png')}
      chrome.browserAction.setIcon(icon)
    else if ext.browser is 'safari'
      iconUrl = safari.extension.baseURI + 'menu-icons/' + url + '-19.png'
      safari.extension.toolbarItems[0].image = iconUrl
    return icon


  #This function will reset the menu icon to
  #the default img.
  resetIcon : ->
    #vars
    icon
    #logic
    if ext.browser is 'chrome'
      icon = {path: chrome.extension.getURL('menu-icons/icon-16.png')}
      chrome.browserAction.setIcon(icon)
    else if ext.browser is 'safari'
      iconUrl = safari.extension.baseURI + 'menu-icons/icon-19.png'
      safari.extension.toolbarItems[0].image = iconUrl
    return icon


  #This function creates a callback triggered when
  #the user clicks on the menu icon. Currently there
  #is no way to unbind this function so this should
  #called once in your code.
  click: (callback) ->
    if ext.browser is 'chrome'
      chrome.browserAction.onClicked.addListener -> callback()
    else if ext.browser is 'safari'
      safari.application.addEventListener('command', (event) ->
        if event.command is 'icon-clicked'
          callback()
      , false)


  #Set the menu icon badge. This function only lets
  #you set a integer value because it is a limitation
  #of Safari.
  setBadge: (number) ->
    #vars
    number = parseInt number
    #logic
    if ext.browser is 'chrome'
      number = '' if number is 0
      chrome.browserAction.setBadgeText({text:String number})
      chrome.browserAction.setBadgeBackgroundColor({color:'#8E8E91'})
    else if ext.browser is 'safari'
      safari.extension.toolbarItems[0].badge = number
    number = 0 if number is ''
    return number


  #This function will get the current value of the icon
  #badge.
  getBadge: (callback) ->
    #vars
    output
    #logic
    if ext.browser is 'chrome'
      output = chrome.browserAction.getBadgeText({},callback)
    if ext.browser is 'safari'
      output = safari.extension.toolbarItems[0].badge
    return output
