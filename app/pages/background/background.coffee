#Page: background.html
window.message = "hey"

#onload
require [
  "jquery",
  "underscore",
  "ext",

  #Load framework plugins
  "extPlugin/uuid",
  "extPlugin/storage",
  "extPlugin/clipboard",
  "extPlugin/utilities",
  "extPlugin/tabs",
  "extPlugin/popup"
], ($, _, ext) ->

  #initilize extjs
  ext.ini()

  #your code here
