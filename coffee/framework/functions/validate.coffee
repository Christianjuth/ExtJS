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
