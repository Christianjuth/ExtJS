###!
Copyright 2015 by Christian Juth

ExtJS v0.1.0
-------------------------------------------------------------
This is a framework for building Chrome and Safari extensions
###

#set default options
defultOptions = {
  silent : false
}

#define local framework object
ext = {

#set vars
browser : ''
version : '0.1.0'

#functions
ini : (userOptions) ->
  #set vars
  options = $.extend defultOptions, userOptions
  this.browser = this.getBrowser()

  #define global options
  window.ext._config = userOptions

  #set required storage items
  if !localStorage.options? and this.browser is 'chrome'
    localStorage.options = JSON.stringify({})

  #check plugins for _ APIs
  $.each ext, (item) ->
    #set vars
    item = window.ext[item]
    if item._info?
      name = item._info.name
    else
      name = item

    #call load function
    if item._load?
      item._load(userOptions)
      delete item._load

    #check if aliases exsist
    if item._aliases?
      #set aliases
      for alias in item._aliases
        if !window.ext[alias]?
          window.ext[alias] = item

        #alias warning
        else if options.silent isnt true
          console.warn 'Ext plugin "' + name + '" can not define alias "' + alias + '" becuase it is taken'
      delete item._aliases

    #check compatibility
    if item._info? and options.silent isnt true
      compatibility = item._info.compatibility
      #chrome compatibility
      if compatibility.chrome is 'none'
        console.warn 'Ext plugin "' + name + '" is Safari only'
      else if compatibility.chrome isnt 'full'
        console.warn 'Ext plugin "' + name + '" may contain some Safari only functions'

      #safari compatibility
      if compatibility.safari is 'none'
        console.warn 'Ext plugin "' + name + '" is Chrome only'
      else if compatibility.safari isnt 'full'
        console.warn 'Ext plugin "' + name + '" may contain some Chrome only functions'

    delete item._info
  return window.ext


getBrowser : ->
  #vars
  userAgent = navigator.userAgent
  vendor =  navigator.vendor

  #check browser
  if /Chrome/.test(userAgent) and /Google Inc/.test(vendor)
    browser = 'chrome'
  else if /Safari/.test(userAgent) and /Apple Computer/.test(vendor)
    browser = 'safari'
  else if /OPR/.test(userAgent) and /Opera Software/.test(vendor)
    browser = 'chrome'
  return browser



options :

  _aliases : ['ops', 'opts']

  _load : ->
    if ext.browser is 'chrome'
      $.ajax {
      url: '../../configure.json',
      dataType: 'json',
      async: false,
      success: (data) ->
        for option in data.options
          if typeof ext.options.get(option.key) is 'undefined'
            ext.options.set(option.key, option.default)
      }

  #functions
  set : (key, value) ->
    if ext.browser is 'chrome'
      options = $.parseJSON localStorage.options
      options[key] = value
      localStorage.options = JSON.stringify options
    else if ext.browser is 'safari'
      safari.extension.settings[key] = value
    return options[key]

  get : (key) ->
    if ext.browser is 'chrome'
      options = $.parseJSON localStorage.options
      requestedOption = options[key]
    else if ext.browser is 'safari'
      requestedOption = safari.extension.settings[key]
    return requestedOption

  reset : (key) ->
    if ext.browser is 'chrome'
      options = $.parseJSON localStorage.options
      $.ajax({
        url: '../../configure.json',
        dataType: 'json',
        async: false,
        success: (data) ->
          options[key] = _.filter(data.options, {'key' : key})[0].default
          localStorage.options = JSON.stringify options
      })
      optionReset = options[key]
    else if ext.browser is 'safari'
      optionReset = safari.extension.settings.removeItem(key)
    return optionReset

  resetAll : (exceptions) ->
    $.ajax({
      url: '../../configure.json',
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
      if ext.browser is 'chrome'
        icon = {path: chrome.extension.getURL('assets/icons/' + url)}
        chrome.browserAction.setIcon(icon)
      else if ext.browser is 'safari'
        iconUrl = safari.extension.baseURI + 'icons/' + url
        safari.extension.toolbarItems[0].image = iconUrl

    click: (callback) ->
      if ext.browser is 'chrome'
        chrome.browserAction.onClicked.addListener -> callback()
      else if ext.browser is 'safari'
        safari.application.addEventListener('command', (event) ->
          if event.command is 'icon-clicked'
            callback()
        , false)

    setBadge: (number) ->
      number = parseInt number
      if ext.browser is 'chrome'
        number = '' if number is 0
        chrome.browserAction.setBadgeText({text:String number})
        chrome.browserAction.setBadgeBackgroundColor({color:'#8E8E91'})
      else if ext.browser is 'safari'
        safari.extension.toolbarItems[0].badge = number
      number = 0 if number is ''
      return number

    getBadge: (callback) ->
      if ext.browser is 'chrome'
        return chrome.browserAction.getBadgeText({},callback)


match :
  url : (url,urlSearchSyntax) ->
    #vars
    test = urlSearchSyntax
    output = false
    #check if expression is negated
    negate = /^\!/.test(test)
    #these charactes will be reset
    regexEscChars = '
      \\(
      \\)
      \\|
      \\.
      \\/
      \\^
      \\+
      \\[
      \\]
      \\-
      \\!
    '
    #if these chracters have "$" in from of them
    #is will be removed at the end of the function
    escChars = '
      {
      ,
      }
    '

    #replace remove "!" after negate variable is defined
    test = test.replace(/^\!/g,'')

    #reset normal regex characters defined in regexEscChars
    regexEscChars = regexEscChars.replace(/\ /g, '|')
    regexEscChars = new RegExp('(?=(' + regexEscChars + '))' , 'g')
    test = test.replace(regexEscChars,'\\')

    #isolate escaped escape
    test = test.replace(/\$\$/g,'(\\$)')

    #match "?" with anything but "/"
    test = test.replace(/\?/g,'[^/]')

    #replace "*" but not "**" with "([^/]+)*"
    test = test.replace /(\*|\$)?\*/g, ($0, $1) ->
      if $1 then $0 else "([^/]+)*"

    #replace "**" with ".*?"
    test = test.replace(/\*\*/g,'.*?')

    #replace "$*" with "\*"
    test = test.replace(/\$\*/g,'\\*')

    #replace "{ | }" with "( | )"
    test = test.replace /(\$)?{/g, ($0, $1) ->
      if $1 then $0 else "("
    test = test.replace /(\$)?}/g, ($0, $1) ->
      if $1 then $0 else ")"
    test = test.replace /(\$)?,/g, ($0, $1) ->
      if $1 then $0 else "|"

    #remove "$" from character in escChars
    escChars = escChars.replace(/\ /g, '|')
    escChars = new RegExp('\\$(?=(' + escChars + '))' , 'g')
    test = test.replace(escChars,'')

    #parse as regex expression
    test = new RegExp('^(' + test + ')$', 'g')

    #test the url against regex expression
    if negate
      output = ! test.test url.replace(/\ /i, '')
    else
      output = test.test url.replace(/\ /i, '')

    return output


parse :
  array : () ->
    #vars
    output = []
    array = arguments
    #parse array
    for item in array
      if typeof item is "string"
        output.push item
      else
        output = output.concat item
    return output

  #This function will make the input text all
  #lowercase and replace spaces with "_". This
  #can be useful for tasks where spaces are not.
  #allowed
  id : (id) ->
    id.toLowerCase().replace(/\ /g,"_")

}


#These functions below are defined global
#on the page and are part of the window
#object

#This function will combine alike elements of an
#array. If you have "[1,1,2,2,3,3]" it will output
#"[1,2,3]"
Array.prototype.compress = ->
  #vars
  array = this
  output = []
  #logic
  $.each array, (i, e) ->
    if $.inArray(e, output) is -1
      output.push(e)
  return output

#This function simply remove spaces from a string.
String.prototype.compress = ->
  return this.replace(/\ /,'')



#Defing a global copy of the library.
#This is important because this is where
#ExtJS becomes accecable to the user in
#the window object
window.ext = ext

#This function defines the "ext" AMD module.
#Without this ExtJS would not be compatable
#with things like requirejs.
if typeof window.define is 'function' && window.define.amd
  window.define 'ext', ['jquery'], -> window.ext
