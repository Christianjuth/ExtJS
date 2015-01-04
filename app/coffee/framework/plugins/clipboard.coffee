window.ext.clipboard = {

  _info :
    authors : ['Christian Juth']
    name : 'Clippy'
    version : '0.1.0'
    compatibility :
      chrome : 'full'
      safari : 'none'

  _aliases : ['clippy']

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
