define [
  "jquery",
  "underscore",
  "backbone"
  "parse",
  "text!templates/login.html"
], ($, _, Backbone, Parse, Template) ->

  View = Backbone.View.extend({
    el: $('.content')

    events :
      'submit .login' : 'login'

    initilize: (url)->
      this.url = url
      this.render()

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
      self = this

      $form = $(".login");
      username = $form.find(".username").val()
      password = $form.find(".password").val()

      Parse.User.logIn(username, password, {
        success: (user) ->
          Backbone.history.navigate self.url, {trigger: true}
        error: (user, error) ->
          alert("Error: " + JSON.stringify error);
      })

  });

  #Our module now returns our view
  return View;
