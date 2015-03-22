define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "highlight",
  "marked",
  "text!templates/resources/extjs-downloads.html"
], ($, _, Mustache, Backbone, Parse, hljs, marked , Template) ->

  View = Backbone.View.extend {

    el: $('.page'),

    initialize: (options)->
      self = this
      self.options = options
      _.bindAll(this, 'render')

      self.render()

    render: ->
      self = this
      $el = self.$el

      #Append our compiled template to this Views "el"
      compiledTemplate = marked(Template)
      $el.html( compiledTemplate )

      self.show()

  }

  #Our module now returns our view
  return View
