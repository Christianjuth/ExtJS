define [
  "jquery",
  "underscore",
  "backbone",
  "parse",
  "text!templates/home.html"
], ($, _, Backbone, Parse, Template) ->

  View = Backbone.View.extend({
    el: $('.content'),
    render: ->
      #Using Underscore we can compile our template with data
      data = {}
      compiledTemplate = _.template( Template , data )
      #Append our compiled template to this Views "el"
      this.$el.html( compiledTemplate )

      if window.innerWidth < 850
        $(".sidebar .links").slideUp()
        $(".sidebar").attr "toggle","false"

      $('.loader').fadeOut(100)

  });

  #Our module now returns our view
  return View;
