#This is a group of functions that will
#search strings using a defined syntax.
#This works by compiling down to regex.
#By adding this extra layer it becomes
#less confusing to the user while still
#retaining all the power of regex.

match :

  url : (url,urlSearchSyntax) ->
    #vars
    test = urlSearchSyntax
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
