define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "text!templates/account-settings.html"
], ($, _, Mustache, Backbone, Parse, Template) ->

  View = Backbone.View.extend({
    el: $('.content')

    events :
      'click .logout' : 'logout'

    render: ->
      user = Parse.User.current()

      username = user.getUsername()
      email = user.getEmail()

      #Using Underscore we can compile our template with data
      data = {}
      compiledTemplate = _.template( Template , data )
      #Append our compiled template to this Views "el"
      this.$el.html( compiledTemplate )

      $form = $('.account')
      $form.find('.name').text(username)
      $form.find('.email').text(email)

      if window.innerWidth < 850
        $(".sidebar .links").slideUp()
        $(".sidebar").attr "toggle","false"

      $('.loader').fadeOut(100)


    logout : (e) ->
      e.preventDefault()
      Parse.User.logOut()
      Backbone.history.navigate "account/login", {trigger: true}

  });

  #Our module now returns our view
  return View;
