define [
  "jquery",
  "underscore",
  "parse",
  "highlight",
  "marked",
  "text!templates/404.html"
], ($, _, Parse, hljs, marked , Err) ->

  PluginModle = Parse.Object.extend "Plugin", {}
  PluginCollection = Parse.Collection.extend {}

  View = Parse.View.extend {

    el: $('.content'),

    initialize: () ->
      self = this

      _.bindAll(this, 'render')
      name = this.options.plugin

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
      Template = marked  Template
      $el.html( Template )

      if window.innerWidth < 850
        $(".sidebar .links").slideUp()
        $(".sidebar").attr "toggle","false"

      $('pre > code').each (i, block) ->
        hljs.highlightBlock(block)

      $('.loader').fadeOut(100)

  }

  #Our module now returns our view
  return View;
