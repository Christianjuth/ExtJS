menu :
  icon :
    setIcon : (url) ->
      if ext.browser is 'chrome'
        icon = {path: chrome.extension.getURL('assets/icons/' + url)}
        chrome.browserAction.setIcon(icon)
      else if ext.browser is 'safari'
        iconUrl = safari.extension.baseURI + 'icons/' + url
        safari.extension.toolbarItems[0].image = iconUrl

    click: (callback) ->
      if ext.browser is 'chrome'
        chrome.browserAction.onClicked.addListener -> callback()
      else if ext.browser is 'safari'
        safari.application.addEventListener('command', (event) ->
          if event.command is 'icon-clicked'
            callback()
        , false)

    setBadge: (number) ->
      number = parseInt number
      if ext.browser is 'chrome'
        number = '' if number is 0
        chrome.browserAction.setBadgeText({text:String number})
        chrome.browserAction.setBadgeBackgroundColor({color:'#8E8E91'})
      else if ext.browser is 'safari'
        safari.extension.toolbarItems[0].badge = number
      number = 0 if number is ''
      return number

    getBadge: (callback) ->
      if ext.browser is 'chrome'
        return chrome.browserAction.getBadgeText({},callback)
