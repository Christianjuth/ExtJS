define(["jquery", "underscore", "mustache", "backbone", "parse", "sweetalert", "text!templates/password-reset.html"], function($, _, Mustache, Backbone, Parse, swal, Template) {
  var View;
  View = Backbone.View.extend({
    el: $('.content'),
    events: {
      'submit .reset-password': 'resetPasswd'
    },
    initilize: function(url) {
      this.redirect = url;
      return this.render();
    },
    render: function() {
      var compiledTemplate;
      compiledTemplate = Mustache.render(Template, {});
      this.$el.html(compiledTemplate);
      return $('.loader').fadeOut(100);
    },
    resetPasswd: function(e) {
      var $el, email, self;
      e.preventDefault();
      self = this;
      $el = self.$el;
      email = $el.find('.email').val();
      return Parse.User.requestPasswordReset(email, {
        success: function() {
          swal("", "Password reset email sent to " + email, "success");
          return Backbone.history.navigate(self.redirect, {
            trigger: true
          });
        },
        error: function(error) {
          return swal("Error!", error.message, "error");
        }
      });
    }
  });
  return View;
});
