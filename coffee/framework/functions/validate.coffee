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
