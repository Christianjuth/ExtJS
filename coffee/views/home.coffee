define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "queryString",
  "text!templates/home.html"
], ($, _, Mustache, Backbone, Parse, queryString, Template) ->

  View = Backbone.View.extend({

    events:
      'submit .subscribe':    'subscribe'

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



    subscribe: (e)->
      e.preventDefault()
      self = this
      $el = self.$el

      query = {
        email: $el.find('.subscribe').find('.email').val()
      }
      url = '/mail/subscribe?'+queryString.stringify(query)
      Backbone.history.navigate  url, {trigger: true}

  })

  #Our module now returns our view
  return View
