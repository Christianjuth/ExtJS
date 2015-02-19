define [
  "jquery",
  "underscore",
  "mustache",
  "backbone"
  "parse",
  "sweetalert"
  "text!templates/login.html"
], ($, _, Mustache, Backbone, Parse, swal, Template) ->

  View = Backbone.View.extend({

    el: $('.content')

    events :
      'submit .login':   'login'
      'submit .sign-up': 'signup'

    initilize: (url)->
      this.url = url
      this.render()

    render: ->
      #Using Underscore we can compile our template with data
      compiledTemplate = Mustache.render( Template , {})
      this.$el.html( compiledTemplate )
      #hide loader
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
          swal("Error!", error.message, "error")
      })


    signup : (e) ->
      e.preventDefault()
      self = this

      $form = $(".sign-up");
      username = $form.find(".username").val()
      password = $form.find(".password").val()
      email = $form.find(".email").val()

      user = new Parse.User()
      user.set('username', username)
      user.set('password', password)
      user.set('email', email)

      user.signUp( null, {
        success: (user) ->
          Backbone.history.navigate self.url, {trigger: true}
        error: (user, error) ->
          swal("Error!", error.message, "error")
      })

  })

  #Our module now returns our view
  return View;
