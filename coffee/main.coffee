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
    jquery:       "//ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min",
    mustache:     "//cdnjs.cloudflare.com/ajax/libs/mustache.js/0.8.1/mustache.min",
    underscore:   "//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.2/underscore-min",
    backbone:     "//cdnjs.cloudflare.com/ajax/libs/backbone.js/1.1.2/backbone-min",
    bootstrap:    "//maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min",
    analytics:    "./assets/libs/backbone.analytics",
    queryString:  "./assets/libs/query-string",
    templates:    "./templates",
    highlight:    "./assets/libs/highlight.pack"
    parse:        "./assets/libs/parse.min"
    sweetalert:   "./assets/libs/sweet-alert.min"
    marked :      "//cdnjs.cloudflare.com/ajax/libs/marked/0.3.2/marked.min"
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
