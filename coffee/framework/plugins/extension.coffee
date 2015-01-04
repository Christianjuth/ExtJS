window.ext.extension = {

  _info :
    authors : ['Christian Juth']
    name : 'Extension Utilities'
    version : '0.1.0'
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

    if ext.browser is 'safari'
      safari.extension.globalPage.contentWindow.reload = () ->
        location.reload()
      safari.extension.globalPage.contentWindow.reload()


  #this function is chrome only!
  update : () ->
    if ext.browser is 'chrome'
      chrome.runtime.requestUpdateCheck()
}