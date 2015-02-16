define(["jquery", "underscore", "parse", "text!templates/login.html"], function($, _, Parse, Template) {
  var View;
  View = Parse.View.extend({
    el: $('.content'),
    events: {
      'submit .login': 'login'
    },
    render: function() {
      var compiledTemplate, data;
      data = {};
      compiledTemplate = _.template(Template, data);
      this.$el.html(compiledTemplate);
      if (window.innerWidth < 850) {
        $(".sidebar .links").slideUp();
        $(".sidebar").attr("toggle", "false");
      }
      return $('.loader').fadeOut(100);
    },
    login: function(e) {
      var $form, password, username;
      e.preventDefault();
      $form = $(".login");
      username = $form.find(".username").val();
      password = $form.find(".password").val();
      return Parse.User.logIn(username, password, {
        success: function(user) {
          return Parse.history.navigate("account/plugins", {
            trigger: true,
            replace: true
          });
        },
        error: function(user, error) {
          return alert("Error: " + JSON.stringify(error));
        }
      });
    }
  });
  return View;
});
