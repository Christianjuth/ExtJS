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

    )->



  Backbone.View.prototype.close = ->
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

  Backbone.View.prototype.show = ->
    self = this
    $el = self.$el
    hash = location.hash
    if hash isnt '' and $(hash).length > 0
      scroll = $el.scrollTop() - $el.offset().top + $(hash).offset().top
      $el.scrollTop(scroll)
    $('.loader').stop().fadeOut(100)



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



  initialize = ()->
    #DEFINE APP ROUTER
    app_router = new AppRouter

    #DEFINE FUNCTIONS
    app_router.closeView = ()->
      if this.currentView
        this.currentView.close()

    app_router.openView = (view)->
      this.currentView = view
      if window.innerWidth < 850
        $(".sidebar .links").slideUp()
        $(".sidebar").attr("toggle","false")
      $(window).scrollTop(0)


    #DEFINE ROUT FUNCTIONS
    app_router.on 'route:home', ()->
      this.closeView()
      home = new Home({})
      this.openView(home)

    app_router.on 'route:documentation', (path)->
      this.closeView()
      doc = new Doc({
        doc: path
      })
      this.openView(doc)

    app_router.on 'route:plugin', (path)->
      this.closeView()
      plugin = new Plugin({
        plugin: path
      })
      $('.loader').hide()
      this.openView(plugin)

    app_router.on 'route:searchPlugins', (query)->
      this.closeView()
      searchPlugins = new SearchPlugins({
        query: query
      })
      this.openView(searchPlugins)



    #ACCOUNT
    app_router.on 'route:accountLogin', (path)->
      if Parse.User.current() isnt null
        Backbone.history.navigate "", {trigger: true}
      else
        this.closeView()
        accountLogin = new AccountLogin({
          redirect: path
        })
        this.openView(accountLogin)

    app_router.on 'route:accountSignup', (path)->
      if Parse.User.current() isnt null
        Backbone.history.navigate "", {trigger: true}
      else
        this.closeView()
        accountSignup = new AccountSignup({
          redirect: path
        })
        this.openView(accountSignup)

    app_router.on 'route:passwordReset', (path)->
      if Parse.User.current() isnt null
        Backbone.history.navigate "account/settings", {trigger: true}
      else
        this.closeView()
        accountPasswordReset = new AccountPasswordReset({
          redirect: path
        })
        this.openView(accountPasswordReset)

    app_router.on 'route:accountMyPlugins', (path)->
      if Parse.User.current() is null
        login = "account/login?redirect="+Backbone.history.fragment
        Backbone.history.navigate login, {trigger: true}
      else
        this.closeView()
        accountMyPlugins = new AccountMyPlugins({
          plugin: path
        })
        this.openView(accountMyPlugins)

    app_router.on 'route:accountMyAccount', (actions)->
      if Parse.User.current() is null
        login = "account/login?redirect="+Backbone.history.fragment
        Backbone.history.navigate login, {trigger: true}
      else
        this.closeView()
        accountMyAccount = new AccountMyAccount({})
        this.openView(accountMyAccount)



    #EXTJS
    app_router.on 'route:contactUs', (query)->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      contactUs = new ContactUs()
      this.openView(contactUs)



    #PARSE
    app_router.on 'route:parse', (query)->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      parseView = new ParseView()
      this.openView(parseView)



    #404 fallback
    app_router.on 'route:defaultAction', (actions)->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      notFound = new NotFound()
      this.openView(notFound)



    #start history without "#"
    Backbone.history.start({
      pushState : true,
      root: '/'
    })



    #hack internal links matching location.host
    $(document.body).on 'click', 'a', (event)->
      #define vars
      host = document.location.host
      href =       $(this).attr('href')
      local =      new RegExp('^((http:\/\/|https:\/\/|)(www|)'+host+')', 'i')
      fullPath =   /^((http:\/\/|https:\/\/|)(([^\.:]*)(\/.+|)))$/i
      url =        local.test(href)
      relative =   fullPath.test(href)
      sameOrigin = host is href.replace(/(#.*)$/,'')
      elm =        href.indexOf('#') isnt -1 and href.indexOf('/#') is -1
      #logic
      if (url or relative) and (!elm and !sameOrigin)
        event.preventDefault()
        href = href.replace(local,'')
        Backbone.history.navigate(href, {trigger: true})


  return {
    initialize : initialize
  }
