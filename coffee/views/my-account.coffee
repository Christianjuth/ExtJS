define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "sweetalert",
  "text!templates/my-account.html"
], ($, _, Mustache, Backbone, Parse, swal, Template) ->

  View = Backbone.View.extend({
    el: $('.content')

    events :
      'click .logout' : 'logout'
      'click .update' : 'update'

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
      user.set('email', $this.find('.email').val())

      user.save(null, {
        success: (plug) ->
          swal("Updated!", "", "success")
        error: (user, error) ->
          swal("Error!", error.message, "error")
      })

  });

  #Our module now returns our view
  return View;
