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
