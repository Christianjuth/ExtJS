define(["jquery", "underscore", "mustache", "backbone", "parse", "sweetalert", "text!templates/account/signup.html"], function($, _, Mustache, Backbone, Parse, swal, Template) {
  var View;
  View = Backbone.View.extend({
    el: $('.content'),
    events: {
      'submit .sign-up': 'signup'
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
          return Backbone.history.navigate(self.options.redirect, {
            trigger: true
          });
        },
        error: function(user, error) {
          return swal("Error!", error.message, "error");
        }
      });
    }
  });
  return View;
});
