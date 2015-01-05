#----------------------------------------------------------------
# ExtJS
# v0.1.0
#
# ExtJS is a framework for building Chrome and Safari extensions
#----------------------------------------------------------------

#set default options
defultOptions = {
  silent : false
}

#define local framework object
ext =
  #set vars
  browser : ''


  #functions
  ini : (userOptions) ->
    #set vars
    options = $.extend defultOptions, userOptions
    this.browser = this.getBrowser()

    #set required storage items
    if !localStorage.options? and this.browser is 'chrome'
      localStorage.options = JSON.stringify({})

    #check plugins for _ APIs
    $.each ext, (item) ->
      if window.ext[item]['_info']?
        #set vars
        item = window.ext[item]
        name = item._info.name
        compatibility = item._info.compatibility

        #call load function
        if item._load?
          item._load()
          delete item._load

        #check if aliases exsist
        if item._aliases?
          #set aliases
          for alias in item._aliases
            if !window.ext[alias]?
              window.ext[alias] = window.ext[item]

            #alias warning
            else if options.silent isnt true
              console.warn 'Ext plugin "' + name + '" can not define alias "' + alias + '" becuase it is taken'
          delete item._aliases

        #check compatibility
        if item._info? and options.silent isnt true
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

    url : (urls,test) ->
      #vars
      output
      #logic
      negate = test.indexOf("!") != -1
      test = test.replace(/\?/g,'.')
      test = test.replace(/\*/g,'.*?')
      test = test.replace(/\!/g,'')
      test = test.replace(/\./g,'\.')
      test = test.replace(/\//g,'\\/')

      #parse regex
      test = new RegExp('^(' + test + ')$', 'g')
      if negate
        output = ! test.test urls.replace(/\ /g, '')
      else
        output = test.test urls.replace(/\ /g, '')

      return output


    id : (id) ->
      id.toLowerCase().replace(/\ /g,"_")

#global functions
Array.prototype.compress = ->
  #vars
  array = this
  output = []
  #logic
  $.each array, (i, e) ->
    if $.inArray(e, output) is -1
      output.push(e)
  return output

#expose globally
window.ext = ext
window.extJS = ext

#setup AMD support
if typeof window.define is 'function' && window.define.amd
  window.define 'ext', ['jquery'], -> window.ext
