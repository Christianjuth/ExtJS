#functions/parse.coffee

#The foloing functions are used to manipulate
#the inputed string/numbers and return the new
#value
parse :


  url: (url) ->
    #check usage
    usage = 'url string'
    ok = ext._.validateArg(arguments, ['string'], usage)
    throw new Error(ok) if ok?
    #logic
    if !ext.validate.url(url)
      throw Error 'Invalid url'
    protical =
      url.indexOf('https://') isnt -1 and
      url.indexOf('https://') isnt -1
    if !protical
      url = 'http://' + url
    return url



  #This function will take an unlimited amount
  #of parameters that are strings, Ints, floats,
  #or arrays. Object will work as well but are
  #not recommended. This function takes all of
  #these parameters and combines them into one
  #array.  This function currently does not
  #support arrays in arrays (or array inception).
  array : ->
    #vars
    output = []
    input = arguments
    #parse array
    for item in input
      if typeof item is "string"
        output.push item
      else
        output = output.concat item
    return output



  #This function will make the input text all
  #lowercase and replace spaces with "_". This
  #can be useful for tasks where spaces are not.
  #allowed
  id : (id) ->
    #check usage
    usage = 'id string'
    ok = ext._.validateArg(arguments, ['string'], usage)
    throw new Error(ok) if ok?
    #logic
    id.toLowerCase().replace(/\ /g,"_")



  #This function will escape most regex special
  #chars from a string. This can be used to
  #nutrilize a string to match or replace the
  #exact value using rexes
  normalize : (text) ->
    #check usage
    usage = 'string'
    ok = ext._.validateArg(arguments, ['string'], usage)
    throw new Error(ok) if ok?
    #logic
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
    #normal regex characters defined in regexEscChars
    regexEscChars = regexEscChars.replace(/\ /g, '|')
    regexEscChars = new RegExp('(?=(' + regexEscChars + '))' , 'g')
    text = text.replace(regexEscChars,'\\')
    return text
