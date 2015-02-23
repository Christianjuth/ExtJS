define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "highlight",
  "text!templates/search-plugins.html"
], ($, _, Mustache, Backbone, Parse, hljs, Template) ->


  #define modle and collection
  PluginModle = Parse.Object.extend "Plugin", {}
  PluginCollection = Parse.Collection.extend {}



  #define view
  View = Backbone.View.extend {


    el: $('.content')


    initialize: (options) ->
      self = this
      _.bindAll(this, 'render')
      search = options.search
      self.render(search)



    render: (search) ->
      self = this
      $el = this.$el

      compiledTemplate = Mustache.render( $(Template).find('.view').html(), {} )
      self.$el.html( compiledTemplate )
      $el.find('.plugins tbody').empty()

      $el.find('.search').val(search)
      $el.find('.search').keyup ->
        self.search($(this).val())
      self.search(search)

      $('pre > code').each (i, block) ->
        hljs.highlightBlock(block)

      $('.loader').fadeOut(100)



    search: (search)->
      self = this
      $el = this.$el

      if search is null
        search = ''

      this.plugins = new PluginCollection
      #name query
      nameQuery = new Parse.Query(PluginModle)
      nameQuery.contains("search", search)
      #developer query
      developerQuery = new Parse.Query(PluginModle)
      developerQuery.contains("developer", search)
      #main query
      this.plugins.query = Parse.Query.or(nameQuery,developerQuery)
      this.plugins.query.notEqualTo("name","")
      this.plugins.query.notEqualTo("file", null)
      this.plugins.query.ascending("name")
      this.plugins.fetch {
        success: -> self.searchRender()
      }
      #vars
      $el = this.$el
      Backbone.history.navigate "search/plugins?search=" + search, {replace: true}



    searchRender: ->
      self = this
      $el = this.$el

      $el.find('.plugins tbody').empty()
      self.plugins.each (plug)->
        console.log plug.get("plugin")
        plugTemplate = Mustache.render( $(Template).find('.item').html(), {
          name:       plug.get('name')
          min:        plug.get('minified')
          unmin:      plug.get('unminified')
          developer:  plug.get('developer')
        })
        $el.find('.plugins tbody').append(plugTemplate)



  }



  #Our module now returns our view
  return View;
