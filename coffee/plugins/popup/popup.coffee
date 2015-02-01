PLUGIN = {

_: {

#INFO
authors : ['Christian Juth']
name : 'Popup'
version : '0.1.0'
min : '0.1.0'
compatibility :
  chrome : 'full'
  safari : 'full'

}



#FUNCTIONS
setWidth: (width)->
  if BROWSER is 'chrome'
    $('html, body').width(width)
  if BROWSER is 'safari'
    safari.self.width = width



setHeight: (height)->
  if BROWSER is 'chrome'
    $('body').height(height)
  if BROWSER is 'safari'
    safari.self.height = height



}
