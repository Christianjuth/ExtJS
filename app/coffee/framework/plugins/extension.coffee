extension = {

  _info :
    authors : ['Christian Juth']
    name : 'Extension Utilities'
    version : '0.1.0'
    min : '0.1.0'
    compatibility :
      chrome : 'full'
      safari : 'partial'


  #functions
  run : () ->
    if ext.browser is 'chrome'
      bkPage = chrome.extension.getBackgroundPage()
      bkPage.test = () ->
        alert(window.message)
      bkPage.test()
      delete bkPage.test


  reload : () ->
    if ext.browser is 'chrome'
      chrome.runtime.reload()

    else if ext.browser is 'safari'
      safari.extension.globalPage.contentWindow.reload = () ->
        location.reload()
      safari.extension.globalPage.contentWindow.reload()


  #this function is chrome only!
  update : () ->
    if ext.browser is 'chrome'
      chrome.runtime.requestUpdateCheck()
}

#setup AMD support
if typeof window.define is 'function' && window.define.amd
  window.define ['ext'], ->
    if !extension._info.min? or extension._info.min >= window.ext.version
      window.ext.extension = extension
