window.ext.extension = {
  run : () ->
    if ext.browser is "chrome"
      bkPage = chrome.extension.getBackgroundPage()
      bkPage.test = () ->
        alert(window.message)
      bkPage.test()
      delete bkPage.test

  reload : () ->
    if ext.browser is "chrome"
      chrome.runtime.reload()

    if ext.browser is "safari"
      safari.extension.globalPage.contentWindow.reload = () ->
        location.reload()
      safari.extension.globalPage.contentWindow.reload()


  #this function is chrome only!
  update : () ->
    if ext.browser is "chrome"
      chrome.runtime.requestUpdateCheck()
}
