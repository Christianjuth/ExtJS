define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "marked",
  "highlight",
  "text!templates/documentation/page.html"
  "text!templates/404.html"
], ($, _, Mustache, Backbone, Parse, marked, hljs, Template, Err) ->


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
      compiledTemplate = ""

      $.ajax {
        type: "GET",
        url: '//'+window.location.host+'/collections/documentation/'+options.doc+'
.md'
        async: false,
        success : (data) ->
          #fix page inception error
          if /^(<!doctype|<html>|<body>|<!doctype)/i.test(data)
            compiledTemplate = Err
          else
            doc = marked(data)
            compiledTemplate = Mustache.render( Template , {
              doc: doc
            })
        error : ->
          compiledTemplate = Err
      }

      this.$el.html( compiledTemplate )

      $('pre > code').each (i, block) ->
        hljs.highlightBlock(block)

      $('.loader').fadeOut(100)

  }

  #Our module now returns our view
  return View;
