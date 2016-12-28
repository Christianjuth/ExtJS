# set default options
defultOptions = {
  verbose : true
}






# extension framework
ext = {
  ini: (options) ->
    #set vars
    options = $.extend defultOptions, options
    #expose options globally
    ext._.options = options
    ext._.onload()
    return window.ext
  
  safari: (callback) ->
    #check usage
    usage = 'callback function'
    ok = ext._.validateArg(arguments, ['function'], usage)
    throw new Error(ok) if ok?
    #logic
    if ext._.browser is 'safari'
      callback()
      
  chrome: (callback) ->
    #check usage
    usage = 'callback function'
    ok = ext._.validateArg(arguments, ['function'], usage)
    throw new Error(ok) if ok?
    #logic
    if ext._.browser is 'chrome'
      callback()

}







#Define a global copy of the library.
#This is important because this is where
#ExtJS becomes accessible to the user in
#the window object
window.ext = ext

#This function defines the "ext" AMD module.
#Without this ExtJS would not be compatible
#with things like requirejs.
if typeof window.define is 'function' && window.define.amd
  window.define 'ext', ['jquery'], ->
    ext._.onbeforeload(ext)
    window.ext
    ext._.onload()
    return ext

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
