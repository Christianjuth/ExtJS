define [
  "jquery",
  "underscore",
  "parse",
  "text!templates/login.html"
], ($, _, Parse, Template) ->

  View = Parse.View.extend({
    el: $('.content')

    events :
      'submit .login' : 'login'

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


    login : (e) ->
      e.preventDefault()
      $form = $(".login");
      username = $form.find(".username").val()
      password = $form.find(".password").val()

      Parse.User.logIn username,password, {
        success: (user) ->
          Parse.history.navigate "account/plugins", {trigger: true, replace: true}
        error: (user, error) ->
          alert("Error: " + JSON.stringify error);
      }

  });

  #Our module now returns our view
  return View;
