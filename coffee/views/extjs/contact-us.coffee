define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "marked",
  "sweetalert"
  "text!templates/extjs/contact-us.html"
], ($, _, Mustache, Backbone, Parse, marked, swal, Template) ->


  View = Backbone.View.extend {

    el: $('.content')

    events :
      'submit .contact':       'contact'

    initialize: (options)->
      self = this
      self.options = options
      _.bindAll(this, 'render')
      this.render()

    render: ->
      #Using Underscore we can compile our template with data
      compiledTemplate = Mustache.render( $(Template).find('.view').html() , {})
      this.$el.html( compiledTemplate )
      #hide loader
      $('.loader').fadeOut(100)

    sent: ->
      #Using Underscore we can compile our template with data
      compiledTemplate = Mustache.render( $(Template).find('.sent').html() , {})
      this.$el.html( compiledTemplate )

    contact: (e)->
      e.preventDefault()
      self = this

      $form = $(".contact");
      post_data = {
        'name' : $form.find('.name').val(),
        'email' : $form.find('.email').val(),
        'favorite_song' : $form.find('.song').val(),
        'message' : $form.find('.message').val(),
      }

      $.post('//'+location.host+'/php/mail.php', post_data, (data,status)->
          if data is 'true'
            self.sent()
          else
            swal("Oops...", data, "error")
      , 'json')



  }

  #Our module now returns our view
  return View;
