#Filename: app.js
define [
  'jquery',
  'underscore',
  'backbone',
  'parse'
  'js/router', #Request router.js

], ($, _, Backbone, Parse, Router) ->
  Parse.initialize "kZS90MpRoWUMtFEgdt8kdWSejhl3thUb9GPdekpb", "ND73SsKVmvrxJ04LmLNgN2lqulJqdjqfRkvI6n23"

  initialize = () ->
    #Pass in our Router module and call it's initialize function
    Router.initialize()

  return {
    initialize: initialize
  }