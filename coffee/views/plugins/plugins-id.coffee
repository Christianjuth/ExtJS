define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "highlight",
  "marked",
  "text!templates/plugins/plugins-id.html"
  "text!templates/404.html"
], ($, _, Mustache, Backbone, Parse, hljs, marked , Template, Err) ->

  PluginModle = Parse.Object.extend "Plugin", {}
  PluginCollection = Parse.Collection.extend {}

  View = Backbone.View.extend {

    #vars
    el: $('.page'),

    initialize: (options)->
      self = this
      self.options = options
      _.bindAll(this, 'render')

      self.plugin = new PluginCollection
      self.plugin.query = new Parse.Query(PluginModle)
      self.plugin.query.equalTo("search", options.plugin.toLowerCase())
      self.plugin.fetch {
        success: -> self.render()
      }

    render: () ->
      self = this
      $el = self.$el
      plug = self.plugin.at 0
      readmeMd = plug.get('readme')

      #Append our compiled template to this Views "el"
      compiledReadmeMd = marked(readmeMd)
      compiledTemplate = Mustache.render($(Template).html(),{
        readme: compiledReadmeMd
      })
      $el.html( compiledTemplate )

      $('pre > code').each (i, block) ->
        hljs.highlightBlock(block)

      self.show()

  }

  #Our module now returns our view
  return View
