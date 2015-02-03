PLUGIN = {

_: {

#INFO
authors : ['Christian Juth']
name : 'Popup'
version : '0.1.0'
min : '0.1.0'
compatibility :
  chrome : 'full'
  safari : 'full'

}



#FUNCTIONS
setWidth: (width)->
  #check usage
  usage = 'width number'
  expected = ['number']
  ok = ext._.validateArg(arguments,expected,usage)
  throw new Error(ok) if ok?
  validateLocation()
  if BROWSER is 'chrome'
    $('html, body').width(width)
  if BROWSER is 'safari'
    safari.self.width = width



setHeight: (height)->
  #check usage
  usage = 'height number'
  expected = ['number']
  ok = ext._.validateArg(arguments,expected,usage)
  throw new Error(ok) if ok?
  validateLocation()
  if BROWSER is 'chrome'
    $('html, body').height(height)
  if BROWSER is 'safari'
    safari.self.height = height



codeWrap: (callback)->
  #check usage
  usage = 'callback function'
  expected = ['function']
  ok = ext._.validateArg(arguments,expected,usage)
  throw new Error(ok) if ok?
  validateLocation()
  #logic
  if BROWSER is 'chrome'
    callback()
  if BROWSER is 'safari'
    safari.application.addEventListener("popover", callback, true)


}



validateLocation = ->
  #vars
  valid = false
  #validate
  if BROWSER is 'safari'
    details = safari.extension
    if details.popovers[0]?
      popup = safari.extension.popovers[0].contentWindow
      valid = window is popup.window
  if BROWSER is 'chrome'
    details = chrome.app.getDetails()
    if details.browser_action?
      popup = chrome.app.getDetails().browser_action.default_popup
      valid = ext.match.url(location.pathname,'{/,}'+popup)
  if !valid
    throw Error 'ext.popup.codeWrap() must be run from a popup'
