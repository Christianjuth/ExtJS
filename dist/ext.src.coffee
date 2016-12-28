#options.coffee

#set default options
defultOptions = {
  verbose : true
}

#top of extjs object container
ext = {

#functions/chrome.coffee
chrome : (callback) ->
  #check usage
  usage = 'callback function'
  ok = ext._.validateArg(arguments, ['function'], usage)
  throw new Error(ok) if ok?
  #logic
  if ext._.browser is 'chrome'
    callback()

#functions/ini.coffee

#functions
ini : (options) ->
  #set vars
  options = $.extend defultOptions, options

  #expose options globally
  ext._.options = options

  ext._.onload()

  return window.ext

#functions/internal.coffee

_:

  #VARS
  version: '0.1.0'
  internal: []
  browser: do->
    #vars
    userAgent = navigator.userAgent
    vendor =  navigator.vendor
    #logic
    if /Chrome/.test(userAgent) and /Google Inc/.test(vendor)
      browser = 'chrome'
    else if /Safari/.test(userAgent) and /Apple Computer/.test(vendor)
      browser = 'safari'
    else if /OPR/.test(userAgent) and /Opera Software/.test(vendor)
      browser = 'chrome'
    return browser


  #EVENTS
  onbeforeload: (ext)->
    Keys = Object.keys(ext)
    Keys.splice(Keys.indexOf('_'),1)
    ext._.internal = Keys

     #set required localStorage items
    if !localStorage.options? and ext._.browser is 'chrome'
      localStorage.options = JSON.stringify({})

    ext._.options = defultOptions
    for item in ext._.internal
      if item isnt '_'
        item = ext[item]
        #set aliases
        if item._? and item._.aliases?
          name = item._.name
          for alias in item._.aliases
            if !ext[alias]?
              ext[alias] = item
            else
              msg = 'ExtJS can\'t define alias "'+alias+'"'
              ext._.log.warn msg
        #trigger onload event
        if item._? and item._.onload?
          item._.onload()



  onload: ->
    #define ext log object
    ext._.log = {}
    #log
    if ext._.options.verbose is true
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



  #FUNCTIONS

  #This function allows other functions to validate
  #their paramaters
  validateArg: (args, expected, usage)->
    usage = 'does not match usage function('+usage+')'
    for arg, i in expected
      arg = args[i]
      if expected[i]?
        types = expected[i].split(',')
        valid = false
        for type in types
          if typeof arg is type
            valid = true
            break
        return usage if !valid
    return undefined



  #This function returns the
  getConfig: (callback)->
    #check usage
    usage = 'callback function'
    ok = ext._.validateArg(arguments, ['function,undefined'], usage)
    throw new Error(ok) if ok?
    #set vars
    if callback?
      async = true
    else
      async = false
    #logic
    json = ''
    $.ajax({
      url: '../../configure.json',
      dataType: 'json',
      async: async,
      success: (data) ->
        json = data
        if callback?
          callback(json)
    })
    return json



  getDefaultIcon: ->
    json = ext._.getConfig()
    output = {}
    if !json.menuIcon? or (!json.menuIcon['16']? and !json.menuIcon['19']?)
      throw Error 'no default icons set in configure.json'
    else if !json.menuIcon['19']? and json.menuIcon['16']?
      json.menuIcon['19'] = json.menuIcon['16']
    else if !json.menuIcon['16']? and json.menuIcon['19']?
      json.menuIcon['16'] = json.menuIcon['19']
    output['19'] = json.menuIcon['19']
    output['16'] = json.menuIcon['16']
    return output





  run: (fun)->
    bk = ext._.getBackground()
    fun = fun.bind(fun)
    fun.call(bk.window)



  getBackground: ->
    bk = ''
    if ext._.browser is 'chrome'
      bk = chrome.extension.getBackgroundPage().window
    if ext._.browser is 'safari'
      bk = safari.extension.globalPage.contentWindow
    return bk



  backgroundProxy: (fun)->
    bk = ext._.getBackground()
    bk.ext._.run(fun)




  load: (id,plugin)->
    #check usage
    usage = 'id string, plugin object'
    ok = ext._.validateArg(arguments, ['string','object'], usage)
    throw new Error(ok) if ok?
    if !plugin._?
      ext._.log.error('plugin missing header')
      return false
    #vars
    name = plugin._.name
    bk = ext._.getBackground()

    #load plugin in background page
    if bk.window isnt window and plugin._.background is true
      bk.ext._.load(id,plugin)

    #trigger onbeforeload event
    if plugin._.onbeforeload?
      plugin._.onbeforeload(plugin)
    #expose plugin
    ext[id] = plugin
    #trigger onload event
    if plugin._.onload?
      plugin._.onload(ext._.options)
    #define aliases
    if plugin._.aliases?
      for alias in plugin._.aliases
        if !ext[alias]?
          ext[alias] = ext[id]
        else
          msg = 'Ext plugin "'+name+'" can\'t define alias "'+alias+'"'
          ext._.log.warn msg
    #check compatibility
    if plugin._.compatibility?
      compatibility = plugin._.compatibility
      #chrome compatibility
      if compatibility.chrome is 'none'
        msg = 'Ext plugin "' + name + '" is Safari only'
        ext._.log.warn msg
      else if compatibility.chrome isnt 'full'
        msg = 'Ext plugin "' + name + '" may contain some Safari only functions'
        ext._.log.warn msg

      #safari compatibility
      if compatibility.safari is 'none'
        msg = 'Ext plugin "' + name + '" is Chrome only'
        ext._.log.warn msg
      else if compatibility.safari isnt 'full'
        msg = 'Ext plugin "' + name + '" may contain some Chrome only functions'
        ext._.log.warn msg



  log:
    info: ->
    warn: ->
    error: ->




#functions/match.coffee

#This is a group of functions that will
#search strings using a defined syntax.
#This works by compiling down to regex.
#By adding this extra layer it becomes
#less confusing to the user while still
#retaining all the power of regex.
match :



  #This function if defines a syntax for
  #matching urls. This syntax compiles down
  #to a regex and is used to test the url
  url : (url,urlSearchSyntax,options) ->
    #check usage
    usage = 'url string, urlSearchSyntax, options object'
    ok=ext._.validateArg(arguments,['string','string','object,undefined'],usage)
    throw new Error(ok) if ok?
    #default options
    defultOptions  = {
      maxLength : '*',
      minLength : 0,
      ignorecase : true,
      require : ''
    }
    #vars
    test = urlSearchSyntax
    output = false
    options = $.extend defultOptions, options
    url = url.replace(/\%20/i, ' ')
    #check if expression is negated
    negate = /^\!/.test(test)
    #if these characters have "$" in from of them
    #is will be removed at the end of the function
    escChars = '
      {
      ,
      }
      /?
    '
    #remove "!" after negate variable is defined
    test = test.replace(/^\!/g,'')

    #normal regex characters
    test = ext.parse.normalize(test)

    #isolate escaped "$"
    test = test.replace(/\$\$/g,'(\\$)')

    #match "?" with anything but "/"
    test = test.replace /(\$)?\?/g, ($0, $1) ->
      if $1 then $0 else '[^/]'

    #replace "*" but not "**" with "([^/]+)*"
    test = test.replace /(\*|\$)?\*/g, ($0, $1) ->
      if $1 then $0 else "([^/]+)*"

    #replace "**" with ".*?"
    test = test.replace(/\*\*/g,'.*?')

    #replace "$*" with "\*"
    test = test.replace(/\$\*/g,'\\*')

    #replace "{ | }" with "( | )"
    test = test.replace /(\$)?{/g, ($0, $1) ->
      if $1 then $0 else '('
    test = test.replace /(\$)?}/g, ($0, $1) ->
      if $1 then $0 else ')'
    test = test.replace /(\$)?,/g, ($0, $1) ->
      if $1 then $0 else '|'

    #remove "$" from character in escChars
    escChars = escChars.replace(/\ /g, '|')
    escChars = new RegExp('\\$(?=(' + escChars + '))' , 'g')
    test = test.replace(escChars,'')

    #parse as regex expression
    if options.ignorecase
      test = new RegExp('^(' + test + ')$', 'gi')
    else
      test = new RegExp('^(' + test + ')$', 'g')

    #test the url against regex expression
    if negate
      output = !test.test url
    else
      output = test.test url

    #min and max
    if options.maxLength isnt '*'
      output = output and url.length <= options.maxLength
    output = output and url.length >= options.minLength

    #required characters
    output = output and url.contains(options.require)

    return output




  #This function if defines a syntax for
  #matching text. This syntax compiles down
  #to a regex and is used to test the text
  text : (text,textSearchSyntax, options) ->
    #check usage
    usage = 'url string, textSearchSyntax, options object'
    ok=ext._.validateArg(arguments,['string','string','object,undefined'],usage)
    throw new Error(ok) if ok?
    #default options
    defultOptions  = {
      allowSpaces : true,
      maxLength : '*',
      minLength : 0,
      require : '',
      ignorecase : true
    }
    #vars
    test = textSearchSyntax
    output = false
    options = $.extend defultOptions, options
    #check if expression is negated
    negate = /^\!/.test(test)
    #if these characters have "$" in from of them
    #is will be removed at the end of the function
    escChars = '
      {
      ,
      }
      /?
    '
    #remove "!" after negate variable is defined
    test = test.replace(/^\!/g,'')

    #normal regex characters
    test = ext.parse.normalize(test)

    #isolate escaped "$"
    test = test.replace(/\$\$/g,'(\\$)')

    #match "?" with anything
    test = test.replace /(\$)?\?/g, ($0, $1) ->
      if $1 then $0 else '.'

    #replace "*" with "([^/]+)*"
    test = test.replace /(\$)?\*/g, ($0, $1) ->
      if $1 then $0 else '.*?'

    #replace "$*" with "\*"
    test = test.replace(/\$\*/g,'\\*')

    #replace "{ | }" with "( | )"
    test = test.replace /(\$)?{/g, ($0, $1) ->
      if $1 then $0 else '('
    test = test.replace /(\$)?}/g, ($0, $1) ->
      if $1 then $0 else ')'
    test = test.replace /(\$)?,/g, ($0, $1) ->
      if $1 then $0 else '|'

    #remove "$" from character in escChars
    escChars = escChars.replace(/\ /g, '|')
    escChars = new RegExp('\\$(?=(' + escChars + '))' , 'g')
    test = test.replace(escChars,'')

    #parse as regex expression
    if options.ignorecase
      test = new RegExp('^(' + test + ')$', 'gi')
    else
      test = new RegExp('^(' + test + ')$', 'g')

    #test the text against regex expression
    if negate
      output = !test.test text
    else
      output = test.test text

    #if allow spaceses is false
    if !options.allowSpaces
      output = output and -1 is text.indexOf(" ")

    #min and max
    if options.maxLength isnt '*'
      output = output and text.length <= options.maxLength
    output = output and text.length >= options.minLength

    #required characters
    output = output and text.contains(options.require)

    return output

#This is a group of functions that allow you
#to manipulate and get data from your extension's
#toolbar icon. You can make your icon responsive
#and change it based on the weather, the time, etc.
menu :



  #This functions allows you to change the menu
  #icon through javascript. This is good for
  #something like a weather extension where you
  #might update the icon based on the weather.
  setIcon : (url) ->
    #check usage
    usage = 'url string'
    ok = ext._.validateArg(arguments, ['string'], usage)
    throw new Error(ok) if ok?
    #vars
    icon
    #logic
    if ext._.browser is 'chrome'
      icon = {path: chrome.extension.getURL('menu-icons/' + url + '-16.png')}
      chrome.browserAction.setIcon(icon)
    else if ext._.browser is 'safari'
      iconUrl = safari.extension.baseURI + 'menu-icons/' + url + '-19.png'
      safari.extension.toolbarItems[0].image = iconUrl
    return icon



  #This function will reset the menu icon to
  #the default img.
  resetIcon : ->
    #vars
    icons = ext._.getDefaultIcon()
    #logic
    if ext._.browser is 'chrome'
      icon = {path: chrome.extension.getURL(icons['19'])}
      chrome.browserAction.setIcon(icon)
    else if ext._.browser is 'safari'
      iconUrl = safari.extension.baseURI + icons['16']
      safari.extension.toolbarItems[0].image = iconUrl
    return icon



  #This function creates a callback triggered when
  #the user clicks on the menu icon. Currently there
  #is no way to unbind this function so this should
  #called once in your code.
  iconOnClick: (callback) ->
    #check usage
    usage = 'callback function'
    ok = ext._.validateArg(arguments, ['function'], usage)
    throw new Error(ok) if ok?
    #logic
    if !ext._.getConfig().popup?
      throw Error 'can not define menu icon callback if popup is set in config'
    if ext._.browser is 'chrome'
      chrome.browserAction.onClicked.addListener -> callback()
    else if ext._.browser is 'safari'
      safari.application.addEventListener('command', (event) ->
        if event.command is 'icon-clicked'
          callback()
      , false)



  #Set the menu icon badge. This function only lets
  #you set a integer value because it is a limitation
  #of Safari.
  setBadge: (number) ->
    #check usage
    usage = 'number'
    ok = ext._.validateArg(arguments, ['number'], usage)
    throw new Error(ok) if ok?
    #vars
    number = parseInt number
    #logic
    if ext._.browser is 'chrome'
      number = '' if number is 0
      chrome.browserAction.setBadgeText({text:String number})
      chrome.browserAction.setBadgeBackgroundColor({color:'#8E8E91'})
    else if ext._.browser is 'safari'
      safari.extension.toolbarItems[0].badge = number
    number = 0 if number is ''
    return number



  #This function will get the current value of the icon
  #badge.
  getBadge: (callback) ->
    #check usage
    usage = 'callback function'
    ok = ext._.validateArg(arguments, ['function'], usage)
    throw new Error(ok) if ok?
    #vars
    output
    #logic
    if ext._.browser is 'chrome'
      output = chrome.browserAction.getBadgeText({},callback)
    if ext._.browser is 'safari'
      output = safari.extension.toolbarItems[0].badge
    return output

#functions/options.coffee

#This is a group of functions that allow you to
#create options that the user can change.  What sets
#this apart from the Storage plugin is it is only
#for storing data the user can update.  This group
#of function will allow you to set, get, reset, and
#dump all the options.
options :



  _:{

  #INFO
  aliases: ['ops', 'opts']
  background: true

  #THIS IS A HACK
  #local callback bindings
  changeBindings : []
  bindChange : (callback) ->
    ext.options._.changeBindings.push callback
    console.log ext.options._.changeBindings
    console.log callback
  callChangeBindings : ->
    console.log ext.options._.changeBindings
    for fun in ext.options._.changeBindings
      fun()

  onload : ->
    if ext._.browser is 'chrome'
      data = ext._.getConfig()
      for option in data.options
        if typeof ext.options.get(option.key) is 'undefined'
          ext.options.set(option.key, option.default)


  }



  #FUNCTIONS

  #This function will set a storage item.  It pulls
  #the value of localStorage.options, parses them as
  #a object, sets the option based on the key you
  #input, and last updates localStorage.options.
  set : (key, value) ->
    #check usage
    usage = 'key string, value'
    ok = ext._.validateArg(arguments, [
      'string'
      'string,number,boolean,object'
    ], usage)
    throw new Error(ok) if ok?
    #logic
    if ext._.browser is 'chrome'
      options = $.parseJSON localStorage.options
      options[key] = value
      localStorage.options = JSON.stringify options
      ext.options._.callChangeBindings()
    else if ext._.browser is 'safari'
      safari.extension.settings[key] = value
    return options[key]



  #This function will gram localStorage.options, parse
  #it as a object, retrieve the value of the key you
  #requested, and return the value.
  get : (key) ->
    #check usage
    usage = 'key string'
    ok = ext._.validateArg(arguments, ['string'], usage)
    throw new Error(ok) if ok?
    #logic
    if ext._.browser is 'chrome'
      options = $.parseJSON localStorage.options
      requestedOption = options[key]
    else if ext._.browser is 'safari'
      requestedOption = safari.extension.settings[key]
    return requestedOption



  #This function wil grab localStorage.options, parse
  #it as a object, delete the key you input, and update
  #localStorage.options with the object
  reset : (key) ->
    #check usage
    usage = 'key string'
    ok = ext._.validateArg(arguments, ['string'], usage)
    throw new Error(ok) if ok?
    #logic
    if ext._.browser is 'chrome'
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
    else if ext._.browser is 'safari'
      optionReset = safari.extension.settings.removeItem(key)
    return optionReset



  #This function will find al the defined options in
  #configure.json, get all the keys for those options,
  #and loop through them resetting them to their defaults.
  resetAll : (exceptions) ->
    $.ajax({
      url: '../../configure.json',
      dataType: 'json',
      async: false,
      success: (data) ->
        for item in data.options
          if -1 is exceptions.indexOf item.key
            ext.options.reset(item.key)
    })
    return ext.options.dump()



  #This function will return a array of option keys
  dump : ->
    #vars
    output = []
    #logic
    $.ajax({
      url: '../../configure.json',
      dataType: 'json',
      async: false,
      success: (data) ->
        for item in data.options
          output.push item.key
    })
    return output



  onChange: (callback) ->
    #check usage
    usage = 'callback function'
    ok = ext._.validateArg(arguments, ['function'], usage)
    throw new Error(ok) if ok?
    #logic
    if ext._.browser is 'chrome'
      bk = chrome.extension.getBackgroundPage().window
      bk.$(window).bind 'storage', (e) ->
        if e.originalEvent.key is 'options'
          callback()
      bk.ext.options._.bindChange(callback)
    if ext._.browser is 'safari'
      safari.extension.settings.addEventListener 'change', callback, false




#functions/parse.coffee

#The foloing functions are used to manipulate
#the inputed string/numbers and return the new
#value
parse :


  url: (url) ->
    #check usage
    usage = 'url string'
    ok = ext._.validateArg(arguments, ['string'], usage)
    throw new Error(ok) if ok?
    #logic
    if !ext.validate.url(url)
      throw Error 'Invalid url'
    protical =
      url.indexOf('https://') isnt -1 and
      url.indexOf('https://') isnt -1
    if !protical
      url = 'http://' + url
    return url



  #This function will take an unlimited amount
  #of parameters that are strings, Ints, floats,
  #or arrays. Object will work as well but are
  #not recommended. This function takes all of
  #these parameters and combines them into one
  #array.  This function currently does not
  #support arrays in arrays (or array inception).
  array : ->
    #vars
    output = []
    input = arguments
    #parse array
    for item in input
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
    #check usage
    usage = 'id string'
    ok = ext._.validateArg(arguments, ['string'], usage)
    throw new Error(ok) if ok?
    #logic
    id.toLowerCase().replace(/\ /g,"_")



  #This function will escape most regex special
  #chars from a string. This can be used to
  #nutrilize a string to match or replace the
  #exact value using rexes
  normalize : (text) ->
    #check usage
    usage = 'string'
    ok = ext._.validateArg(arguments, ['string'], usage)
    throw new Error(ok) if ok?
    #logic
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
    #normal regex characters defined in regexEscChars
    regexEscChars = regexEscChars.replace(/\ /g, '|')
    regexEscChars = new RegExp('(?=(' + regexEscChars + '))' , 'g')
    text = text.replace(regexEscChars,'\\')
    return text

#functions/safari.coffee
safari : (callback) ->
  #check usage
  usage = 'callback function'
  ok = ext._.validateArg(arguments, ['function'], usage)
  throw new Error(ok) if ok?
  #logic
  if ext._.browser is 'safari'
    callback()

#functions/validate.coffee

#The folling is a group of functions
#for clent side validation. Please note
#if you are using these to validate data
#for a database or webserver you shold have
#the validation done on that server. The
#end use has the ablility to bypass and
#tamper with this validation.
validate :



  #This function will validate any
  #domain in the folling formats and more
  # * HTTP://DOMAIN.TLD
  # * HTTPs://DOMAIN.TLD
  # * DOMAIN.TLD/SUBDIR
  # * SUB.DOMAIN.TLD/SUBDIR
  url : (url) ->
    #check usage
    usage = 'url string'
    ok = ext._.validateArg(arguments, ['string'], usage)
    throw new Error(ok) if ok?
    #logic
    ext.match.url url, '*{://,www.,://www.,}*.**'



  #This function will look for any
  #https secure domain
  secureUrl : (url) ->
    #check usage
    usage = 'url string'
    ok = ext._.validateArg(arguments, ['string'], usage)
    throw new Error(ok) if ok?
    #logic
    ext.match.url url, 'https://{www.,}*.**'



  #This function will look for a local
  #file url containing "file://"
  file : (path,type) ->
    #check usage
    usage = 'path string, type string'
    ok = ext._.validateArg(arguments, ['string','string'], usage)
    throw new Error(ok) if ok?
    #logic
    if type?
      ext.match.url path, 'file://**.' + type
    else
      ext.match.url path, 'file://**'



  #This function will validate any email
  #address in this format "EXAMPLE@DOMAIN.TLD"
  email : (email) ->
    #check usage
    usage = 'email string'
    ok = ext._.validateArg(arguments, ['string'], usage)
    throw new Error(ok) if ok?
    #logic
    ext.match.text email, '*@*.*', { allowSpaces : false }



  #This function required a little more
  #customisation. You can input a password,
  #required chars, max length, and min legnth.
  #Please not this is client side validation and
  #you should still have the password validated
  #on your webserver for most secure practice.
  password : (passwd,options) ->
    #check usage
    usage = 'passwd string, options object'
    ok = ext._.validateArg(arguments, ['string','object,undefined'], usage)
    throw new Error(ok) if ok?
    #default options
    defultOptions  = {
      maxLength : 12,
      minLength : 5,
      require : ''
    }
    #These constraints will be forces based on the
    #nature of this function
    force = {
      allowSpaces : false,
      ignorecase : false
    }
    #User options overide default options
    options = $.extend defultOptions, options
    #Forced options overide user options
    $.extend options, force
    #logic
    ext.match.text passwd, '*', options

}
#bottom of extjs object container

