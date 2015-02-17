define(["jquery", "underscore", "mustache", "backbone", "parse", "text!templates/login.html"], function($, _, Mustache, Backbone, Parse, Template) {
  var View;
  View = Backbone.View.extend({
    el: $('.content'),
    events: {
      'submit .login': 'login',
      'submit .sign-up': 'signup'
    },
    initilize: function(url) {
      this.url = url;
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
      return Parse.User.logIn(username, password, {
        success: function(user) {
          return Backbone.history.navigate(self.url, {
            trigger: true
          });
        },
        error: function(user, error) {
          return alert(error.message);
        }
      });
    },
    signup: function(e) {
      var $form, email, password, self, user, username;
      e.preventDefault();
      self = this;
      $form = $(".sign-up");
      username = $form.find(".username").val();
      password = $form.find(".password").val();
      email = $form.find(".email").val();
      user = new Parse.User();
      user.set('username', username);
      user.set('password', password);
      user.set('email', email);
      return user.signUp(null, {
        success: function(user) {
          return Backbone.history.navigate(self.url, {
            trigger: true
          });
        },
        error: function(user, error) {
          return alert(error.message);
        }
      });
    }
  });
  return View;
});
