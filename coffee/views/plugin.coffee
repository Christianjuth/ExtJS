define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "highlight",
  "marked",
  "text!templates/404.html"
], ($, _, Mustache, Backbone, Parse, hljs, marked , Err) ->

  PluginModle = Parse.Object.extend "Plugin", {}
  PluginCollection = Parse.Collection.extend {}

  View = Backbone.View.extend {

    el: $('.content'),

    initialize: (options) ->
      self = this
      name = options.plugin
      _.bindAll(this, 'render')

      this.plugin = new PluginCollection
      this.plugin.query = new Parse.Query(PluginModle)
      this.plugin.query.equalTo("search", name.toLowerCase())
      this.plugin.fetch {
        success: -> self.render(name)
      }

    render: (name) ->
      $el = this.$el
      plug = this.plugin.at 0
      Template = plug.get('readme')

      #Append our compiled template to this Views "el"
      compiledTemplate = marked(Template)
      $el.html( compiledTemplate )

      $('pre > code').each (i, block) ->
        hljs.highlightBlock(block)

      $('.loader').fadeOut(100)

  }

  #Our module now returns our view
  return View
