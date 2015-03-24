#Filename: router.js
define [
  'jquery',
  'backbone',

  #load views
  'js/views/404'
  'js/views/home'

  'js/views/documentation/documentation-id'
  'js/views/documentation/documentation'

  'js/views/resources/search-plugins'
  'js/views/resources/plugin'
  'js/views/resources/extjs-downloads'

  'js/views/account/account'
  'js/views/account/login'
  'js/views/account/signup'
  'js/views/account/password-reset'
  'js/views/account/my-account'
  'js/views/account/my-plugins'

  'js/views/extjs/contact-us'

  'js/views/github/issue'
  'js/views/github/issue-id'

  'js/views/mail/thank-you'
  'js/views/mail/unsubscribe'
  'js/views/mail/subscribe'
  'js/views/mail/confirm'

  'js/views/parse'

], ($, Backbone,
    NotFound,
    Home,

    DocumentationDocumentationId,
    DocumentationDocumentation,

    SearchPlugins,
    Plugin,
    ExtJSDownloads,

    AccountAccount,
    AccountLogin,
    AccountSignup,
    AccountPasswordReset,
    AccountMyAccount,
    AccountMyPlugins,

    ContactUs,

    GithubIssue,
    GithubIssueId,

    MailThankYou,
    MailUnsubscribe,
    MailSubscribe,
    MailConfirm,

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
      'documentation/*path(/)':                     'documentationDocumentationId'
      'documentation(/)':                           'documentationDocumentation'
      'resources/plugin/*path(/)':                  'plugin'

      #resources
      'resources/search-plugins(?search=:query)(/)':'searchPlugins'
      'resources/extjs-downloads(/)':               'extjsDownloads'

      #account
      'account/login(?redirect=*path)(/)':          'accountLogin'
      'account/signup(?redirect=*path)(/)':         'accountSignup'
      'account/password-reset(?redirect=*path)(/)': 'passwordReset'
      'account/my-plugins(/)(/*path)(/)':           'accountMyPlugins'
      'account/my-account(/)' :                     'accountMyAccount'
      'account(/)':                                 'accountAccount'

      #extjs
      'extjs/contact-us(/)' :                       'contactUs'

      'github/issue/:id(/)' :                       'githubIssueId'
      'github/issue(/)' :                           'githubIssue'

      #parse
      'parse(/)(:query)(/)':                        'parse'

      #mail
      'mail/thank-you(/)':                          'mailThankYou'
      'mail/unsubscribe(/)':                        'mailUnsubscribe'
      'mail/subscribe(?search=:query)(/)(/)':       'mailSubscribe'
      'mail/confirm(/)':                            'mailConfirm'

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
      url = location.pathname.replace(/^(\/)/i,'').replace(/(\/.*)$/i,'')
      $('.menu-sidebar li').removeClass('active')
      $('.menu-sidebar li[href^="'+url+'"]').addClass('active')
      $(window).scrollTop(0)


    #DEFINE ROUT FUNCTIONS
    app_router.on 'route:home', ()->
      this.closeView()
      home = new Home({})
      this.openView(home)

    app_router.on 'route:documentationDocumentation', ()->
      this.closeView()
      documentationDocumentation = new DocumentationDocumentation({})
      this.openView(documentationDocumentation)

    app_router.on 'route:documentationDocumentationId', (path)->
      this.closeView()
      documentationDocumentationId = new DocumentationDocumentationId({
        doc: path
      })
      this.openView(documentationDocumentationId)

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

    app_router.on 'route:extjsDownloads', (query)->
      this.closeView()
      extjsDownloads = new ExtJSDownloads()
      this.openView(extjsDownloads)



    #ACCOUNT
    app_router.on 'route:accountAccount', ()->
      if Parse.User.current() is null
        login = "account/login?redirect="+Backbone.history.fragment
        Backbone.history.navigate login, {trigger: true}
      else
        this.closeView()
        accountAccount = new AccountAccount()
        this.openView(accountAccount)

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



    #GITHUB
     app_router.on 'route:githubIssue', (id)->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      githubIssue = new GithubIssue({})
      this.openView(githubIssue)

    app_router.on 'route:githubIssueId', (id)->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      githubIssue = new GithubIssueId({
        id: id
      })
      this.openView(githubIssue)



    #PARSE
    app_router.on 'route:parse', (query)->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      parseView = new ParseView()
      this.openView(parseView)



    #Mail
    app_router.on 'route:mailThankYou', ->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      mailThankYou = new MailThankYou()
      this.openView(mailThankYou)

    app_router.on 'route:mailSubscribe', ->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      mailSubscribe = new MailSubscribe()
      this.openView(mailSubscribe)

    app_router.on 'route:mailUnsubscribe', ->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      mailUnsubscribe = new MailUnsubscribe()
      this.openView(mailUnsubscribe)

    app_router.on 'route:mailConfirm', ->
      #We have no matching route, lets just log what the URL was
      this.closeView()
      mailConfirm = new MailConfirm()
      this.openView(mailConfirm)



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
    $(document.body).on 'click', 'a, .link', (event)->
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
      if (url or relative) and (!elm or !sameOrigin)
        event.preventDefault()
        href = href.replace(local,'')
        Backbone.history.navigate(href, {trigger: true})


  return {
    initialize : initialize
  }
