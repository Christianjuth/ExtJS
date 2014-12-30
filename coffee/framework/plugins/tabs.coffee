window.ext.tabs = {

    create : (url,target_blank) ->
      if target_blank is true
        if ext.browser is "chrome"
          chrome.tabs.create {
            url: url
            active: true
          }
        if ext.browser is "safari"
          safari.application.activeBrowserWindow.openTab().url = url

      else
        window.location.href = url

    dump : (callback) ->
      if ext.browser is "chrome"
        chrome.tabs.query {}, callback
      if ext.browser is "safari"
        setTimeout (callback) ->
          tabs = []
          for window in safari.application.browserWindows
            tabs = tabs.concat window.tabs
          callback tabs
        ,0,callback
      return true

    indexOf : (url, callback) ->
      if ext.browser is "chrome"
        chrome.tabs.query {}, (tabs) ->
          outputTabs = []
          for tab in tabs
            if ext.regex.url(tab.url, url) isnt false
              outputTabs.push(tab)
          callback(outputTabs)

          return true

      if ext.browser is "safari"
        tabs = []
        outputTabs = []
        for window in safari.application.browserWindows
          tabs = tabs.concat window.tabs
        for tab in tabs
          if typeof tab.url isnt "undefined"
            if ext.regex.url(tab.url, url) isnt false
              outputTabs.push(tab)
        callback(outputTabs)
      return url

}
