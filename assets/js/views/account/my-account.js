define(["jquery", "underscore", "mustache", "backbone", "parse", "sweetalert", "text!templates/account/my-account.html"], function($, _, Mustache, Backbone, Parse, swal, Template) {
  var View;
  View = Backbone.View.extend({
    el: $('.content'),
    events: {
      'click .logout': 'logout',
      'click .update': 'update',
      'click .reset-passwd': 'resetPassword'
    },
    initialize: function(options) {
      var self;
      self = this;
      self.options = options;
      _.bindAll(this, 'render');
      return this.render();
    },
    render: function() {
      var compiledTemplate, email, user, username;
      user = Parse.User.current();
      username = user.getUsername();
      email = user.getEmail();
      compiledTemplate = Mustache.render(Template, {
        user: username,
        email: email
      });
      this.$el.html(compiledTemplate);
      return $('.loader').fadeOut(100);
    },
    logout: function(e) {
      e.preventDefault();
      Parse.User.logOut();
      return Backbone.history.navigate("/", {
        trigger: true
      });
    },
    update: function(e) {
      var $this, self, user;
      e.preventDefault();
      self = this;
      user = Parse.User.current();
      $this = self.$el.find('.account');
      return swal({
        title: "Are you sure?",
        text: "Updating your account may require you to reverify your email.",
        type: "info",
        showCancelButton: true,
        confirmButtonClass: "btn-primary",
        confirmButtonText: "Ok",
        cancelButtonText: "Cancel"
      }, function() {
        user.set('email', $this.find('.email').val());
        return user.save(null, {
          success: function(plug) {
            return swal("Updated!", "", "success");
          },
          error: function(user, error) {
            return swal("Error!", error.message, "error");
          }
        });
      });
    },
    resetPassword: function(e) {
      var email, user;
      e.preventDefault();
      user = Parse.User.current();
      email = user.getEmail();
      return Parse.User.requestPasswordReset(email, {
        success: function() {
          return swal("", "Password reset email sent to " + email, "success");
        },
        error: function(error) {
          return swal("Error!", error.message, "error");
        }
      });
    }
  });
  return View;
});
