define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "queryString",
  "text!templates/mail/subscribe.html"
], ($, _, Mustache, Backbone, Parse, queryString, Template) ->

  View = Backbone.View.extend({

    #vars
    query: {
      'email': ''
    }
    el: $('.content')

    initialize: (options)->
      self = this
      self.options = options
      _.bindAll(this, 'render')
      self.query = jQuery.extend(self.query, queryString.parse(location.search))
      this.render()

    render: ->
      self = this
      $el = self.$el
      #Using Underscore we can compile our template with data
      compiledTemplate = Mustache.render( Template , {
        email: self.query.email
      })
      this.$el.html( compiledTemplate )
      #hide loader
      $el.ready -> self.show()

  })

  #Our module now returns our view
  return View
