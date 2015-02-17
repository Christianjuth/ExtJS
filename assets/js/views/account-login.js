define(["jquery", "underscore", "backbone", "parse", "text!templates/login.html"], function($, _, Backbone, Parse, Template) {
  var View;
  View = Backbone.View.extend({
    el: $('.content'),
    events: {
      'submit .login': 'login'
    },
    initilize: function(url) {
      this.url = url;
      return this.render();
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
          return alert("Error: " + JSON.stringify(error));
        }
      });
    }
  });
  return View;
});
