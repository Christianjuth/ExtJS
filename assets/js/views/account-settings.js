define(["jquery", "underscore", "mustache", "backbone", "parse", "text!templates/account-settings.html"], function($, _, Mustache, Backbone, Parse, Template) {
  var View;
  View = Backbone.View.extend({
    el: $('.content'),
    events: {
      'click .logout': 'logout'
    },
    render: function() {
      var $form, compiledTemplate, data, email, user, username;
      user = Parse.User.current();
      username = user.getUsername();
      email = user.getEmail();
      data = {};
      compiledTemplate = _.template(Template, data);
      this.$el.html(compiledTemplate);
      $form = $('.account');
      $form.find('.name').text(username);
      $form.find('.email').text(email);
      if (window.innerWidth < 850) {
        $(".sidebar .links").slideUp();
        $(".sidebar").attr("toggle", "false");
      }
      return $('.loader').fadeOut(100);
    },
    logout: function(e) {
      e.preventDefault();
      Parse.User.logOut();
      return Backbone.history.navigate("account/login", {
        trigger: true
      });
    }
  });
  return View;
});
