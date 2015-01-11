#set default options
defultOptions = {
  silent : false
}

#top of extjs object container
ext = {

#set vars
browser : ''
version : '0.1.0'

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

#functions
ini : (options) ->
  #set vars
  options = $.extend defultOptions, options
  this.browser = this.getBrowser()

  #define global options
  window.ext._config = options

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
      item._load(options)
      delete item._load

    #check if aliases exists
    if item._aliases?
      #set aliases
      for alias in item._aliases
        if !window.ext[alias]?
          window.ext[alias] = item

        #alias warning
        else if options.silent isnt true
          msg = 'Ext plugin "'+name+'" can\'t define alias "'+alias+'"'
          console.warn msg

      delete item._aliases

    #check compatibility
    if item._info? and options.silent isnt true
      compatibility = item._info.compatibility
      #chrome compatibility
      if compatibility.chrome is 'none'
        console.warn 'Ext plugin "' + name + '" is Safari only'
      else if compatibility.chrome isnt 'full'
        msg = 'Ext plugin "' + name + '" may contain some Safari only functions'
        console.warn msg

      #safari compatibility
      if compatibility.safari is 'none'
        console.warn 'Ext plugin "' + name + '" is Chrome only'
      else if compatibility.safari isnt 'full'
        msg = 'Ext plugin "' + name + '" may contain some Chrome only functions'
        console.warn msg

    delete item._info
  return window.ext

#This is a group of functions that will
#search strings using a defined syntax.
#This works by compiling down to regex.
#By adding this extra layer it becomes
#less confusing to the user while still
#retaining all the power of regex.

match :

  url : (url,urlSearchSyntax,options) ->
    defultOptions  = {
      maxLength : '*',
      minLength : 0,
      ignorecase : true
    }
    #vars
    test = urlSearchSyntax
    output = false
    options = $.extend defultOptions, options
    url = url.replace(/\%20/i, ' ')
    #check if expression is negated
    negate = /^\!/.test(test)
    #these characters will be escaped
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
    #if these characters have "$" in from of them
    #is will be removed at the end of the function
    escChars = '
      {
      ,
      }
      //?
    '
    #remove "!" after negate variable is defined
    test = test.replace(/^\!/g,'')

    #normal regex characters defined in regexEscChars
    regexEscChars = regexEscChars.replace(/\ /g, '|')
    regexEscChars = new RegExp('(?=(' + regexEscChars + '))' , 'g')
    test = test.replace(regexEscChars,'\\')

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
      output = ! test.test url
    else
      output = test.test url

    if options.maxLength isnt '*'
      output = output and text.length <= options.maxLength

    output = output and text.length >= options.minLength

    output = output and output.contains(options.require)

    return output




  text : (text,textSearchSyntax, options) ->
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
    #these characters will be escaped
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
    #if these characters have "$" in from of them
    #is will be removed at the end of the function
    escChars = '
      {
      ,
      }
      //?
    '
    #remove "!" after negate variable is defined
    test = test.replace(/^\!/g,'')

    #normal regex characters defined in regexEscChars
    regexEscChars = regexEscChars.replace(/\ /g, '|')
    regexEscChars = new RegExp('(?=(' + regexEscChars + '))' , 'g')
    test = test.replace(regexEscChars,'\\')

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
      output = ! test.test text
    else
      output = test.test text

    #options
    if !options.allowSpaces
      output = output and -1 is text.indexOf(" ")

    if options.maxLength isnt '*'
      output = output and text.length <= options.maxLength

    output = output and text.length >= options.minLength

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
    #vars
    icon
    #logic
    if ext.browser is 'chrome'
      icon = {path: chrome.extension.getURL('menu-icons/' + url + '-16.png')}
      chrome.browserAction.setIcon(icon)
    else if ext.browser is 'safari'
      iconUrl = safari.extension.baseURI + 'menu-icons/' + url + '-19.png'
      safari.extension.toolbarItems[0].image = iconUrl
    return icon


  #This function will reset the menu icon to
  #the default img.
  resetIcon : ->
    #vars
    icon
    #logic
    if ext.browser is 'chrome'
      icon = {path: chrome.extension.getURL('menu-icons/icon-16.png')}
      chrome.browserAction.setIcon(icon)
    else if ext.browser is 'safari'
      iconUrl = safari.extension.baseURI + 'menu-icons/icon-19.png'
      safari.extension.toolbarItems[0].image = iconUrl
    return icon


  #This function creates a callback triggered when
  #the user clicks on the menu icon. Currently there
  #is no way to unbind this function so this should
  #called once in your code.
  click: (callback) ->
    if ext.browser is 'chrome'
      chrome.browserAction.onClicked.addListener -> callback()
    else if ext.browser is 'safari'
      safari.application.addEventListener('command', (event) ->
        if event.command is 'icon-clicked'
          callback()
      , false)


  #Set the menu icon badge. This function only lets
  #you set a integer value because it is a limitation
  #of Safari.
  setBadge: (number) ->
    #vars
    number = parseInt number
    #logic
    if ext.browser is 'chrome'
      number = '' if number is 0
      chrome.browserAction.setBadgeText({text:String number})
      chrome.browserAction.setBadgeBackgroundColor({color:'#8E8E91'})
    else if ext.browser is 'safari'
      safari.extension.toolbarItems[0].badge = number
    number = 0 if number is ''
    return number


  #This function will get the current value of the icon
  #badge.
  getBadge: (callback) ->
    #vars
    output
    #logic
    if ext.browser is 'chrome'
      output = chrome.browserAction.getBadgeText({},callback)
    if ext.browser is 'safari'
      output = safari.extension.toolbarItems[0].badge
    return output

#This is a group of functions that allow you to
#create options that the user can change.  What sets
#this apart from the Storage plugin is it is only
#for storing data the user can update.  This group
#of function will allow you to set, get, reset, and
#dump all the options.

options :

  #These are some simple aliases I have defined to
  #help keep things short and tidy.
  _aliases : ['ops', 'opts']


  #This function will set up undefined options when
  #the library is loaded.
  _load : ->
    if ext.browser is 'chrome'
      $.ajax {
      url: chrome.extension.getURL 'configure.json'
      dataType: 'json',
      async: false,
      success: (data) ->
        for option in data.options
          if typeof ext.options.get(option.key) is 'undefined'
            ext.options.set(option.key, option.default)
      }


  #This function will set a storage item.  It pulls
  #the value of localStorage.options, parses them as
  #a object, sets the option based on the key you
  #input, and last updates localStorage.options.
  set : (key, value) ->
    if ext.browser is 'chrome'
      options = $.parseJSON localStorage.options
      options[key] = value
      localStorage.options = JSON.stringify options
    else if ext.browser is 'safari'
      safari.extension.settings[key] = value
    return options[key]


  #This function will gram localStorage.options, parse
  #it as a object, retrieve the value of the key you
  #requested, and return the value.
  get : (key) ->
    if ext.browser is 'chrome'
      options = $.parseJSON localStorage.options
      requestedOption = options[key]
    else if ext.browser is 'safari'
      requestedOption = safari.extension.settings[key]
    return requestedOption


  #This function wil grab localStorage.options, parse
  #it as a object, delete the key you input, and update
  #localStorage.options with the object
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



parse :

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
    id.toLowerCase().replace(/\ /g,"_")

validate :

  url : (url) ->
    ext.match.url url, '*{://,www.,://www.,}*.**'


  email : (email) ->
    ext.match.text email, '*@*.*', { allowSpaces : false }


  password : (passwd,options) ->
    #default options
    defultOptions  = {
      allowSpaces : false,
      maxLength : '12',
      minLength : 5,
      ignorecase : false,
      require : ''
    }
    #vars
    options = $.extend defultOptions, options
    #logic
    ext.match.text passwd, '*', options

}
#bottom of extjs object container

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






String.prototype.contains = (textSearchSyntax) ->
  #vars
  test = textSearchSyntax
  output = false
  #check if expression is negated
  negate = /^\!/.test(test)
  #these characters will be escaped
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
  #if these characters have "$" in from of them
  #is will be removed at the end of the function
  escChars = '
    {
    ,
    }
    //?
  '
  #remove "!" after negate variable is defined
  test = test.replace(/^\!/g,'')

  #normal regex characters defined in regexEscChars
  regexEscChars = regexEscChars.replace(/\ /g, '|')
  regexEscChars = new RegExp('(?=(' + regexEscChars + '))' , 'g')
  test = test.replace(regexEscChars,'\\')

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

#Define a global copy of the library.
#This is important because this is where
#ExtJS becomes accessible to the user in
#the window object
window.ext = ext

#This function defines the "ext" AMD module.
#Without this ExtJS would not be compatible
#with things like requirejs.
if typeof window.define is 'function' && window.define.amd
  window.define 'ext', ['jquery'], -> window.ext
