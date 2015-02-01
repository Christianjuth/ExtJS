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
