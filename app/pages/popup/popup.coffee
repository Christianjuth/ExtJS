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

  # Initilize Extension Framework
  ext.ini()

  # this wrapper allows Safari to run
  # popup scripts like Chrome and Opera
  ext.popup.codeWrap ->

    # Set Popup Dimentions
    ext.popup.setHeight(300)
    ext.popup.setWidth(501)

    # your code here
