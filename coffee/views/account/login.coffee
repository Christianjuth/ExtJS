define [
  "jquery",
  "underscore",
  "mustache",
  "backbone"
  "parse",
  "sweetalert"
  "text!templates/account/login.html"
], ($, _, Mustache, Backbone, Parse, swal, Template) ->

  View = Backbone.View.extend({

    el: $('.page')

    events :
      'submit .login':          'login'
      'click .signup':          'redirectSignup'
      'click .reset-password':  'resetPassword'

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
      self.show()


    login : (e) ->
      e.preventDefault()
      self = this

      $form = $(".login");
      username = $form.find(".username").val()
      password = $form.find(".password").val()

      Parse.User.logIn(username, password, {
        success: (user) ->
          Backbone.history.navigate self.options.redirect, {}
          location.reload()
        error: (user, error) ->
          swal("Error!", error.message, "error")
      })

      return false

    redirectSignup: (e)->
      e.preventDefault()
      self = this
      url = "account/signup?redirect="+self.options.redirect
      Backbone.history.navigate url, {trigger: true, replace: true}


    resetPassword: (e)->
      e.preventDefault()
      self = this
      url = "account/password-reset?redirect="+self.options.redirect
      Backbone.history.navigate url, {trigger: true}


  })

  #Our module now returns our view
  return View;
