framework =

  ini : () ->
    this.browser = this.getBrowser()
    if typeof localStorage.options is "undefined" and this.browser is "chrome"
      localStorage.options = JSON.stringify({})

    if typeof localStorage.framework is "undefined"
      localStorage.framework = JSON.stringify({})

  getBrowser : () ->
      if /Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor)
        browser = "chrome"
      if /OPR/.test(navigator.userAgent) && /Opera Software/.test(navigator.vendor)
        browser = "chrome"
      else if /Safari/.test(navigator.userAgent) && /Apple Computer/.test(navigator.vendor)
        browser = "safari"
      return browser






  storage :

    ini : () ->

    set : (key, value) ->
      localStorage[key] = value

    get : (key) ->
      localStorage[key]

    remove : (key) ->
      return localStorage.removeItem(key)

    removeAll : (exceptions) ->
      for item in this.dump()
        this.remove(item) if item isnt "options"

    dump : () ->
      data = new Array()
      for i in localStorage
        if localStorage.key(_i) isnt "options"
          data.push localStorage.key(_i)
      return data





  options :

    ini : () ->

    set : (key, value) ->
      if framework.browser is "chrome"
        options = $.parseJSON localStorage.options
        options[key] = value
        localStorage.options = JSON.stringify options
      if framework.browser is "safari"
        safari.extension.settings[key] = value
      return options[key]

    get : (key) ->
      if framework.browser is "chrome"
        options = $.parseJSON localStorage.options
        requestedOption = options[key]
      if framework.browser is "safari"
        requestedOption = safari.extension.settings[key]
      return requestedOption

    reset : (key) ->
      if framework.browser is "chrome"
        options = $.parseJSON localStorage.options
        $.ajax({
          url: "../../configure.json",
          dataType: 'json',
          async: false,
          success: (data) ->
            options[key] = _.filter(data.options, {'key' : key})[0].default
            localStorage.options = JSON.stringify options
        })
        optionReset = options[key]
      if framework.browser is "safari"
        optionReset = safari.extension.settings.removeItem(key)
      return optionReset

    resetAll : (exceptions) ->
      $.ajax({
        url: "../../configure.json",
        dataType: 'json',
        async: false,
        success: (data) ->
          for item in data.options
            framework.options.reset(item.key)
      })
      return localStorage.options






  tabs :

    ini : () ->

    create : (url,target_blank) ->
      if target_blank is true
        if framework.browser is "chrome"
          chrome.tabs.create {
            url: url
            active: true
          }
        if framework.browser is "safari"
          safari.application.activeBrowserWindow.openTab().url = url

      else
        window.location.href = url

    dump : (callback) ->
      if framework.browser is "chrome"
        chrome.tabs.query {}, callback
      if framework.browser is "safari"
        setTimeout (callback) ->
          tabs = []
          for window in safari.application.browserWindows
            tabs = tabs.concat window.tabs
          callback tabs
        ,0,callback
      return true

    indexOf : (url, callback) ->
      if framework.browser is "chrome"
        chrome.tabs.query {}, (tabs) ->
          outputTabs = []
          for tab in tabs
            if framework.regex.url(tab.url, url) isnt false
              outputTabs.push(tab)
          callback(outputTabs)

          return true

      if framework.browser is "safari"
        tabs = []
        outputTabs = []
        for window in safari.application.browserWindows
          tabs = tabs.concat window.tabs
        for tab in tabs
          if typeof tab.url isnt "undefined"
            if framework.regex.url(tab.url, url) isnt false
              outputTabs.push(tab)
        callback(outputTabs)
      return url



  notification: (title,content,icon) ->
    if framework.browser is "chrome"
      chrome.notifications.create "", {
        iconUrl : icon
        type: "basic"
        title:title
        message: content
      }, () ->

    if framework.browser is "safari"
      new Notification(title,{body : content})



  menu :

    ini : () ->

    icon :

      setIcon : (url) ->
        if framework.browser is "chrome"
          chrome.browserAction.setIcon({path: chrome.extension.getURL("assets/icons/" + url)})
        if framework.browser is "safari"
          iconUrl = safari.extension.baseURI + 'icons/' + url
          safari.extension.toolbarItems[0].image = iconUrl

      click: (callback) ->
        if framework.browser is "chrome"
          chrome.browserAction.onClicked.addListener () ->
            callback()

        if framework.browser is "safari"
          safari.application.addEventListener("command", (event) ->
            if event.command is "icon-clicked"
              callback()
          , false)

      setBadge: (number) ->
        number = parseInt number
        if framework.browser is "chrome"
          number = "" if number is 0
          chrome.browserAction.setBadgeText({text:String number})
          chrome.browserAction.setBadgeBackgroundColor({color:"#8E8E91"})
        if framework.browser is "safari"
          safari.extension.toolbarItems[0].badge = number
        number = 0 if number is ""
        return number

      getBadge: (callback) ->
        if framework.browser is "chrome"
          chrome.browserAction.getBadgeText({},callback)


  regex:
    url: (str,test) ->
      test = test.replace("*",".+")
      test = new RegExp("^" + test + "$", "g")
      test.test str.replace(/\/$/, "")


define () ->
  return framework

#define global storage variable
if typeof window is "object" and typeof window.document is "object"
  window.framework = framework
