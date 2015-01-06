plugin = {

  _info :
    authors : ['Christian Juth']
    name : 'Tabs'
    version : '0.1.0'
    min : '0.1.0'
    compatibility :
      chrome : 'full'
      safari : 'full'


  #functions
  create : (url,target_blank) ->
    if ext.browser is 'chrome' and target_blank
      chrome.tabs.create {
        url: url
        active: true
      }
    else if ext.browser is 'safari' and target_blank
      safari.application.activeBrowserWindow.openTab().url = url

    else
      window.location.href = url


  dump : (callback) ->
    if ext.browser is 'chrome'
      chrome.tabs.query {}, callback

    else if ext.browser is 'safari'
      setTimeout (callback) ->
        tabs = []
        for window in safari.application.browserWindows
          tabs = tabs.concat window.tabs
        callback tabs
      ,0,callback
    return true


  indexOf : (url, callback) ->
    #vars
    tabs = []
    outputTabs = []

    if ext.browser is 'chrome'
      chrome.tabs.query {}, (tabs) ->
        for tab in tabs
          if ext.match.url(tab.url, url) isnt false
            outputTabs.push(tab)
        callback(outputTabs)

    else if ext.browser is 'safari'
      for window in safari.application.browserWindows
        tabs = tabs.concat window.tabs
      for tab in tabs
        #prevent undefined error
        if !tab.url?
        else if ext.match.url(tab.url, url) isnt false
          outputTabs.push(tab)
      callback(outputTabs)
    return url

}

#setup AMD support
if typeof window.define is 'function' && window.define.amd
  window.define ['ext'], ->
    #vars
    name = plugin._info.name
    id = ext.parse.id(name)
    #load plugin if valid
    if !plugin._info.min? or plugin._info.min <= window.ext.version
      window.ext[id] = plugin
    else
      console.error 'Ext plugin (' + name + ') required a minimum of ExtJS v' + plugin._info.min
