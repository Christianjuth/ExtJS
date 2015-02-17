PLUGIN = {



_: {

#INFO
authors : ['Christian Juth']
name : 'Utilities'
version : '0.1.0'
libMin : '0.1.0'
background:  false
compatibility :
  chrome : 'full'
  safari : 'partial'

}



#FUNCTIONS
run : () ->
  if BROWSER is 'chrome'
    bkPage = chrome.extension.getBackgroundPage()
    bkPage.test = () ->
      alert(window.message)
    bkPage.test()
    delete bkPage.test



reload : () ->
  if BROWSER is 'chrome'
    chrome.runtime.reload()
  else if BROWSER is 'safari'
    safari.extension.globalPage.contentWindow.reload = () ->
      window.console.clear()
      location.reload()
    safari.extension.globalPage.contentWindow.reload()



#this function is chrome only!
update : () ->
  if BROWSER is 'chrome'
    chrome.runtime.requestUpdateCheck()



}
