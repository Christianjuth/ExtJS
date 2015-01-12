validate :

  url : (url) ->
    ext.match.url url, '*{://,www.,://www.,}*.**'


  email : (email) ->
    ext.match.text email, '*@*.*', { allowSpaces : false }


  password : (passwd,options) ->
    #default options
    defultOptions  = {
      maxLength : '12',
      minLength : 5,
      require : ''
    }
    #These constraints will be forces based on the
    #nature of this function
    force = {
      allowSpaces : false,
      ignorecase : false
    }
    #vars
    options = $.extend defultOptions, options
    #logic
    ext.match.text passwd, '*', $.extend options, force
