define(['jquery', 'underscore', 'parse', 'assets/js/views/404', 'assets/js/views/documentation', 'assets/js/views/plugin', 'assets/js/views/home', 'assets/js/views/account-plugins', 'assets/js/views/account-login', 'assets/js/views/account-settings', 'assets/js/views/search-plugins'], function($, _, Parse, NotFound, Doc, Plugin, Home, AccountPlugins, AccountLogin, AccountSettings, SearchPlugins) {
  var AppRouter, initialize;
  Parse.View.prototype.close = function() {
    console.log('Unbinding events for ' + this.cid);
    this.$el.empty().unbind();
    $('.loader').show();
    if (this.onClose) {
      return this.onClose();
    }
  };
  AppRouter = Parse.Router.extend({
    routes: {
      '': 'home',
      'documentation/*path': 'doc',
      'plugin/*path': 'plugin',
      'search/plugins?:query': 'searchPlugins',
      'account/login': 'accountLogin',
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
      return $(window).scrollTop(0);
    };
    app_router.on('route:home', function() {
      var home;
      this.closeView();
      home = new Home();
      home.render();
      return this.openView(home);
    });
    app_router.on('route:doc', function(path) {
      var doc;
      this.closeView();
      doc = new Doc();
      doc.render(path);
      return this.openView(doc);
    });
    app_router.on('route:plugin', function(path) {
      var plugin;
      this.closeView();
      plugin = new Plugin({
        plugin: path
      });
      plugin.initialize();
      $('.loader').hide();
      return this.openView(plugin);
    });
    app_router.on('route:searchPlugins', function(query) {
      var searchPlugins;
      this.closeView();
      searchPlugins = new SearchPlugins({
        search: query
      });
      searchPlugins.initialize();
      return this.openView(searchPlugins);
    });
    app_router.on('route:accountPlugins', function() {
      var accountPlugins;
      if (Parse.User.current() === null) {
        return Parse.history.navigate("account/login", {
          trigger: true
        });
      } else {
        this.closeView();
        accountPlugins = new AccountPlugins();
        accountPlugins.render();
        return this.openView(accountPlugins);
      }
    });
    app_router.on('route:accountLogin', function() {
      var accountLogin;
      if (Parse.User.current() !== null) {
        return Parse.history.navigate("account/plugins", {
          trigger: true
        });
      } else {
        this.closeView();
        accountLogin = new AccountLogin();
        accountLogin.render();
        return this.openView(accountLogin);
      }
    });
    app_router.on('route:accountSettings', function(actions) {
      var accountSettings;
      if (Parse.User.current() === null) {
        return Parse.history.navigate("account/login", {
          trigger: true
        });
      } else {
        this.closeView();
        accountSettings = new AccountSettings();
        accountSettings.render();
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
    Parse.history.start({
      pushState: true,
      root: '/'
    });
    return $(document.body).on('click', 'a', function(event) {
      var href, local, url;
      local = /^((http:|https:|)(\/\/|)dev\.ext-js\.org)/;
      href = $(this).attr('href');
      url = local.test(href);
      if (url) {
        event.preventDefault();
        href = href.replace(local, '');
        return Parse.history.navigate(href, {
          trigger: true
        });
      }
    });
  };
  return {
    initialize: initialize
  };
});
