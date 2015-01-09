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
