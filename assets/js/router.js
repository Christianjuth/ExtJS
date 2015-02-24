define(['jquery', 'underscore', 'backbone', 'parse', 'js/views/404', 'js/views/home', 'js/views/documentation', 'js/views/resources/search-plugins', 'js/views/resources/plugin', 'js/views/account/login', 'js/views/account/signup', 'js/views/account/password-reset', 'js/views/account/my-account', 'js/views/account/my-plugins'], function($, _, Backbone, Parse, NotFound, Home, Doc, SearchPlugins, Plugin, AccountLogin, AccountSignup, AccountPasswordReset, AccountSettings, AccountPlugins) {
  var AppRouter, initialize;
  Backbone.View.prototype.close = function() {
    this.$el.empty().unbind();
    $('.loader').show();
    if (this.onClose) {
      return this.onClose();
    }
  };
  AppRouter = Backbone.Router.extend({
    routes: {
      '': 'home',
      'documentation/*path': 'doc',
      'resources/plugin/*path': 'plugin',
      'resources/search-plugins(?search=:query)': 'searchPlugins',
      'account/login(?redirect=*path)': 'accountLogin',
      'account/signup(?redirect=*path)': 'accountSignup',
      'account/password-reset(?redirect=*path)': 'passwordReset',
      'account/plugins': 'accountPlugins',
      'account/settings': 'accountSettings',
      '*splat': 'defaultAction'
    }
  });
  initialize = function() {
    var app_router;
    app_router = new AppRouter;
    app_router.closeView = function() {
      if (this.currentView) {
        return this.currentView.close();
      }
    };
    app_router.openView = function(view) {
      this.currentView = view;
      if (window.innerWidth < 850) {
        $(".sidebar .links").slideUp();
        $(".sidebar").attr("toggle", "false");
      }
      return $(window).scrollTop(0);
    };
    app_router.on('route:home', function() {
      var home;
      this.closeView();
      home = new Home({});
      return this.openView(home);
    });
    app_router.on('route:doc', function(path) {
      var doc;
      this.closeView();
      doc = new Doc({
        file: path
      });
      return this.openView(doc);
    });
    app_router.on('route:plugin', function(path) {
      var plugin;
      this.closeView();
      plugin = new Plugin({
        plugin: path
      });
      $('.loader').hide();
      return this.openView(plugin);
    });
    app_router.on('route:searchPlugins', function(query) {
      var searchPlugins;
      this.closeView();
      searchPlugins = new SearchPlugins({
        query: query
      });
      return this.openView(searchPlugins);
    });
    app_router.on('route:accountPlugins', function() {
      var accountPlugins, login;
      if (Parse.User.current() === null) {
        login = "account/login?redirect=" + Backbone.history.fragment;
        return Backbone.history.navigate(login, {
          trigger: true
        });
      } else {
        this.closeView();
        accountPlugins = new AccountPlugins();
        accountPlugins.render();
        return this.openView(accountPlugins);
      }
    });
    app_router.on('route:accountLogin', function(path) {
      var accountLogin;
      if (Parse.User.current() !== null) {
        return Backbone.history.navigate("", {
          trigger: true
        });
      } else {
        this.closeView();
        accountLogin = new AccountLogin({
          redirect: path
        });
        return this.openView(accountLogin);
      }
    });
    app_router.on('route:accountSignup', function(path) {
      var accountSignup;
      if (Parse.User.current() !== null) {
        return Backbone.history.navigate("", {
          trigger: true
        });
      } else {
        this.closeView();
        accountSignup = new AccountSignup({
          redirect: path
        });
        return this.openView(accountSignup);
      }
    });
    app_router.on('route:passwordReset', function(path) {
      var accountPasswordReset;
      if (Parse.User.current() !== null) {
        return Backbone.history.navigate("account/settings", {
          trigger: true
        });
      } else {
        this.closeView();
        accountPasswordReset = new AccountPasswordReset({
          redirect: path
        });
        return this.openView(accountPasswordReset);
      }
    });
    app_router.on('route:accountSettings', function(actions) {
      var accountSettings, login;
      if (Parse.User.current() === null) {
        login = "account/login?redirect=" + Backbone.history.fragment;
        return Backbone.history.navigate(login, {
          trigger: true
        });
      } else {
        this.closeView();
        accountSettings = new AccountSettings({});
        return this.openView(accountSettings);
      }
    });
    app_router.on('route:defaultAction', function(actions) {
      var notFound;
      this.closeView();
      notFound = new NotFound();
      notFound.render();
      return this.openView(notFound);
    });
    Backbone.history.start({
      pushState: true,
      root: '/'
    });
    return $(document.body).on('click', 'a', function(event) {
      var href, local, url;
      local = /^((http:|https:|)(\/\/|)ext-js\.org)/;
      href = $(this).attr('href');
      url = local.test(href);
      if (url) {
        event.preventDefault();
        href = href.replace(local, '');
        return Backbone.history.navigate(href, {
          trigger: true
        });
      }
    });
  };
  return {
    initialize: initialize
  };
});
