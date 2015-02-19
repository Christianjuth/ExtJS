define(["jquery", "underscore", "mustache", "backbone", "parse", "sweetalert", "text!templates/my-account.html"], function($, _, Mustache, Backbone, Parse, swal, Template) {
  var View;
  View = Backbone.View.extend({
    el: $('.content'),
    events: {
      'click .logout': 'logout',
      'click .update': 'update'
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
      user.set('email', $this.find('.email').val());
      return user.save(null, {
        success: function(plug) {
          return swal("Updated!", "", "success");
        },
        error: function(user, error) {
          return swal("Error!", error.message, "error");
        }
      });
    }
  });
  return View;
});
