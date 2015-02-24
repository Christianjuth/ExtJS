define(["jquery", "underscore", "mustache", "backbone", "parse", "sweetalert", "text!templates/account/login.html"], function($, _, Mustache, Backbone, Parse, swal, Template) {
  var View;
  View = Backbone.View.extend({
    el: $('.content'),
    events: {
      'submit .login': 'login',
      'click .signup': 'redirectSignup',
      'click .reset-password': 'resetPassword'
    },
    initialize: function(options) {
      var self;
      self = this;
      self.options = options;
      _.bindAll(this, 'render');
      return this.render();
    },
    render: function() {
      var compiledTemplate;
      compiledTemplate = Mustache.render(Template, {});
      this.$el.html(compiledTemplate);
      return $('.loader').fadeOut(100);
    },
    login: function(e) {
      var $form, password, self, username;
      e.preventDefault();
      self = this;
      $form = $(".login");
      username = $form.find(".username").val();
      password = $form.find(".password").val();
      Parse.User.logIn(username, password, {
        success: function(user) {
          return Backbone.history.navigate(self.options.redirect, {
            trigger: true
          });
        },
        error: function(user, error) {
          return swal("Error!", error.message, "error");
        }
      });
      return false;
    },
    redirectSignup: function(e) {
      var self, url;
      e.preventDefault();
      self = this;
      url = "account/signup?redirect=" + self.options.redirect;
      return Backbone.history.navigate(url, {
        trigger: true,
        replace: true
      });
    },
    resetPassword: function(e) {
      var self, url;
      e.preventDefault();
      self = this;
      url = "account/password-reset?redirect=" + self.options.redirect;
      return Backbone.history.navigate(url, {
        trigger: true
      });
    }
  });
  return View;
});
