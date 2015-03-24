define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "marked",
  "highlight",
  "text!templates/documentation/documentation-id.html"
  "text!templates/404.html"
], ($, _, Mustache, Backbone, Parse, marked, hljs, Template, Err) ->


  View = Backbone.View.extend {

    el: $('.page')

    initialize: (options)->
      self = this
      self.options = options
      _.bindAll(this, 'render')
      this.render()

    render: ->
      self = this
      $el = self.$el
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

      $el.html( compiledTemplate )
      $el.find('h1,h2,h3,h4,h5').click ->
        $this = $(this)
        id = $this.attr('id')
        if id?
          url = window.location.pathname.replace(/(\/)$/,'')+'#'+id
          window.history.replaceState(null, null, url)


      self.show()

      $('pre > code').each (i, block) ->
        hljs.highlightBlock(block)

  }

  #Our module now returns our view
  return View;
