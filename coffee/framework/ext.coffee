ext =

  #vars
  browser : ""

  #functions
  ini : () ->
    this.browser = this.getBrowser()
    if typeof localStorage.options is "undefined" and this.browser is "chrome"
      localStorage.options = JSON.stringify({})

    if typeof localStorage.ext is "undefined"
      localStorage.ext = JSON.stringify({})

    $.each ext, (item) ->
      if typeof window.ext[item]["_load"] isnt "undefined"
        window.ext[item]["_load"]()
        delete window.ext[item]["_load"]

      if typeof window.ext[item]["alias"] isnt "undefined"
        #vars
        alial = window.ext[item]["alias"]

        if typeof window.ext[alial] isnt undefined
          window.ext[alial] = window.ext[item]
          delete window.ext[item]["alias"]






  getBrowser : () ->
      if /Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor)
        browser = "chrome"
      if /OPR/.test(navigator.userAgent) && /Opera Software/.test(navigator.vendor)
        browser = "chrome"
      else if /Safari/.test(navigator.userAgent) && /Apple Computer/.test(navigator.vendor)
        browser = "safari"
      return browser



  options :

    set : (key, value) ->
      if ext.browser is "chrome"
        options = $.parseJSON localStorage.options
        options[key] = value
        localStorage.options = JSON.stringify options
      if ext.browser is "safari"
        safari.extension.settings[key] = value
      return options[key]

    get : (key) ->
      if ext.browser is "chrome"
        options = $.parseJSON localStorage.options
        requestedOption = options[key]
      if ext.browser is "safari"
        requestedOption = safari.extension.settings[key]
      return requestedOption

    reset : (key) ->
      if ext.browser is "chrome"
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
      if ext.browser is "safari"
        optionReset = safari.extension.settings.removeItem(key)
      return optionReset

    resetAll : (exceptions) ->
      $.ajax({
        url: "../../configure.json",
        dataType: 'json',
        async: false,
        success: (data) ->
          for item in data.options
            ext.options.reset(item.key)
      })
      return localStorage.options



  menu :

    icon :

      setIcon : (url) ->
        if ext.browser is "chrome"
          chrome.browserAction.setIcon({path: chrome.extension.getURL("assets/icons/" + url)})
        if ext.browser is "safari"
          iconUrl = safari.extension.baseURI + 'icons/' + url
          safari.extension.toolbarItems[0].image = iconUrl

      click: (callback) ->
        if ext.browser is "chrome"
          chrome.browserAction.onClicked.addListener () ->
            callback()

        if ext.browser is "safari"
          safari.application.addEventListener("command", (event) ->
            if event.command is "icon-clicked"
              callback()
          , false)

      setBadge: (number) ->
        number = parseInt number
        if ext.browser is "chrome"
          number = "" if number is 0
          chrome.browserAction.setBadgeText({text:String number})
          chrome.browserAction.setBadgeBackgroundColor({color:"#8E8E91"})
        if ext.browser is "safari"
          safari.extension.toolbarItems[0].badge = number
        number = 0 if number is ""
        return number

      getBadge: (callback) ->
        if ext.browser is "chrome"
          chrome.browserAction.getBadgeText({},callback)



  regex:
    url: (str,test) ->
      test = test.replace("*",".+")
      test = new RegExp("^" + test + "$", "g")
      test.test str.replace(/\/$/, "")

#expose globally
window.ext = ext

# support AMD
if typeof window.define is "function" && window.define.amd
    window.define "ext", ["jquery"], -> window.ext
