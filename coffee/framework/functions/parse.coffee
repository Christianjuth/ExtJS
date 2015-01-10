parse :

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
    id.toLowerCase().replace(/\ /g,"_")
