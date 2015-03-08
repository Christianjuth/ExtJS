define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "sweetalert",
  "text!templates/account/my-account.html"
], ($, _, Mustache, Backbone, Parse, swal, Template) ->

  View = Backbone.View.extend({

    el: $('.content')

    events :
      'click .logout':       'logout'
      'click .update':       'update'
      'click .reset-passwd': 'resetPassword'

    initialize: (options)->
      self = this
      self.options = options
      _.bindAll(this, 'render')
      this.render()

    render: ->
      user = Parse.User.current()

      username = user.getUsername()
      email = user.getEmail()

      #Using Underscore we can compile our template with data
      compiledTemplate = Mustache.render( Template , {
        user: username
        email: email
      })
      this.$el.html( compiledTemplate )

      $('.loader').fadeOut(100)


    logout: (e) ->
      e.preventDefault()
      Parse.User.logOut()
      Backbone.history.navigate "/", {trigger: true}


    update: (e)->
      e.preventDefault()
      self = this
      user = Parse.User.current()
      $this = self.$el.find('.account')

      swal({
        title: "Are you sure?",
        text: "Updating your account may require you to reverify your email.",
        type: "info",
        showCancelButton: true,
        confirmButtonClass: "btn-primary",
        confirmButtonText: "Ok",
        cancelButtonText: "Cancel"
      }, ->
        #update info
        user.set('email', $this.find('.email').val())
        #save user
        user.save(null, {
          success: (plug) ->
            swal("Updated!", "", "success")
          error: (user, error) ->
            swal("Error!", error.message, "error")
        })
      )


    resetPassword: (e)->
      e.preventDefault()
      user = Parse.User.current()
      email = user.getEmail()
      Parse.User.requestPasswordReset(email, {
        success: ()->
          swal("", "Password reset email sent to "+email, "success")
        error: (error)->
          swal("Error!", error.message, "error")
});


  });

  #Our module now returns our view
  return View;
