#Page: background.html

#define library alialses
require.config paths :
  jquery : "../../libs/jquery-min"
  framework : "../../assets/js/framework/framework"
  underscore : "../../libs/underscore-min"

#onload
require [
  "jquery",
  "framework",
  "underscore",
  "storage"
], ($,framework, _, storage) ->
  framework.ini()
  storage.ini()

  #your code here
  framework.menu.icon.setBadge localStorage.google

  framework.menu.icon.click () ->
    framework.tabs.indexOf "*.google.com", (data) ->
      if data.length is 0
        localStorage.google = parseInt(localStorage.google) + 1
        framework.menu.icon.setBadge localStorage.google
        framework.tabs.create "https://www.google.com",true
