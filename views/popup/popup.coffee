#Page: popup.html

#define library alialses
require.config paths :
  jquery : "../../libs/jquery-min"
  framework : "../../assets/js/framework/framework"
  underscore : "../../libs/underscore-min"

#onload
require [
  "jquery",
  "framework/js/framework",
  "underscore"
], ($,framework,_) ->

  framework.ini()
  #your code here
