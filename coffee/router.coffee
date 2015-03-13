#Filename: router.js
define [
  'jquery',
  'backbone',

  #load views
  'js/views/404'
  'js/views/home'

  'js/views/documentation'

  'js/views/resources/search-plugins'
  'js/views/resources/plugin'

  'js/views/account/login'
  'js/views/account/signup'
  'js/views/account/password-reset'
  'js/views/account/my-account'
  'js/views/account/my-plugins'

  'js/views/extjs/contact-us'

  'js/views/parse'

], ($, Backbone,
    NotFound,
    Home,

    Doc,

    SearchPlugins,
    Plugin,

    AccountLogin,
    AccountSignup,
    AccountPasswordReset,
    AccountMyAccount,
    AccountMyPlugins,

    ContactUs,

    ParseView

    ) ->

  Backbone.View.prototype.close = () ->
    this.unbind()
    $parent = this.$el.parent().off()
    $el = this.$el.off().empty()
    this.remove()
    $parent.append($el)
    delete this.$el
    delete this.el
    $('.loader').show()
    if this.onClose
      this.onClose()

  AppRouter = Backbone.Router.extend {
    routes :
      #Define some URL routes
      '':                                           'home'
      'documentation/*path(/)':                     'documentation'
      'resources/plugin/*path(/)':                  'plugin'

      #resources
      'resources/search-plugins(?search=:query)(/)':'searchPlugins'

      #account
      'account/login(?redirect=*path)(/)':          'accountLogin'
      'account/signup(?redirect=*path)(/)':         'accountSignup'
      'account/password-reset(?redirect=*path)(/)': 'passwordReset'
      'account/my-plugins(/)(/*path)(/)':           'accountMyPlugins'
      'account/my-account(/)' :                     'accountMyAccount'

      #extjs
      'extjs/contact-us(/)' :                       'contactUs'

      #parse
      'parse(/)(:query)(/)':                        'parse'

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
      home = new Home({})
      this.openView(home)

    app_router.on 'route:documentation', (path) ->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      doc = new Doc({
        doc: path
      })
      this.openView(doc)

    app_router.on 'route:plugin', (path) ->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      plugin = new Plugin({
        plugin: path
      })
      $('.loader').hide()
      this.openView(plugin)

    app_router.on 'route:searchPlugins', (query) ->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      searchPlugins = new SearchPlugins({
        query: query
      })
      this.openView(searchPlugins)



    #account
    app_router.on 'route:accountLogin', (path) ->
      #We have no matching route, lets just log what the URL was
      if Parse.User.current() isnt null
        Backbone.history.navigate "", {trigger: true}
      else
        this.closeView()
        accountLogin = new AccountLogin({
          redirect: path
        })
        this.openView(accountLogin)

    app_router.on 'route:accountSignup', (path) ->
      #We have no matching route, lets just log what the URL was
      if Parse.User.current() isnt null
        Backbone.history.navigate "", {trigger: true}
      else
        this.closeView()
        accountSignup = new AccountSignup({
          redirect: path
        })
        this.openView(accountSignup)

    app_router.on 'route:passwordReset', (path) ->
      #We have no matching route, lets just log what the URL was
      if Parse.User.current() isnt null
        Backbone.history.navigate "account/settings", {trigger: true}
      else
        this.closeView()
        accountPasswordReset = new AccountPasswordReset({
          redirect: path
        })
        this.openView(accountPasswordReset)

    app_router.on 'route:accountMyPlugins', (path) ->
      #We have no matching route, lets just log what the URL was
      if Parse.User.current() is null
        login = "account/login?redirect="+Backbone.history.fragment
        Backbone.history.navigate login, {trigger: true}
      else
        this.closeView()
        accountMyPlugins = new AccountMyPlugins({
          plugin: path
        })
        this.openView(accountMyPlugins)

    app_router.on 'route:accountMyAccount', (actions) ->
      #We have no matching route, lets just log what the URL was
      if Parse.User.current() is null
        login = "account/login?redirect="+Backbone.history.fragment
        Backbone.history.navigate login, {trigger: true}
      else
        this.closeView()
        accountMyAccount = new AccountMyAccount({})
        this.openView(accountMyAccount)



    #extjs
    app_router.on 'route:contactUs', (query) ->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      contactUs = new ContactUs()
      this.openView(contactUs)



    #parse
    app_router.on 'route:parse', (query) ->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      parseView = new ParseView()
      this.openView(parseView)



    #404
    app_router.on 'route:defaultAction', (actions) ->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      notFound = new NotFound()
      this.openView(notFound)

    Backbone.history.start({
      pushState : true,
      root: '/'
    })

    #hack internal links
    $(document.body).on 'click', 'a', (event) ->
      local = /^((http:|https:|)(\/\/|)(www|)ext-js\.org)/
      href = $(this).attr('href')
      url = local.test(href)
      elm = href.indexOf('#') isnt -1 and href.indexOf('/#') is -1

      if url and !elm
        event.preventDefault()
        href = href.replace(local,'')
        Backbone.history.navigate(href, {trigger: true});

  return {
    initialize : initialize
  }
