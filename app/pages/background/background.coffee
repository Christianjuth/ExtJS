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
  ext.ini({
    silent : false
  })

  #your code here

  #set icon badge on extension load
  ext.menu.setBadge parseInt ext.storage.get "google"

  #set icon click function
  ext.menu.iconOnClick () ->
    ext.tabs.indexOf "htt*//plus.google.com**", (data) ->
      if data.length is 0
        ext.storage.set("google", parseInt(ext.storage.get("google")) + 1)
        ext.menu.setBadge ext.storage.get("google")
        ext.tabs.create "https://plus.google.com",true
      else
        console.log data
