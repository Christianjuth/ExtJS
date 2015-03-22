define [
  "jquery",
  "underscore",
  "mustache"
  "backbone",
  "text!templates/404.html"
], ($, _, Mustache, Backbone, Template) ->

  View = Backbone.View.extend({

    el: $('.page')

    initialize: (options)->
      self = this
      self.options = options
      _.bindAll(this, 'render')
      this.render()

    render: ->
      self = this
      $el = self.$el

      #Using Underscore we can compile our template with data
      compiledTemplate = Mustache.render( Template , {})
      $el.html( compiledTemplate )

      #hide loader after video loads
      $el.ready -> self.show()

  })

  #Our module now returns our view
  return View
