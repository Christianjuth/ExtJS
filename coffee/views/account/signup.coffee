define [
  "jquery",
  "underscore",
  "mustache",
  "backbone"
  "parse",
  "sweetalert"
  "text!templates/account/signup.html"
], ($, _, Mustache, Backbone, Parse, swal, Template) ->

  View = Backbone.View.extend({

    el: $('.content')


    events :
      'submit .sign-up':       'signup'


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
      $el.find('.username').select()
      $('.loader').fadeOut(100)


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
          Backbone.history.navigate self.options.redirect, {}
          location.reload()
        error: (user, error) ->
          swal("Error!", error.message, "error")
      })


  })

  #Our module now returns our view
  return View;
