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
