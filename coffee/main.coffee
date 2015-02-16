#Filename: main.js

#Require.js allows us to configure shortcut alias
#There usage will become more apparent further along in the tutorial.
require.config {

  #set base url to ext.js.com/
  baseUrl : "/",

  #define dependencies
  shim :
    underscore :
      exports: "_"

    bootstrap :
      deps: ["jquery"]

    parse :
      deps: ["jquery"]
      exports: "Parse"

    sweetalert :
      exports: "swal"

    marked  :
      exports: "marked "

    backbone :
      deps: ["jquery", "underscore"],
      exports: "Backbone"

  #define path aliases
  #that can be used later
  paths :
    jquery:       "./assets/libs/jquery-min",
    mustache:     "./assets/libs/mustache.min",
    underscore:   "./assets/libs/underscore-min",
    backbone:     "./assets/libs/backbone-min",
    templates:    "./templates",
    bootstrap:    "./assets/libs/bootstrap",
    highlight:    "./assets/libs/highlight.pack"
    parse:        "./assets/libs/parse"
    sweetalert:   "./assets/libs/sweet-alert.min"
    marked :      "./assets/libs/marked"
    js:           "./assets/js"

}

require [

  #Load our app module and
  #pass it to our definition
  #function
  'js/app'

  #Lode responsive file
  'js/responsive'

], (App) ->

  #initialize the parse
  #library with keys
#  Parse.initialize("kZS90MpRoWUMtFEgdt8kdWSejhl3thUb9GPdekpb", "ND73SsKVmvrxJ04LmLNgN2lqulJqdjqfRkvI6n23")

  #The "app" dependency is passed in as "App"
  App.initialize()
