#functions/chrome.coffee
chrome : (callback) ->
  #check usage
  usage = 'callback function'
  ok = ext._.validateArg(arguments, ['function'], usage)
  throw new Error(ok) if ok?
  #logic
  if ext._.browser is 'chrome'
    callback()
