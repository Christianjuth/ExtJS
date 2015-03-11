define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "highlight",
  "text!templates/resources/search-plugins.html"
], ($, _, Mustache, Backbone, Parse, hljs, Template) ->


  #define modle and collection
  PluginModle = Parse.Object.extend "Plugin", {}
  PluginCollection = Parse.Collection.extend {}



  #define view
  View = Backbone.View.extend {

    events :
      'submit .search-form' : 'submit'


    el: $('.content')


    initialize: (options)->
      self = this
      _.bindAll(this, 'render')
      self.query = options.query
      self.render(self.query)



    render: (search) ->
      self = this
      $el = this.$el

      compiledTemplate = Mustache.render( $(Template).find('.view').html(), {} )
      self.$el.html( compiledTemplate )
      $el.find('.plugins tbody').empty()

      $el.find('.search').val(search)
      $el.find('.search').on('keydown', (e)->
        if e.code is 13 || e. which  is 13
          return
        $el.find('.plugins tbody').html($(Template).find('.empty').html())
      )
      self.search(search)

      $('.loader').fadeOut(100)



    submit: (e)->
      e.preventDefault()
      self = this
      $el = this.$el
      search = $el.find('.search').val()
      self.search(search)



    search: (search)->
      self = this
      $el = this.$el

      if search is null
        search = ''

      #dissable duplicate searches
      if search is self.currentSearch
        return
      self.currentSearch = search

      $el.find('.search').val(search)

      this.plugins = new PluginCollection
      #name query
      nameQuery = new Parse.Query(PluginModle)
      nameQuery.contains("search", search)
      #developer query
      developerQuery = new Parse.Query(PluginModle)
      developerQuery.contains("developer", search)
      #main query
      this.plugins.query = Parse.Query.or(nameQuery,developerQuery)
      this.plugins.query.notEqualTo("file", null)
      this.plugins.query.ascending("name")
      this.plugins.fetch {
        success: -> self.searchRender()
      }
      #vars
      $el = this.$el
      Backbone.history.navigate "resources/search-plugins?search=" + search, {replace: true}



    searchRender: ->
      self = this
      $el = this.$el

      $el.find('.plugins tbody').empty()
      self.plugins.each (plug)->
        name =        plug.get('name')
        developer =   plug.get('developer')

        plugTemplate = Mustache.render( $(Template).find('.item').html(), {
          name:       name
          link:       name.toLowerCase()
          developer:  developer
        })
        $this = $(plugTemplate).appendTo($el.find('.plugins tbody'))

        $this.find('.link').click (e)->
          e.preventDefault()
          self.search(developer)



  }



  #Our module now returns our view
  return View;