#global.coffee

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
  return this.replace(/\ /g,'')



#This function is a more advaced method then indexOf
#for searching strings.
String.prototype.contains = (textSearchSyntax) ->
  #vars
  if typeof textSearchSyntax is 'object'
    tests = textSearchSyntax
  else
    tests = []
    tests.push textSearchSyntax
  output = false

  for test in tests
    #check if expression is negated
    negate = /^\!/.test(test)
    #if these characters have "$" in from of them
    #is will be removed at the end of the function
    escChars = '
      {
      ,
      }
      /?
    '
    #remove "!" after negate variable is defined
    test = test.replace(/^\!/g,'')

    #normal regex characters
    test = ext.parse.normalize(test)

    #isolate escaped "$"
    test = test.replace(/\$\$/g,'(\\$)')

    #match "?" with anything
    test = test.replace /(\$)?\?/g, ($0, $1) ->
      if $1 then $0 else '.'

    #replace "*" with "([^/]+)*"
    test = test.replace /(\$)?\*/g, ($0, $1) ->
      if $1 then $0 else '.*?'

    #replace "$*" with "\*"
    test = test.replace(/\$\*/g,'\\*')

    #replace "{ | }" with "( | )"
    test = test.replace /(\$)?{/g, ($0, $1) ->
      if $1 then $0 else '('
    test = test.replace /(\$)?}/g, ($0, $1) ->
      if $1 then $0 else ')'
    test = test.replace /(\$)?,/g, ($0, $1) ->
      if $1 then $0 else '|'

    #remove "$" from character in escChars
    escChars = escChars.replace(/\ /g, '|')
    escChars = new RegExp('\\$(?=(' + escChars + '))' , 'g')
    test = test.replace(escChars,'\\')

    #parse as regex expression
    test = new RegExp('^(.*?' + test + '.*?)$', 'gi')

    #test the text against regex expression
    if negate
      output = ! test.test this
    else
      output = test.test this

  return output

#define.coffee

#Define a global copy of the library.
#This is important because this is where
#ExtJS becomes accessible to the user in
#the window object
window.ext = ext

#This function defines the "ext" AMD module.
#Without this ExtJS would not be compatible
#with things like requirejs.
if typeof window.define is 'function' && window.define.amd
  window.define 'ext', ['jquery'], ->
    ext._.onbeforeload(ext)
    window.ext
    ext._.onload()
    return ext
