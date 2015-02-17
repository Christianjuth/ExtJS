#Filename: router.js
define [
  'jquery',
  'underscore',
  'backbone',
  'parse',

  #load views
  'js/views/404',
  'js/views/documentation',
  'js/views/plugin',
  'js/views/home'
  'js/views/account-plugins'
  'js/views/account-login'
  'js/views/account-settings'
  'js/views/search-plugins'

], ($, _, Backbone, Parse, NotFound, Doc, Plugin, Home, AccountPlugins, AccountLogin, AccountSettings, SearchPlugins) ->

  Backbone.View.prototype.close = () ->
    console.log('Unbinding events for ' + this.cid)
    this.$el.empty().unbind()
    $('.loader').show()
    if this.onClose
      this.onClose()

  AppRouter = Backbone.Router.extend {
    routes :
      #Define some URL routes
      '': 'home',
      'documentation/*path':         'doc'
      'plugin/*path':                'plugin'
      'search/plugins(?:query)':       'searchPlugins'
      'account/login(?redirect=*path)':  'accountLogin'
      'account/plugins' :            'accountPlugins'
      'account/settings' :           'accountSettings'

      #404
      '*splat': 'defaultAction'
  }

  initialize = () ->
    app_router = new AppRouter

    app_router.closeView = () ->
      if this.currentView
        this.currentView.close()

    app_router.openView = (view) ->
      this.currentView = view
      if window.innerWidth < 850
        $(".sidebar .links").slideUp()
        $(".sidebar").attr("toggle","false")
      $(window).scrollTop(0)

    app_router.on 'route:home', () ->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      home = new Home()
      home.render()
      this.openView(home)

    app_router.on 'route:doc', (path) ->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      doc = new Doc()
      doc.render(path)
      this.openView(doc)

    app_router.on 'route:plugin', (path) ->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      plugin = new Plugin({
        plugin: path
      })
      plugin.initialize()
      $('.loader').hide()
      this.openView(plugin)

    app_router.on 'route:searchPlugins', (query) ->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      searchPlugins = new SearchPlugins({
        search: query
      })
      searchPlugins.initialize()
      this.openView(searchPlugins)

    app_router.on 'route:accountPlugins', () ->
      #We have no matching route, lets just log what the URL was
      if Parse.User.current() is null
        login = "account/login?redirect="+Backbone.history.fragment
        Backbone.history.navigate login, {trigger: true}
      else
        this.closeView()
        accountPlugins = new AccountPlugins()
        accountPlugins.render()
        this.openView(accountPlugins)

    app_router.on 'route:accountLogin', (path) ->
      #We have no matching route, lets just log what the URL was
      if Parse.User.current() isnt null
        Backbone.history.navigate "", {trigger: true}
      else
        this.closeView()
        accountLogin = new AccountLogin()
        accountLogin.initilize(path)
        this.openView(accountLogin)

    app_router.on 'route:accountSettings', (actions) ->
      #We have no matching route, lets just log what the URL was
      if Parse.User.current() is null
        login = "account/login?redirect="+Backbone.history.fragment
        Backbone.history.navigate login, {trigger: true}
      else
        this.closeView()
        accountSettings = new AccountSettings()
        accountSettings.render()
        this.openView(accountSettings)

    app_router.on 'route:defaultAction', (actions) ->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      notFound = new NotFound()
      notFound.render()
      this.openView(notFound)

    Backbone.history.start({
      pushState : true,
      root: '/'
    })

    #on every click, check if it's an href that can be handled by the router
    $(document.body).on 'click', 'a', (event) ->
      local = /^((http:|https:|)(\/\/|)ext-js\.org)/
      href = $(this).attr('href')
      url = local.test(href)

      if url
        event.preventDefault()
        href = href.replace(local,'')
        Backbone.history.navigate(href, {trigger: true});

  return {
    initialize : initialize
  }
