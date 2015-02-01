_onload : ->

  ext._.options = defultOptions

  $.each ext, (item) ->
    item = ext[item]
    if item._? and item._.aliases?
      for alias in item._.aliases
        ext[alias] = item
    if item._? and item._.onload?
      item._.onload()


  #set required localStorage items
  if !localStorage.options? and ext._.browser is 'chrome'
    localStorage.options = JSON.stringify({})


  #define ext log object
  ext._.log = {}
  #log
  if ext._.options.silent isnt true
    ext._.log.info = do ->
      Function.prototype.bind.call(console.info, console)
    ext._.log.warn = do ->
      Function.prototype.bind.call(console.warn, console)
  else
    ext._.log.info = ->
    ext._.log.warn = ->
  #error
  ext._.log.error = do ->
    Function.prototype.bind.call(console.error, console)
