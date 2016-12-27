#Page: background.html
window.message = "hey"

#onload
require [
  "jquery"
  "ext"

  #Load framework plugins
  "extPlugin/uuid"
  "extPlugin/storage"
  "extPlugin/clipboard"
  "extPlugin/utilities"
  "extPlugin/tabs"
  "extPlugin/popup"
], ($, ext) ->

  #initilize extjs
  ext.ini()

  #your code here
