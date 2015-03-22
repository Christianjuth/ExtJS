define [
  "jquery",
  "underscore",
  "mustache",
  "backbone"
  "parse",
  "sweetalert"
  "text!templates/account/password-reset.html"
], ($, _, Mustache, Backbone, Parse, swal, Template) ->

  View = Backbone.View.extend({

    el: $('.page')

    events :
      'submit .reset-password':    'resetPasswd'

    initialize: (options)->
      self = this
      self.options = options
      _.bindAll(this, 'render')
      this.render()

    render: ->
      self = this
      #Using Underscore we can compile our template with data
      compiledTemplate = Mustache.render( Template , {})
      this.$el.html( compiledTemplate )
      #hide loader
      self.show()


    resetPasswd: (e)->
      e.preventDefault()
      self = this
      $el = self.$el
      email = $el.find('.email').val()
      Parse.User.requestPasswordReset(email, {
        success: ()->
          swal("", "Password reset email sent to "+email, "success")
          Backbone.history.navigate self.options.redirect, {trigger: true}
        error: (error)->
          swal("Error!", error.message, "error")
      })


  })

  #Our module now returns our view
  return View;
