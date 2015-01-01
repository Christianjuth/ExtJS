#Page: background.html
window.message = "hey"

#onload
require [
  "jquery",
  "underscore",
  "storage",
  "ext",

  #Load framework plugins
  "extPlugin/clipboard",
  "extPlugin/storage",
  "extPlugin/extension",
  "extPlugin/notification",
  "extPlugin/tabs",
], ($, _, storage, ext) ->
  ext.ini()
  storage.ini()

  #your code here
  ext.menu.icon.setBadge localStorage.google

  ext.menu.icon.click () ->
    ext.tabs.indexOf "*.google.com", (data) ->
      if data.length is 0
        localStorage.google = parseInt(localStorage.google) + 1
        ext.menu.icon.setBadge localStorage.google
        ext.tabs.create "https://www.google.com",true
