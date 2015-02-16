#Page: popup.html

#onload
require [
  "jquery",
  "underscore",
  "ext",

  "extPlugin/popup",
  "extPlugin/tabs",
  "extPlugin/notification"
], ($,_,ext) ->

  #your code here
  ext.popup.codeWrap ->
    alert()
