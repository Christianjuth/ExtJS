defineLog = ->
  #define ext log object
  ext._log = {}
  #log
  if ext._config.silent isnt true
    ext._log.info = do ->
      Function.prototype.bind.call(console.info, console)
  else
    ext._log.info = ->
  #warn
  if ext._config.silent isnt true
    ext._log.warn = do ->
      Function.prototype.bind.call(console.warn, console)
  else
    ext._log.warn = ->
  #error
  ext._log.error = do ->
    Function.prototype.bind.call(console.error, console)




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
