#Page: background.html

#define library alialses
require.config paths :
  jquery : "../../assets/js/libs/jquery-min"
  framework : "../../framework"
  underscore : "../../assets/js/libs/underscore-min"

#onload
require [
  "jquery",
  "framework/js/framework",
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
