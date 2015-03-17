#Page: popup.html

#onload
require [
  "jquery",
  "underscore",
  "mustache",
  "ext",

  "extPlugin/popup",
  "extPlugin/tabs",
  "extPlugin/notification"
], ($,_,Mustache,ext) ->

  #initilize extjs
  ext.ini()

  #this wrapper allows Safari to run
  #popup scripts like Chrome and Opera
  console.log ext.popup
  ext.popup.codeWrap ->

    #set popup dimentions
    ext.popup.setHeight(300)
    ext.popup.setWidth(500)

    #your code here
