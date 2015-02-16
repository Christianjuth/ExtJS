#Filename: router.js
define [
  'jquery',
  'underscore',
  'parse',

  #load views
  'assets/js/views/404',
  'assets/js/views/documentation',
  'assets/js/views/plugin',
  'assets/js/views/home'
  'assets/js/views/account-plugins'
  'assets/js/views/account-login'
  'assets/js/views/account-settings'
  'assets/js/views/search-plugins'

], ($, _, Parse, NotFound, Doc, Plugin, Home, AccountPlugins, AccountLogin, AccountSettings, SearchPlugins) ->

  Parse.View.prototype.close = () ->
    console.log('Unbinding events for ' + this.cid)
    this.$el.empty().unbind()
    $('.loader').show()
    if this.onClose
      this.onClose()

  AppRouter = Parse.Router.extend {
    routes :
      #Define some URL routes
      '': 'home',
      'documentation/*path':         'doc'
      'plugin/*path':                'plugin'
      'search/plugins?:query':       'searchPlugins'
      'account/login':               'accountLogin'
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
        Parse.history.navigate "account/login", {trigger: true}
      else
        this.closeView()
        accountPlugins = new AccountPlugins()
        accountPlugins.render()
        this.openView(accountPlugins)

    app_router.on 'route:accountLogin', () ->
      #We have no matching route, lets just log what the URL was
      if Parse.User.current() isnt null
        Parse.history.navigate "account/plugins", {trigger: true}
      else
        this.closeView()
        accountLogin = new AccountLogin()
        accountLogin.render()
        this.openView(accountLogin)

    app_router.on 'route:accountSettings', (actions) ->
      #We have no matching route, lets just log what the URL was
      if Parse.User.current() is null
        Parse.history.navigate "account/login", {trigger: true}
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

    Parse.history.start({
      pushState : true,
      root: '/'
    })

    #on every click, check if it's an href that can be handled by the router
    $(document.body).on 'click', 'a', (event) ->
      local = /^((http:|https:|)(\/\/|)dev\.ext-js\.org)/
      href = $(this).attr('href')
      url = local.test(href)

      if url
        event.preventDefault()
        href = href.replace(local,'')
        Parse.history.navigate(href, {trigger: true});

  return {
    initialize : initialize
  }
