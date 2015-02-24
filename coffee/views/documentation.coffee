define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "marked",
  "highlight",
  "text!templates/404.html"
], ($, _, Mustache, Backbone, Parse, marked, hljs, Err) ->


  View = Backbone.View.extend {

    el: $('.content')

    initialize: (options)->
      self = this
      self.options = options
      _.bindAll(this, 'render')
      this.render()

    render: ->
      self = this
      options = self.options
      data = {}
      Template = ""

      $.ajax {
        type: "GET",
        url: "//ext-js.org/collections/documentation/"+options.file+".md"
        async: false,
        success : (data) ->
          Template = marked(data)
        error : ->
          Template = Err
      }

      if /^(<html>|<body>|<!doctype)/i.test(Template)
        Template = Err

      compiledTemplate = Mustache.render( Template , {})
      this.$el.html( compiledTemplate )

      $('pre > code').each (i, block) ->
        hljs.highlightBlock(block)

      $('.loader').fadeOut(100)

  }

  #Our module now returns our view
  return View;
