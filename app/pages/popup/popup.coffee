#Page: popup.html

#onload
require [
  "jquery"
  "mustache"
  "ext"

  "extPlugin/popup"
  "extPlugin/tabs"
  "extPlugin/notification"
], ($, Mustache, ext) ->

  #initilize extjs
  ext.ini()

  #this wrapper allows Safari to run
  #popup scripts like Chrome and Opera
  ext.popup.codeWrap ->

    #set popup dimentions
    ext.popup.setHeight(300)
    ext.popup.setWidth(500)

    #your code here
