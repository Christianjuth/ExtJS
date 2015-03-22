define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "text!templates/mail/confirm.html"
], ($, _, Mustache, Backbone, Parse, Template) ->

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
      this.$el.html( compiledTemplate )
      #hide loader
      $el.ready -> self.show()

  })

  #Our module now returns our view
  return View
