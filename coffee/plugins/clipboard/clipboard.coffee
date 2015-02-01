PLUGIN = {

_: {

  #INFO
  authors : ['Christian Juth']
  name : 'Clipboard'
  aliases : ['clippy']
  version : '0.5.0'
  min : '0.1.0'
  compatibility :
    chrome : 'full'
    safari : 'none'

}



#FUNCTIONS
write : (text) ->
  #set vars
  input = text
  output = input

  copyFrom = $('<input/>')
  copyFrom.val(input)
  $('body').append(copyFrom)
  copyFrom.select()
  document.execCommand('copy')
  copyFrom.remove()
  output

read : () ->
  #set vars
  input = ""
  output = ""

  pasteTo = $('<input/>')
  $('body').append(pasteTo)
  pasteTo.select()
  document.execCommand('paste')
  output = pasteTo.val()
  pasteTo.remove()
  output

}
